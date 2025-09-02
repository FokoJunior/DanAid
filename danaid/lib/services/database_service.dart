import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/prestation.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference prestationCollection =
      FirebaseFirestore.instance.collection('prestations');

  Future<DocumentReference> addPrestation(Prestation prestation) async {
    // Include the current user's ID when adding a new prestation
    final data = prestation.toMap()..['userId'] = uid;
    return await prestationCollection.add(data);
  }

  Future<void> updatePrestation(String id, Prestation prestation) async {
    return await prestationCollection.doc(id).update(prestation.toMap());
  }

  Future<void> deletePrestation(String id) async {
    return await prestationCollection.doc(id).delete();
  }

  Stream<List<Prestation>> get prestations {
    return prestationCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Prestation.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<Prestation> getPrestation(String id) async {
    var doc = await prestationCollection.doc(id).get();
    return Prestation.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}