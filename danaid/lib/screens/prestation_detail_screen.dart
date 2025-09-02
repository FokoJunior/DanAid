import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/prestation.dart';
import '../services/database_service.dart';
import 'add_edit_prestation_screen.dart';

class PrestationDetailScreen extends StatelessWidget {
  final Prestation prestation;

  const PrestationDetailScreen({required this.prestation});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final databaseService = DatabaseService(uid: user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la prestation'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditPrestationScreen(
                    prestation: prestation,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Confirmer la suppression'),
                  content: Text('Êtes-vous sûr de vouloir supprimer cette prestation?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await databaseService.deletePrestation(prestation.id);
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prestation.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              prestation.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            _buildDetailRow('Établissement', prestation.establishment),
            _buildDetailRow('Couverture', prestation.coverage),
            _buildDetailRow('Statut', prestation.status),
            _buildDetailRow('Contact', prestation.contact),
            _buildDetailRow('Code d\'accès', prestation.accessCode),
            _buildDetailRow('Coût', '${prestation.cost} FCFA'),
            _buildDetailRow('Raison', prestation.reason),
            _buildDetailRow('Taux', '${prestation.rate}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}