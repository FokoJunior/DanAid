import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../models/prestation.dart';
import '../services/database_service.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_app_bar.dart';

class AddEditPrestationScreen extends StatefulWidget {
  final Prestation? prestation;

  const AddEditPrestationScreen({this.prestation});

  @override
  _AddEditPrestationScreenState createState() => _AddEditPrestationScreenState();
}

class _AddEditPrestationScreenState extends State<AddEditPrestationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _establishmentController = TextEditingController();
  final _coverageController = TextEditingController();
  final _statusController = TextEditingController();
  final _contactController = TextEditingController();
  final _accessCodeController = TextEditingController();
  final _costController = TextEditingController();
  final _reasonController = TextEditingController();
  final _rateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.prestation != null) {
      _titleController.text = widget.prestation!.title;
      _descriptionController.text = widget.prestation!.description;
      _establishmentController.text = widget.prestation!.establishment;
      _coverageController.text = widget.prestation!.coverage;
      _statusController.text = widget.prestation!.status;
      _contactController.text = widget.prestation!.contact;
      _accessCodeController.text = widget.prestation!.accessCode;
      _costController.text = widget.prestation!.cost.toString();
      _reasonController.text = widget.prestation!.reason;
      _rateController.text = widget.prestation!.rate.toString();
    }
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label${isRequired ? ' *' : ''}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: validator ?? (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return 'Ce champ est requis';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final databaseService = DatabaseService(uid: user!.uid);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.prestation == null ? 'Nouvelle Prestation' : 'Modifier la Prestation',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Informations de la prestation',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildFormField(
                        controller: _titleController,
                        label: 'Titre',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un titre';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: _descriptionController,
                        label: 'Description',
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une description';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: _establishmentController,
                        label: 'Établissement',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un établissement';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: _coverageController,
                        label: 'Couverture',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une couverture';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: _statusController,
                        label: 'Statut',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un statut';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: _contactController,
                        label: 'Contact',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un contact';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: _accessCodeController,
                        label: 'Code d\'accès',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un code d\'accès';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: _costController,
                        label: 'Coût (FCFA)',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un coût';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Veuillez entrer un nombre valide';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: _reasonController,
                        label: 'Raison',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une raison';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: _rateController,
                        label: 'Taux (%)',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un taux';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Veuillez entrer un nombre valide';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(
                    widget.prestation == null ? 'Ajouter' : 'Mettre à jour',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final prestation = Prestation(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        establishment: _establishmentController.text,
                        coverage: _coverageController.text,
                        status: _statusController.text,
                        contact: _contactController.text,
                        accessCode: _accessCodeController.text,
                        cost: double.parse(_costController.text),
                        reason: _reasonController.text,
                        rate: int.parse(_rateController.text),
                      );

                      try {
                        if (widget.prestation == null) {
                          await databaseService.addPrestation(prestation);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Prestation ajoutée avec succès')),
                          );
                        } else {
                          await databaseService.updatePrestation(
                            widget.prestation!.id,
                            prestation,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Prestation mise à jour avec succès')),
                          );
                        }
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur: ${e.toString()}')),
                          );
                        }
                      }
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );

  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _establishmentController.dispose();
    _coverageController.dispose();
    _statusController.dispose();
    _contactController.dispose();
    _accessCodeController.dispose();
    _costController.dispose();
    _reasonController.dispose();
    _rateController.dispose();
    super.dispose();
  }
}