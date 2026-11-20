import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutProgress {
  const WorkoutProgress({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.completedAt,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final DateTime completedAt;

  factory WorkoutProgress.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return WorkoutProgress(
      id: snapshot.id,
      title: data['title'] as String? ?? 'Workout',
      durationMinutes: data['durationMinutes'] as int? ?? 0,
      completedAt:
          (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class ProgressService {
  ProgressService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('A signed-in user is required.');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _records {
    return _firestore.collection('users').doc(_uid).collection('progress');
  }

  Stream<List<WorkoutProgress>> watchRecords() {
    return _records
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(WorkoutProgress.fromSnapshot).toList(),
        );
  }

  Future<void> createRecord({
    required String title,
    required int durationMinutes,
  }) {
    return _records.add({
      'title': title,
      'durationMinutes': durationMinutes,
      'completedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateRecord(String id, {required int durationMinutes}) {
    return _records.doc(id).update({
      'durationMinutes': durationMinutes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteRecord(String id) {
    return _records.doc(id).delete();
  }
}
