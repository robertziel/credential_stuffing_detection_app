# Credential stuffing detection microservice

## API

`PUT /detect`

  Body **form-data**:
  * **email** | string
  * **event_name** | string
  * **ip** | string


  Possible feedback:
  * Success:

  ```json
  {
      "detected_attack": false/true
  }
  ```

  * If wrong parameters passed:

  ```json
  {
      "errors": {
        "email": [
          "can't be blank"
        ],
        "event_name": [
          "can't be blank"
        ],
        "ip": [
          "can't be blank"
        ]
      }
  }
  ```


## Setup locally (development)

Make sure your console uses right environment as default

```bash
export RACK_ENV=development
```

Use `.env.example` to set environmental variables:
```bash
POSTGRES_DB
POSTGRES_PASSWORD # in production only
POSTGRES_USERNAME
POSTGRES_HOST
```

Start service locally:
```bash
bundle exec rackup -p 3000
```

## Before commit
Set up overcommit to make sure your code is clean :) :

```bash
gem install overcommit
bundle install --gemfile=.overgems.rb
overcommit --install
```
Then you can commit your changes! And don't forget to run specs before:

```bash
bundle exec rspec
```

## Docker (production)

Prepare env file:
```bash
cp .env.docker.example .env.docker
```

Build:
```bash
docker-compose build
```
Set up database and load sample data (for performance test):
```bash
docker-compose run web rake db:create db:migrate db:seed
```
Start containers and check localhost:8080:
```bash
docker-compose up
```
Shut down containers:
```bash
docker-compose down
```

## Apache Bench performance tests

If we have docker running properly we can do following performance test:

`ab -k -n 10000 -c 100 -u benchmark_data.json -T form-data http://localhost:8080/detect`

(If above command does not work you can install it on mac using brew `brew install homebrew/apache/ab`)

#### Tests results

Each address has ***1 event***\
Each event has ***50 emails*** and ***250 requests***

To prepare sample data run `rake db:seed` locally or `docker-compose run web rake db:seed` on docker

Number of Addresses seeded | Requests [#/sec] (mean)
--- | ---
1 | 469.39
10 | 449.21
100 | 443.00
1 000 | 400.36
10 000 | 396.71

#### Slowest areas analysis:

Best way to detect slowest queries in app is to use services like Scout or New Relic. But we can clearly theoretically we can expect some parts to be slow and that some day they need to be improved as traffic grows.

* ***Address*** is the first element searched in database. As far as traffic is low (and we have below 10 million rows in table) it should not be an issue. As records are searched by ***ip***, index should be changed to `inet_ops`.

* ***Event*** is currently mainly searched by index in foreign_key address_id and it's name. One address probably never has many events but to improve seach we may compbine index consisting address_id and name

* ***Email*** this table may grow quickly and cause performance issues in the future. First of all we should add index for ***event_id, last_detected_at*** and ***event_id, value***. Secondly, we should consider removing old data if no longer are necessary.

* ***Request*** this table is the biggest issue in the app as it grows constantly with traffic and it grows more than any other table. As in email table we should consider adding index ***event_id, detected_at*** and deleting old data.

* In case of banned address we should consider not saving any further data about it's requests.


## Constants

Following constants can be set by adding them to `.env` or `.env.docker`

Env name | Default value | | Description
--- | --- | --- | ---
IP_BAN_TIME | 30 (sec) | X | how long an IP is banned in seconds
IP_REQUESTS_LIMIT | 10 | Y | limit one IP can make event in period of time (Z)
SAMPLE_PERIOD | 5 (sec) | Z | period of time in seconds in which limits (Y) and (N) cannot be reached
IP_EMAILS_LIMIT | 2 | N | emails limit used to cause IP ban

##

### To improve

* Only data not older than 5 seconds ago in table ***inputs*** are usable, it may be useful removing older ones
* How can we handle ***DDoS Attack***?
* IP validation
* Is it worth running `EventHandler.new(params).save` if address is already banned?
* Below warnings seems to me sinatra issues `https://github.com/sinatra/sinatra/issues/1590`
```
Rails backports are deprecated.
/Users/robertz/.rbenv/versions/2.7.1/lib/ruby/gems/2.7.0/gems/sinatra-contrib-2.0.8.1/lib/sinatra/respond_with.rb:226: warning: Using the last argument as keyword parameters is deprecated; maybe ** should be added to the call
/Users/robertz/.rbenv/versions/2.7.1/lib/ruby/gems/2.7.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1622: warning: The called method `compile!' is defined here
```
