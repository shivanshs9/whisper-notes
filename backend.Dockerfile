FROM node:23-alpine AS build

WORKDIR /build
COPY backend .
COPY protos ./protos

RUN yarn --frozen-lockfile

RUN yarn proto-loader-gen-types \
    --grpcLib=@grpc/grpc-js \
    --outDir=./src/generated/ \
    ./protos/*.proto

RUN yarn build

FROM node:23-alpine AS app

RUN apk add --no-cache tini

WORKDIR /app
COPY --from=build /build/node_modules ./node_modules
COPY --from=build /build/dist ./dist
COPY --from=build /build/protos ./protos

ENV PROTO_PATH="/app/protos"
EXPOSE 8080

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "node", "dist/server.js" ]
