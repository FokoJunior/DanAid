import 'package:flutter/material.dart';
import '../models/prestation.dart';

class PrestationCard extends StatelessWidget {
  final Prestation prestation;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PrestationCard({
    super.key,
    required this.prestation,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      prestation.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  if (onDelete != null) ...{
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                  },
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: prestation.status == 'Cloturé'
                          ? Colors.grey[200]
                          : Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      prestation.status,
                      style: TextStyle(
                        color: prestation.status == 'Cloturé'
                            ? Colors.grey[700]
                            : Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.local_hospital, prestation.hospital),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.receipt_long, 'Réf: ${prestation.reference}'),
              if (prestation.date != null) ...{
                const SizedBox(height: 4),
                _buildInfoRow(
                  Icons.calendar_today,
                  '${prestation.date!.day}/${prestation.date!.month}/${prestation.date!.year}',
                ),
              },
              if (prestation.amount != null && prestation.coverageRate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${prestation.amount!.toStringAsFixed(0)} FCFA',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Taux: ${prestation.coverageRate!.toInt()}%',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
