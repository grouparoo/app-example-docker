FROM node:16

WORKDIR /grouparoo

ENV NODE_ENV='production'
ENV PORT=3000
ENV WEB_URL=http://localhost:$PORT
ENV WEB_SERVER=true
ENV SERVER_TOKEN="default-server-token"
ENV WORKERS=1
ENV REDIS_URL="redis://localhost:6379/0"
ENV DATABASE_URL="postgresql://localhost:5432/grouparoo_development"

COPY . .
RUN npm install
RUN npm prune

WORKDIR /grouparoo/node_modules/@grouparoo/core
CMD ["./bin/start"]

EXPOSE $PORT/tcp
