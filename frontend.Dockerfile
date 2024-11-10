FROM node:23-alpine AS build

WORKDIR /build
COPY frontend .
COPY protos ./protos

RUN yarn --frozen-lockfile

RUN yarn protoc \
    --ts_out src/generated/ \
    --ts_opt long_type_string \
    --proto_path ./protos \
    --ts_opt ts_nocheck \
    ./protos/*.proto

RUN yarn build

FROM flashspys/nginx-static:latest AS app

COPY --from=build /build/dist /static
EXPOSE 80
