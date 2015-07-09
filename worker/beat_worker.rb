require './beats1/now_playing'
require 'itunes-search-api'
require 'opengraph_parser'

class BeatWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false, dead: false
  recurrence { minutely }

  def perform
    np = Beats1::NowPlaying.now_playing
    raise np.inspect unless (artist = np[:artist]) && (title = np[:title])
    last_beat = Beat.last

    if last_beat && last_beat.title == title && last_beat.artist == artist
      return
    end

    url = ""
    begin
      res = ITunesSearchAPI.search(term: "#{title} - #{artist}", country: "US", media: "music")
      res && (first = res[0]) && (url = first["trackViewUrl"])
    rescue StandardError => e
      STDERR.puts "ITunesSearch error: #{e}"
    end

    image_url = ""
    if url
      og = OpenGraph.new(url)
      image_url = og.images.first
    end

    beat = Beat.create(title: title, artist: artist, url: url, image_url: image_url)
    User.find_each do |user|
      SlackWorker.perform_async(user.id, beat.id)
    end
  end
end
