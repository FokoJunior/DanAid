import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Modifier le Profil'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/logo/logo.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Utilisateur DonAid',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Bienvenue sur votre espace personnel'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await authService.signOut();
              },
              child: Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}