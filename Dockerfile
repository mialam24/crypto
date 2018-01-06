FROM ruby:alpine

ADD Gemfile Gemfile.lock /
RUN bundle install

WORKDIR /src

COPY src .

ENTRYPOINT ["/bin/sh"]
