# hood-link

> fume hood monitoring engine for organizations

Open Source Application Stack:

> [d3](https://github.com/mbostock/d3) graphing & [oboe](https://github.com/jimhigson/oboe.js) requests  
> [backbone](https://github.com/jashkenas/backbone) client framework  
> [ruby on rails](https://github.com/rails/rails) server framework  
> [redis](https://github.com/antirez/redis) & [resque](https://github.com/resque/resque) background jobs  
> [memcached](https://github.com/memcached/memcached) session store & cache  
> [postgres](https://github.com/postgres/postgres) rdbms  

## Installation

## API

## Tasks

```
$ rake admins
```

seeds users with email from `config/admins.yml` and grants them admin roles. 

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

---

> Alexander Ostrow, Fall 2013  

(c) Glencross Brunet. All rights reserved.