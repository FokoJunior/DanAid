import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/prestation.dart';
import '../../services/prestation_service.dart';
import '../prestation/add_edit_prestation_screen.dart';

class PrestationDetailScreen extends StatelessWidget {
  final String prestationId;

  const PrestationDetailScreen({super.key, required this.prestationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
          ),
        ],
      ),
      body: FutureBuilder<Prestation?>(
        future: Provider.of<PrestationService>(context, listen: false)
            .getPrestation(prestationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Erreur de chargement'));
          }

          final prestation = snapshot.data!;
          return _buildPrestationDetails(context, prestation);
        },
      ),
    );
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    final service = Provider.of<PrestationService>(context, listen: false);
    final prestation = await service.getPrestation(prestationId);
    if (prestation != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEditPrestationScreen(prestation: prestation),
        ),
      );
    }
  }

  Widget _buildPrestationDetails(BuildContext context, Prestation prestation) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.medical_services,
                    label: 'Titre',
                    value: prestation.title,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    icon: Icons.local_hospital,
                    label: 'Établissement',
                    value: prestation.hospital,
                  ),
                  if (prestation.reference?.isNotEmpty ?? false) ...[
                    const Divider(),
                    _buildDetailRow(
                      icon: Icons.receipt_long,
                      label: 'Référence',
                      value: prestation.reference!,
                    ),
                  ],
                  const Divider(),
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    label: 'Date',
                    value: dateFormat.format(prestation.date ?? DateTime.now()),
                  ),
                  const Divider(),
                  _buildStatusRow(prestation.status),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String status) {
    Color statusColor = Colors.blue;
    if (status == 'Cloturé') statusColor = Colors.grey;
    if (status == 'En attente') statusColor = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
