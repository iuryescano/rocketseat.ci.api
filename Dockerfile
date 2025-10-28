FROM node:18 AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
COPY . .

RUN yarn install --frozen-lockfile
RUN yarn build
RUN yarn install --production --frozen-lockfile

FROM node:18-alpine3.19

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["yarn", "start:prod"]

