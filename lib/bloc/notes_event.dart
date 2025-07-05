import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class NotesFetched extends NotesEvent {
  final String userId;

  const NotesFetched(this.userId);

  @override
  List<Object> get props => [userId];
}

class NoteAdded extends NotesEvent {
  final String userId;
  final String text;

  const NoteAdded({
    required this.userId,
    required this.text,
  });

  @override
  List<Object> get props => [userId, text];
}

class NoteUpdated extends NotesEvent {
  final String userId;
  final String noteId;
  final String text;

  const NoteUpdated({
    required this.userId,
    required this.noteId,
    required this.text,
  });

  @override
  List<Object> get props => [userId, noteId, text];
}

class NoteDeleted extends NotesEvent {
  final String userId;
  final String noteId;

  const NoteDeleted({
    required this.userId,
    required this.noteId,
  });

  @override
  List<Object> get props => [userId, noteId];
}
