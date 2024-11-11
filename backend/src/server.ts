import * as grpc from "@grpc/grpc-js";
import * as protoLoader from "@grpc/proto-loader";
import { join } from "node:path";
import "dotenv/config";

import { DB, InitializeDb } from "./db";
import { Note as DBNote } from "./entity/note";
import type { ProtoGrpcType } from "./generated/notes";
import type { NoteServiceHandlers } from "./generated/notes/NoteService";
import type { CreateNoteRequest } from "./generated/notes/CreateNoteRequest";
import type { CreateNoteResponse } from "./generated/notes/CreateNoteResponse";
import { Status } from "@grpc/grpc-js/build/src/constants";

const PROTO_FILE = "notes.proto";

const packageDefinition = protoLoader.loadSync(PROTO_FILE, {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
  includeDirs: [process.env.PROTO_PATH!!, join(__dirname, "generated")],
});
const proto = grpc.loadPackageDefinition(
  packageDefinition
) as unknown as ProtoGrpcType;

const NoteService: NoteServiceHandlers = {
  // RPC Method to create a new note
  CreateNote: (
    call: grpc.ServerUnaryCall<CreateNoteRequest, CreateNoteResponse>,
    callback: grpc.sendUnaryData<CreateNoteResponse>
  ) => {
    console.log("create a new note...");
    const { audio, transcription } = call.request;
    console.log(call.getPeer())

    if (!transcription) {
      callback(null, {
        status: "failure",
        errorMessage: "Transcription is a required field.",
      });
      return;
    }

    // I will not save audio, because too much work for an interview :/
    DB.getRepository(DBNote).save({
      transcription: transcription
    }).then((newNote) => {
      callback(null, {
        status: "success",
        errorMessage: "",
        note: {
          transcription: newNote.transcription,
          id: "" + newNote.id
        },
      });
    }).catch((err) => {
      callback({
        code: Status.INTERNAL,
        details: err
      })
    }) 
  },
  // RPC Method to list all notes
  ListNotes: (
    call: grpc.ServerUnaryCall<any, any>,
    callback: grpc.sendUnaryData<any>
  ) => {
    console.log("fetching all notes...");
    DB.getRepository(DBNote)
      .find()
      .then((allNotes) => callback(null, { notes: allNotes }));
  },
};
function startServer() {
  const server = new grpc.Server();

  InitializeDb();

  server.addService(proto.notes.NoteService.service, NoteService);

  const port = "8080";
  server.bindAsync(
    `0.0.0.0:${port}`,
    grpc.ServerCredentials.createInsecure(),
    (err, bindPort) => {
      if (err) {
        console.error(`Error binding server: ${err.message}`);
        return;
      }
      console.log(`Server running at http://0.0.0.0:${port}`);
    }
  );
}

startServer();
