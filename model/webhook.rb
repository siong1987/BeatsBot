class Webhook < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true

  def self.post_to_slack(url, beat)
    payload = {
      username: 'BeatsBot',
      icon_emoji: ':radio:',
      attachments: [
        {
          fallback: "#{beat.title} - #{beat.artist}",
          title: "#{beat.title} - #{beat.artist}",
          title_link: beat.url,
          image_url: beat.image_url
        }
      ]
    }

    Faraday.post(url, { payload: payload.to_json })
  end
end
