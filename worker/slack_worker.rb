class SlackWorker
  include Sidekiq::Worker

  def perform(user_id, beat_id)
    user = User.find(user_id)
    if user.slack_webhook_url
      beat = Beat.find(beat_id)
      Faraday.post(user.slack_webhook_url, { payload: { username: 'beatsbot', text: "#{beat.title} - #{beat.artist}"}.to_json })
    end
  end
end
