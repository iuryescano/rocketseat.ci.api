FROM node:24-alpine AS build

WORKDIR /usr/src/app

# Copiar apenas package.json e yarn.lock primeiro para cache
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production=false

# Copiar código fonte
COPY . .
RUN yarn build

# Stage de produção
FROM node:24-alpine

WORKDIR /usr/src/app

# Instalar apenas dependências de produção
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production=true && yarn cache clean

# Copiar arquivos built
COPY --from=build /usr/src/app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main.js"]

