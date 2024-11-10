import type * as grpc from '@grpc/grpc-js';
import type { MessageTypeDefinition } from '@grpc/proto-loader';

import type { NoteServiceClient as _notes_NoteServiceClient, NoteServiceDefinition as _notes_NoteServiceDefinition } from './notes/NoteService';

type SubtypeConstructor<Constructor extends new (...args: any) => any, Subtype> = {
  new(...args: ConstructorParameters<Constructor>): Subtype;
};

export interface ProtoGrpcType {
  notes: {
    CreateNoteRequest: MessageTypeDefinition
    CreateNoteResponse: MessageTypeDefinition
    ListNotesRequest: MessageTypeDefinition
    ListNotesResponse: MessageTypeDefinition
    Note: MessageTypeDefinition
    NoteService: SubtypeConstructor<typeof grpc.Client, _notes_NoteServiceClient> & { service: _notes_NoteServiceDefinition }
  }
}

