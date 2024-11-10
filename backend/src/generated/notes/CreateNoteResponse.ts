// Original file: protos/notes.proto

import type { Note as _notes_Note, Note__Output as _notes_Note__Output } from '../notes/Note';

export interface CreateNoteResponse {
  'status'?: (string);
  'errorMessage'?: (string);
  'note'?: (_notes_Note | null);
}

export interface CreateNoteResponse__Output {
  'status'?: (string);
  'errorMessage'?: (string);
  'note'?: (_notes_Note__Output);
}
