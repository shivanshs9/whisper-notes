## Backend API to store Notes

### Features

- Typescript with gRPC support!
- Requires Envoy proxy with Grpc Web plugin, for communication with frontend.
- Uses Postgres Driver (in case DB's creds env are not provided, uses Sqlite3) to persistently store the notes.

### Env Vars

Refer to [k8s manifests](../iac/services/backend/deployment.yaml) for list of envs.
For local run, it also requires `PROTO_PATH` env (check [.env](.env) file for sample) which is a path (relative/absolute) to [protos](../protos/) folder.

### How to run?

1. Make sure to first generate the protoc files for backend code (one time activity):

```bash
bash ../proto-gen.sh
```

2. Build and run the code (hot-reload not supported):

```bash
yarn build
node dist/server.js
```

### API Contract

Refer to [NoteService](../protos/notes.proto) for API contract.
