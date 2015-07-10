class Beat < ActiveRecord::Base
  validates :title, presence: true
  validates :artist, presence: true

  def self.update_latest
    beat = Beat.last

    payload = {
      title: beat.title,
      artist: beat.artist,
      itunes_link: beat.url,
      album_cover: beat.image_url
    }

    $redis.set('latest', payload.to_json)
  end
end
