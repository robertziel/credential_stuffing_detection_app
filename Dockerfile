FROM ruby:2.7.1

ENV LANG C.UTF-8
ENV RACK_ENV production

RUN gem install bundler

WORKDIR /tmp
ADD Gemfile* /tmp/
ADD Gemfile.lock* /tmp/
ADD .ruby-version* /tmp/
RUN bundle config --local without "development test"
RUN bundle install

ENV APP_HOME /docker
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME
