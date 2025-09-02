import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/prestation.dart';
import '../../services/prestation_service.dart';

class AddEditPrestationScreen extends StatefulWidget {
  final Prestation? prestation;
  const AddEditPrestationScreen({super.key, this.prestation});

  @override
  _AddEditPrestationScreenState createState() => _AddEditPrestationScreenState();
}

class _AddEditPrestationScreenState extends State<AddEditPrestationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _hospitalController;
  late TextEditingController _referenceController;
  bool _isLoading = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    final p = widget.prestation;
    _titleController = TextEditingController(text: p?.title ?? '');
    _hospitalController = TextEditingController(text: p?.hospital ?? '');
    _referenceController = TextEditingController(text: p?.reference ?? '');
    _status = p?.status ?? 'En cours';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _hospitalController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _savePrestation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final service = Provider.of<PrestationService>(context, listen: false);
      final prestation = Prestation(
        id: widget.prestation?.id ?? '',
        title: _titleController.text.trim(),
        hospital: _hospitalController.text.trim(),
        reference: _referenceController.text.trim(),
        status: _status!,
        date: widget.prestation?.date ?? DateTime.now(),
        isActive: _status != 'Cloturé',
      );

      if (widget.prestation != null) {
        await service.updatePrestation(prestation);
      } else {
        await service.addPrestation(prestation);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.prestation != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier' : 'Nouvelle prestation'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _confirmDelete,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Titre',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.medical_services),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _hospitalController,
                      decoration: const InputDecoration(
                        labelText: 'Établissement',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.local_hospital),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _referenceController,
                      decoration: const InputDecoration(
                        labelText: 'Référence',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.receipt_long),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Statut',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                      items: ['En cours', 'Cloturé', 'En attente']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _status = value),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _savePrestation,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Enregistrer'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Supprimer cette prestation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await Provider.of<PrestationService>(
          context,
          listen: false,
        ).deletePrestation(widget.prestation!.id);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
