```
$ rake admins
```

Take each email in `config/admins.yml` and grant it unconditional `:admin` role. This means the users with those emails are administrators for every organization.

```
$ rake aggregates:percent_open
```

queues a job for each fume hood to crunch the `"Percent Open"` sample metric for the last month, and caches it in the aggregates json blob by the ID of the sample metric. queue is `:aggregates`

```
$ rake displays:update
```

queues a job for each organization to find the best percent open, and then update each fume hood through the device cloud API. queue is `:displays`

```
$ rake resque:work QUEUE="*"
```

create a worker and start processing background jobs. the `Queue="*"` is an optional default. set it to a different queue name if necessary. 
