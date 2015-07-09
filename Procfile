web: bundle exec thin start -p $PORT
worker: bundle exec sidekiq -r ./worker/base.rb -c 20 -v
