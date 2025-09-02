import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../models/prestation.dart';

class PrestationService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _prestationsCollection => 
      _firestore.collection('prestations');

  // Get all prestations for the current user
  Stream<List<Prestation>> getPrestations() {
    if (userId == null) return const Stream.empty();
    
    return _prestationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Prestation.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Get a single prestation by ID
  Future<Prestation?> getPrestation(String id) async {
    try {
      final doc = await _prestationsCollection.doc(id).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          return Prestation.fromMap(data as Map<String, dynamic>, doc.id);
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Add a new prestation
  Future<void> addPrestation(Prestation prestation) async {
    try {
      await _prestationsCollection.add(prestation.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing prestation
  Future<void> updatePrestation(Prestation prestation) async {
    try {
      await _prestationsCollection
          .doc(prestation.id)
          .update(prestation.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Delete a prestation
  Future<void> deletePrestation(String id) async {
    if (userId == null) throw Exception('User not authenticated');
    await _deletePrestationImages(id);
    await _prestationsCollection.doc(id).delete();
  }

  // Upload image to storage
  Future<String> uploadImage(File file, String prestationId) async {
    if (userId == null) throw Exception('User not authenticated');
    
    final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
    final ref = _storage.ref('prestations/$prestationId/$fileName');
    
    try {
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Delete all images for a prestation
  Future<void> _deletePrestationImages(String prestationId) async {
    try {
      final ref = _storage.ref('prestations/$prestationId');
      final list = await ref.listAll();
      await Future.wait(list.items.map((item) => item.delete()));
    } catch (e) {
      debugPrint('Error deleting images: $e');
    }
  }
}