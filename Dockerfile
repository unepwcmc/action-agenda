# FROM ruby:2.6.3-alpine
# RUN apk add  --no-cache --repository https://github.com/Starefossen/docker-ruby-node/blob/master/2-6/alpine/ \
#   npm \
#   yarn \
#   && rm -rf /var/cache/apk/*

# WORKDIR /app
# COPY . /app/

# ENV BUNDLE_PATH /gems
# RUN gem install bundler
# RUN bundle install
# RUN yarn install

# ENTRYPOINT ["bin/rails"]
# CMD ["server", "-b", "0.0.0.0"]
# EXPOSE 3000
FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client
# Define versions
ENV NVM_VERSION=0.25.4
ENV NODE_VERSION=12.18.3
ARG BUNDLER_VERSION=2.3.18
ENV BUNDLER_VERSION=${BUNDLER_VERSION}
# Install nvm with node and npm
ENV NVM_DIR=/root/.nvm
RUN mkdir -p $NVM_DIR
RUN /bin/bash -l -c "curl -L https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash  && source $NVM_DIR/nvm.sh"
RUN /bin/bash -l -c "source $NVM_DIR/nvm.sh \
                    && nvm install $NODE_VERSION \
                    && nvm alias default $NODE_VERSION \
                    && nvm use default \
                    && npm install -g yarn && npm g puppeteer"
# Export NODE_PATH
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
# Update PATH to make node/npm accessible
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH