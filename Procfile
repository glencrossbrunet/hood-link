web: bundle exec rails server -p $PORT
resque: env TERM_CHILD=1 QUEUE="*" bundle exec rake resque:work