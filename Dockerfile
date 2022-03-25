# original author https://github.com/alekzonder/docker-puppeteer
FROM node:14-slim
RUN apt-get update && \
apt-get install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget && \
wget https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb && \
dpkg -i dumb-init_*.deb && rm -f dumb-init_*.deb && \
apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN yarn global add puppeteer@1.20.0 && yarn cache clean

ENV NODE_PATH="/usr/local/share/.config/yarn/global/node_modules:${NODE_PATH}"

RUN groupadd -r puppeteer && useradd -r -g puppeteer -G audio,video puppeteer

ENV LANG="C.UTF-8"

WORKDIR /app

RUN mkdir -p /home/pptruser
RUN chown -R puppeteer:puppeteer /home/pptruser
RUN chown -R puppeteer:puppeteer /app

USER puppeteer

ENTRYPOINT ["dumb-init", "--"]

COPY package.json /app
COPY server.js /app
RUN npm install
EXPOSE 4000
CMD [ "node", "server.js" ]
