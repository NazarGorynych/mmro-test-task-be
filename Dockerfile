# Dockerfile.rails
FROM ruby:3.2.2 AS rails-toolbox

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install --deployment
COPY . /app
ENV RAILS_ENV="production"
ENV DEVICE_SECRET_KEY="6c2730038920e81eca39d73d3fa2b39b63a20452d415720c304867685342cea3383fa8c71e89e28da232ffed16bb06d0a573425f2c39e09c6daf388067bd312a"

EXPOSE 3000
CMD ["./bin/rails", "server"]
