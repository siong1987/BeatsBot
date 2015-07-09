class SlackWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false

  def perform(webhook_id, beat_id)
    webhook = Webhook.find(webhook_id)
    beat = Beat.find(beat_id)

    Webhook.post_to_slack(webhook.url, beat)
  end
end
