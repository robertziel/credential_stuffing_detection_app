# Credential stuffing detection microservice

## API

`PUT /detect`

  Parameters:
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
export RACK_ENV=[development,staging,production]
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
`ab -n 5000 -c 100 -u benchmark_data.json http://localhost:8080/detect`
(If above command does not work you can install it on mac using brew `brew install homebrew/apache/ab`)


Commit | Requests [#/sec] (mean) | Description
--- | --- | ---
79409b51d41376fa3a6d8321ea7976a21d88ab4c | 192.66 | Save input to database only
