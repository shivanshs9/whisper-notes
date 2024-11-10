import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';
import { join } from "node:path";
import 'dotenv/config';

import { DB, InitializeDb } from './db';
import { Note } from './entity/note';

const PROTO_FILE = 'notes.proto';

const packageDefinition = protoLoader.loadSync(PROTO_FILE, {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
  includeDirs: [process.env.PROTO_PATH!!, join(__dirname, 'generated')]
});
const protoDescriptor = grpc.loadPackageDefinition(packageDefinition) as any;
const noteService = protoDescriptor.notes.NoteService;

const notes: { [key: string]: any } = {};

// RPC Method to create a new note
const createNote = (
  call: grpc.ServerUnaryCall<any, any>,
  callback: grpc.sendUnaryData<any>
) => {
  console.log('create a new note...')
  const { audio, transcription } = call.request;

  if (!audio || !transcription) {
    callback(null, {
      status: 'failure',
      errorMessage: 'Audio and transcription are required fields.',
    });
    return;
  }

  // I will not save audio, because too much work for an interview :/
  const newNote = DB.getRepository(Note).create({
    transcription: transcription,
  })

  callback(null, {
    status: 'success',
    errorMessage: '',
    note: newNote,
  });
};

// RPC Method to list all notes
const listNotes = (
  call: grpc.ServerUnaryCall<any, any>,
  callback: grpc.sendUnaryData<any>
) => {
  DB.getRepository(Note).find().then((allNotes) =>
    callback(null, { notes: allNotes })
  )
};

function startServer() {
  const server = new grpc.Server();

  InitializeDb()

  server.addService(noteService.service, {
    CreateNote: createNote,
    ListNotes: listNotes,
  });

  const port = '8080';
  server.bindAsync(`0.0.0.0:${port}`, grpc.ServerCredentials.createInsecure(), (err, bindPort) => {
    if (err) {
      console.error(`Error binding server: ${err.message}`);
      return;
    }
    console.log(`Server running at http://0.0.0.0:${port}`);
  });
}

startServer();
