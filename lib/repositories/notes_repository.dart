import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NotesRepository {
  final FirebaseFirestore _firestore;

  NotesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get notes collection for a specific user
  CollectionReference _getUserNotesCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('notes');
  }

  // Fetch all notes for a user
  Future<List<Note>> fetchNotes(String userId) async {
    try {
      final QuerySnapshot snapshot = await _getUserNotesCollection(userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Note.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  // Add a new note
  Future<Note> addNote(String userId, String text) async {
    try {
      final now = DateTime.now();
      final noteData = {
        'text': text,
        'userId': userId,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };

      final DocumentReference docRef = await _getUserNotesCollection(userId).add(noteData);
      
      return Note(
        id: docRef.id,
        text: text,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  // Update a note
  Future<Note> updateNote(String userId, String noteId, String text) async {
    try {
      final now = DateTime.now();
      await _getUserNotesCollection(userId).doc(noteId).update({
        'text': text,
        'updatedAt': Timestamp.fromDate(now),
      });

      // Fetch the updated note
      final DocumentSnapshot doc = await _getUserNotesCollection(userId).doc(noteId).get();
      return Note.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String userId, String noteId) async {
    try {
      await _getUserNotesCollection(userId).doc(noteId).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  // Stream of notes for real-time updates
  Stream<List<Note>> notesStream(String userId) {
    return _getUserNotesCollection(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}
