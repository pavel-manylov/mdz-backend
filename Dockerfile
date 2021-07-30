FROM ruby:3.0.2

RUN gem install rspec -v 3.10.0 && \
    gem install debase -v 0.2.4.1 &&  \
    gem install ruby-debug-ide -v 0.7.2 && \
    gem install rails -v 6.1.4

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./