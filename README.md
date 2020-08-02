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
    "detected_attack": false
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
Set up database (run always after migration file added):
```bash
docker-compose run web rake db:create db:migrate
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


Try | Requests [#/sec] (mean) | Puma | Description
--- | --- | --- | ---
1 | 176.73 | Not set | Save Input to database only
2 | 452.74 | Concurrency: 4 | Save Input to database, detect attack
3 | 231.78 | Concurrency: 4 | Redesigned database

## Constants

Following constants can be set by adding them to `.env` or `.env.docker`

Env name | Default value | | Description
--- | --- | --- | ---
IP_BAN_TIME | 30 (sec) | X | how long an IP is banned in seconds
IP_LIMIT | 10 | Y | limit one IP can make event in period of time (Z)
SAMPLE_PERIOD | 5 (sec) | Z | period of time in seconds in which limits (Y) and (N) cannot be reached
IP_EMAILS_LIMIT | 2 | N | emails limit used to cause IP ban

### To improve

* Only data not older than 5 seconds ago in table ***inputs*** are usable, it may be useful removing older ones
* How can we handle ***DDoS Attack***?
* IP validation
* Is it worth running `EventHandler.new(params).save` if address is already banned?
