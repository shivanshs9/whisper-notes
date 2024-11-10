// Original file: protos/notes.proto

import type * as grpc from '@grpc/grpc-js'
import type { MethodDefinition } from '@grpc/proto-loader'
import type { CreateNoteRequest as _notes_CreateNoteRequest, CreateNoteRequest__Output as _notes_CreateNoteRequest__Output } from '../notes/CreateNoteRequest';
import type { CreateNoteResponse as _notes_CreateNoteResponse, CreateNoteResponse__Output as _notes_CreateNoteResponse__Output } from '../notes/CreateNoteResponse';
import type { ListNotesRequest as _notes_ListNotesRequest, ListNotesRequest__Output as _notes_ListNotesRequest__Output } from '../notes/ListNotesRequest';
import type { ListNotesResponse as _notes_ListNotesResponse, ListNotesResponse__Output as _notes_ListNotesResponse__Output } from '../notes/ListNotesResponse';

export interface NoteServiceClient extends grpc.Client {
  CreateNote(argument: _notes_CreateNoteRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_notes_CreateNoteResponse__Output>): grpc.ClientUnaryCall;
  CreateNote(argument: _notes_CreateNoteRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_notes_CreateNoteResponse__Output>): grpc.ClientUnaryCall;
  CreateNote(argument: _notes_CreateNoteRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_notes_CreateNoteResponse__Output>): grpc.ClientUnaryCall;
  CreateNote(argument: _notes_CreateNoteRequest, callback: grpc.requestCallback<_notes_CreateNoteResponse__Output>): grpc.ClientUnaryCall;
  createNote(argument: _notes_CreateNoteRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_notes_CreateNoteResponse__Output>): grpc.ClientUnaryCall;
  createNote(argument: _notes_CreateNoteRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_notes_CreateNoteResponse__Output>): grpc.ClientUnaryCall;
  createNote(argument: _notes_CreateNoteRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_notes_CreateNoteResponse__Output>): grpc.ClientUnaryCall;
  createNote(argument: _notes_CreateNoteRequest, callback: grpc.requestCallback<_notes_CreateNoteResponse__Output>): grpc.ClientUnaryCall;
  
  ListNotes(argument: _notes_ListNotesRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_notes_ListNotesResponse__Output>): grpc.ClientUnaryCall;
  ListNotes(argument: _notes_ListNotesRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_notes_ListNotesResponse__Output>): grpc.ClientUnaryCall;
  ListNotes(argument: _notes_ListNotesRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_notes_ListNotesResponse__Output>): grpc.ClientUnaryCall;
  ListNotes(argument: _notes_ListNotesRequest, callback: grpc.requestCallback<_notes_ListNotesResponse__Output>): grpc.ClientUnaryCall;
  listNotes(argument: _notes_ListNotesRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_notes_ListNotesResponse__Output>): grpc.ClientUnaryCall;
  listNotes(argument: _notes_ListNotesRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_notes_ListNotesResponse__Output>): grpc.ClientUnaryCall;
  listNotes(argument: _notes_ListNotesRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_notes_ListNotesResponse__Output>): grpc.ClientUnaryCall;
  listNotes(argument: _notes_ListNotesRequest, callback: grpc.requestCallback<_notes_ListNotesResponse__Output>): grpc.ClientUnaryCall;
  
}

export interface NoteServiceHandlers extends grpc.UntypedServiceImplementation {
  CreateNote: grpc.handleUnaryCall<_notes_CreateNoteRequest__Output, _notes_CreateNoteResponse>;
  
  ListNotes: grpc.handleUnaryCall<_notes_ListNotesRequest__Output, _notes_ListNotesResponse>;
  
}

export interface NoteServiceDefinition extends grpc.ServiceDefinition {
  CreateNote: MethodDefinition<_notes_CreateNoteRequest, _notes_CreateNoteResponse, _notes_CreateNoteRequest__Output, _notes_CreateNoteResponse__Output>
  ListNotes: MethodDefinition<_notes_ListNotesRequest, _notes_ListNotesResponse, _notes_ListNotesRequest__Output, _notes_ListNotesResponse__Output>
}
