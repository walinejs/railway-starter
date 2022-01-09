# https://github.com/nodejs/LTS
FROM node:lts AS build
WORKDIR /app
ENV NODE_ENV production
COPY package.json /app/package.json
RUN set -eux; \
	npm install --production

FROM node:lts-alpine
WORKDIR /app
ENV TZ Asia/Shanghai
ENV NODE_ENV production
RUN set -eux; \
	apk add --no-cache bash; \
	apk add --no-cache --virtual .build-deps alpine-conf; \
	setup-timezone -z ${TZ}; \
	apk del --no-network .build-deps
COPY --from=build /app .
COPY index.js /app/index.js
EXPOSE 3000
CMD ["node", "index.js"]