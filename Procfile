web: bundle exec puma -t ${PUMA_MIN_THREADS:-8}:${PUMA_MAX_THREADS:-12} -w ${PUMA_WORKERS:-2} -p $PORT -e production
resque: env TERM_CHILD=1 QUEUE="*" bundle exec rake resque:work