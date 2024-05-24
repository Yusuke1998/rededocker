FROM node:16.20.0

WORKDIR /usr/src/app

COPY ./package.json .
RUN yarn install
COPY . .

EXPOSE 3000

ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000
ENV APP_URL=0.0.0.0
ENV APP_PORT=3000

CMD [ "yarn", "dev" ]