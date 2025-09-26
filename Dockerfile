FROM --platform=linux/amd64 ruby:2.6.3

RUN set -eux; \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until; \
    sed -i 's|deb.debian.org/debian|archive.debian.org/debian|g' /etc/apt/sources.list; \
    sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list; \
    apt-get update -qq; \
    apt-get install -y build-essential libpq-dev postgresql-client; \
    rm -rf /var/lib/apt/lists/*

# Define versions
ENV NVM_VERSION=0.25.4
ENV NODE_VERSION=14.18.1
ENV BUNDLER_VERSION=2.3.5

# Install nvm with node and npm
ENV NVM_DIR=/root/.nvm
RUN mkdir -p $NVM_DIR
RUN /bin/bash -l -c "curl -L https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash  && source $NVM_DIR/nvm.sh"
RUN /bin/bash -l -c "source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g yarn"

# Export NODE_PATH
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
# Update PATH to make node/npm accessible
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN gem install bundler -v ${BUNDLER_VERSION} --no-document

WORKDIR /action-agenda

# COPY Gemfile /action-agenda/Gemfile
# COPY Gemfile.lock /action-agenda/Gemfile.lock
# RUN bundle _${BUNDLER_VERSION}_ install -j 4

# COPY package*.json yarn.lock ./
# RUN yarn install

# ADD . /action-agenda

EXPOSE 3000
CMD ["tail", "-f", "/dev/null"]
