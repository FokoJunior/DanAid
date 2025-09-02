import 'package:flutter/material.dart';
import '../models/prestation.dart';

class PrestationCard extends StatelessWidget {
  final Prestation prestation;
  final VoidCallback onTap;

  const PrestationCard({
    required this.prestation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        onTap: onTap,
        title: Text(
          prestation.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prestation.establishment),
            Text('Coût: ${prestation.cost} FCFA'),
            Row(
              children: [
                Chip(
                  label: Text(
                    prestation.status,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: prestation.status == 'Active'
                      ? Colors.green
                      : Colors.grey,
                ),
                SizedBox(width: 5),
                Chip(
                  label: Text(
                    'Taux: ${prestation.rate}%',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}