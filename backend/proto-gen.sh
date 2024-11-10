#!/bin/bash

yarn proto-loader-gen-types --grpcLib=@grpc/grpc-js --outDir=src/generated/ protos/*.proto
# yarn grpc_tools_node_protoc \
#   --ts_out=src/generated \
#   --js_out=import_style=commonjs,binary:src/generated \
#   --grpc_out=grpc_js:src/generated \
#   --proto_path=. note.proto