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


## Setup

Make sure your console uses right environment as default

```bash
export RACK_ENV=[development,staging,production]
```

Use `.env.example` to set environmental variables:
```bash
DATABASE_NAME
DATABASE_PASSWORD # in production only
DATABASE_USERNAME
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
