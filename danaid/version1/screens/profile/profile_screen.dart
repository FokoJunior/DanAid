import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = Provider.of<AuthService>(context);

    if (user == null) {
      return const Center(child: Text('Non connecté'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content: const Text('Voulez-vous vous déconnecter ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Déconnexion'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                await authService.signOut();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Avatar(radius: 50),
            const SizedBox(height: 20),
            Text(
              user.displayName ?? 'Utilisateur',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 5),
            Text(
              user.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            _buildListTile(
              icon: Icons.person_outline,
              title: 'Informations personnelles',
              onTap: () {
                // Navigate to personal info screen
              },
            ),
            _buildDivider(),
            _buildListTile(
              icon: Icons.history,
              title: 'Historique des prestations',
              onTap: () {
                // Navigate to history screen
              },
            ),
            _buildDivider(),
            _buildListTile(
              icon: Icons.settings_outlined,
              title: 'Paramètres',
              onTap: () {
                // Navigate to settings screen
              },
            ),
            _buildDivider(),
            _buildListTile(
              icon: Icons.help_outline,
              title: 'Aide & Support',
              onTap: () {
                // Show help dialog
              },
            ),
            _buildDivider(),
            _buildListTile(
              icon: Icons.info_outline,
              title: 'À propos',
              onTap: () {
                // Show about dialog
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(height: 1),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'DanAid',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(size: 50),
      children: const [
        SizedBox(height: 10),
        Text('Une application pour gérer vos prestations de santé.'),
      ],
    );
  }
}
