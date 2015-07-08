require './beats1/now_playing'

class BeatWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    np = Beats1::NowPlaying.now_playing
    raise np.inspect unless (artist = np[:artist]) && (title = np[:title])
    last_beat = Beat.last

    if last_beat && last_beat.title == title && last_beat.artist == artist
      return
    end

    Beat.create(title: title, artist: artist)
    puts "#{title} - #{artist}"
  end
end
