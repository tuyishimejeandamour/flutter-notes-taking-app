import 'package:equatable/equatable.dart';
import '../models/note.dart';

enum NotesStatus { initial, loading, success, failure }

class NotesState extends Equatable {
  final NotesStatus status;
  final List<Note> notes;
  final String? errorMessage;

  const NotesState._({
    this.status = NotesStatus.initial,
    this.notes = const <Note>[],
    this.errorMessage,
  });

  const NotesState.initial() : this._();

  const NotesState.loading() : this._(status: NotesStatus.loading);

  const NotesState.success(List<Note> notes)
      : this._(status: NotesStatus.success, notes: notes);

  const NotesState.failure(String message)
      : this._(status: NotesStatus.failure, errorMessage: message);

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? notes,
    String? errorMessage,
  }) {
    return NotesState._(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notes, errorMessage];
}
