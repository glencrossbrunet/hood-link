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

> Dependencies: Git, Ruby, Redis, Postgres

#### OSX

Google for Git, and Ruby. See [AJ's Installing Postgres Article](http://www.ajostrow.me/thoughts/installing-postgres-on-osx#nav). For redis use Homebrew. 

```
$ brew install redis
```

#### Linux

???

#### Windows

???

#### Install Application

Once you have the dependencies ready to go, clone the repository to the folder of your choice:

```
$ git clone git@github.com:glencrossbrunet/hood-link.git
$ cd hood-link
```

Use Bundler to install ruby dependencies:

```
$ bundle install --binstubs
```

Start postgresql and redis on different command lines:

```
$ pg_ctl -D /usr/local/var/postgres -l logfile start
$ redis-server
```

Create the databases:

```
$ RAILS_ENV=test rake db:create db:migrate
$ RAILS_ENV=development rake db:create db:migrate
```

Run the test suite:

```
$ rspec
```

## API

Within and organization subdomain, these are the json endpoints used by the client app (in no particular order). 

```
GET /roles
```

Get all roles (member | admin) and the email address associated with the account. 

```
POST /roles
```

Grant access to a new email address at member or admin privileges. Creates a new user with a random password if necessary. TODO: send notification email

```
DELETE /roles/:email
```

Revokes all access to organization dashboard for the user associated with the email. 

```
GET /fume_hoods
```

Get all fume hoods with external id and data for displaying. Data defaults to filter fields of organization. 

```
POST /fume_hoods
```

Create a new fume hood with a specific external id

```
PUT /fume_hoods/:id
PATCH /fume_hoods/:id
```

Update a fume hood with new data. Replaces all data. TODO: never remove fields. 

```
GET /filters
```

Get all filter fields.

```
POST /filters
```

Create a new filter field.

```
PUT /filters/:id
PATCH /filters/:id
```

Edit filter field. TODO: queue a job that corrects data key for fume hoods

```
DELETE /filters/:id
```

Remove filter field. Does not delete data, so you can always get it back. 

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