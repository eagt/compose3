# syntax=docker/dockerfile:1
FROM ruby:3.0.1


# Install node 14-LTS and yarn. LTS stands for (Long-Term Support) 
# and it means it will be supported and maintained by the Node. js project for an extended period of time.
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g yarn@1

RUN apt-get update -qq && apt-get install -y postgresql-client

WORKDIR /compose3
COPY Gemfile /compose3/Gemfile
COPY Gemfile.lock /compose3/Gemfile.lock
RUN bundle install
COPY . /compose3

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
