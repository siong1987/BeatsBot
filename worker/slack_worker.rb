class SlackWorker
  include Sidekiq::Worker

  def perform
    puts 'hi'
  end
end
