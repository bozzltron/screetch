FROM heroku/cedar:14

RUN useradd -d /app -m app
USER app
WORKDIR /app

ENV HOME /app
ENV NODE_ENGINE 0.11.x 
ENV PORT 3000

RUN mkdir -p /app/heroku/node
RUN mkdir -p /app/src
RUN curl -s https://iojs.org/dist/v2.0.2/iojs-v2.0.2-linux-x64.tar.xz | tar --strip-components=1 -xz -C /app/heroku/node
#RUN curl -s https://s3pository.heroku.com/node/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C /app/heroku/node
ENV PATH /app/heroku/node/bin:$PATH

RUN curl -s https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.0.0-source.zip | tar --strip-components=1 -xz -C /app/heroku/phantomjs
ENV PATH /app/heroku/phantomjs/bin:$PATH

RUN mkdir -p /app/.profile.d
RUN echo "export PATH=\"/app/heroku/node/bin:/app/bin:/app/src/node_modules/.bin:\$PATH\"" > /app/.profile.d/nodejs.sh
RUN echo "cd /app/src" >> /app/.profile.d/nodejs.sh
WORKDIR /app/src

EXPOSE 3000

ONBUILD COPY . /app/src
ONBUILD RUN npm install
