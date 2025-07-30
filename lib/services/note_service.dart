import 'package:cloud_firestore/cloud_firestore.dart';

class NoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Upload Note with Google Drive Link
  Future<void> uploadNote(String title, String pdfUrl, String teacherId) async {
    await _db.collection("notes").add({
      "title": title,
      "pdfUrl": pdfUrl,  // Store Google Drive link
      "teacherId": teacherId,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // Fetch Notes
  Stream<QuerySnapshot> getNotes() {
    return _db.collection("notes").orderBy("timestamp", descending: true).snapshots();
  }

  // Delete Note
  Future<void> deleteNote(String noteId) async {
    await _db.collection("notes").doc(noteId).delete();
  }
}
