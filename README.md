# Credential stuffing detection microservice

## API

1. `PUT /detect`

  ```
  {
    result: false
  }
  ```


## Setup

Use `.env.example` to set environmental variables:
```
RACK_ENV=[development,staging,production]
```

Start service locally:
```
bundle exec rackup -p 3000
```

## Before commit
Set up overcommit to make sure your code is clean :) :

```
gem install overcommit
bundle install --gemfile=.overgems.rb
overcommit --install
```
Then you can commit your changes! And don't forget to run specs before:

```
bundle exec rspec
```
