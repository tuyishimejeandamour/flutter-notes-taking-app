import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/notes_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _notesRepository;

  NotesBloc({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(const NotesState.initial()) {
    on<NotesFetched>(_onNotesFetched);
    on<NoteAdded>(_onNoteAdded);
    on<NoteUpdated>(_onNoteUpdated);
    on<NoteDeleted>(_onNoteDeleted);
  }

  Future<void> _onNotesFetched(
    NotesFetched event,
    Emitter<NotesState> emit,
  ) async {
    emit(const NotesState.loading());
    try {
      final notes = await _notesRepository.fetchNotes(event.userId);
      emit(NotesState.success(notes));
    } catch (e) {
      emit(NotesState.failure(e.toString()));
    }
  }

  Future<void> _onNoteAdded(
    NoteAdded event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.addNote(event.userId, event.text);
      // Refresh the notes list
      add(NotesFetched(event.userId));
    } catch (e) {
      emit(NotesState.failure(e.toString()));
    }
  }

  Future<void> _onNoteUpdated(
    NoteUpdated event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.updateNote(
        event.userId,
        event.noteId,
        event.text,
      );
      // Refresh the notes list
      add(NotesFetched(event.userId));
    } catch (e) {
      emit(NotesState.failure(e.toString()));
    }
  }

  Future<void> _onNoteDeleted(
    NoteDeleted event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.deleteNote(event.userId, event.noteId);
      // Refresh the notes list
      add(NotesFetched(event.userId));
    } catch (e) {
      emit(NotesState.failure(e.toString()));
    }
  }
}
