FROM heroku/cedar:14

RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev python ttf-mscorefonts-installer

RUN useradd -d /app -m app
USER app
WORKDIR /app

ENV HOME /app
ENV NODE_ENGINE 0.12.3
ENV PORT 3000

RUN mkdir -p /app/heroku/node
RUN mkdir -p /app/src
#RUN curl -s https://iojs.org/dist/v2.0.2/iojs-v2.0.2-linux-x64.tar.xz | tar --strip-components=1 -xz -C /app/heroku/node
RUN curl -s https://s3pository.heroku.com/node/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C /app/heroku/node
ENV PATH /app/heroku/node/bin:$PATH

WORKDIR /app/src
RUN git clone git://github.com/ariya/phantomjs.git
WORKDIR /app/src/phantomjs
RUN git checkout 2.0
RUN ./build.sh --confirm
WORKDIR /app
ENV PATH /app/src/phantomjs/bin:$PATH

RUN mkdir -p /app/.profile.d
RUN echo "export PATH=\"/app/src/phantomjs/bin:/app/heroku/node/bin:/app/bin:/app/src/node_modules/.bin:\$PATH\"" > /app/.profile.d/nodejs.sh
RUN echo "cd /app/src" >> /app/.profile.d/nodejs.sh
WORKDIR /app/src

RUN touch /app/log
RUN ln -sf /dev/stdout /app/log

EXPOSE 3000

ONBUILD COPY . /app/src
ONBUILD RUN npm install