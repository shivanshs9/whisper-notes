#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Backend
# cd $SCRIPT_DIR/backend
# yarn proto-loader-gen-types \
#     --grpcLib=@grpc/grpc-js \
#     --outDir=./src/generated/ \
#     $SCRIPT_DIR/protos/*.proto
echo "Backend stubs generated..."

# Frontend
# npm install -g protoc-gen-grpc-web
# brew install protobuf protoc-gen-js
cd $SCRIPT_DIR/frontend
mkdir -p src/generated
# protoc -I=$SCRIPT_DIR/protos notes.proto \
#   --js_out=import_style=commonjs:./src/generated \
#   --grpc-web_out=import_style=typescript,mode=grpcwebtext:./src/generated
npx protoc \
  --ts_out src/generated/ \
  --ts_opt long_type_string \
  --proto_path $SCRIPT_DIR/protos \
  $SCRIPT_DIR/protos/*.proto
echo "Frontend Stubs generated..."
