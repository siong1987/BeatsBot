class SlackWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false

  def perform(webhook_id, beat_id)
    webhook = Webhook.find(webhook_id)
    if webhook.url
      beat = Beat.find(beat_id)

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

      Faraday.post(webhook.url, { payload: payload.to_json })
    end
  end
end
