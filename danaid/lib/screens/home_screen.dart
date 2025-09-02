import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io' show Platform;
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/prestation.dart';
import '../widgets/prestation_card.dart';
import 'add_edit_prestation_screen.dart';
import 'prestation_detail_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = true;
  int _selectedIndex = 0;
  User? _user;
  
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _scrollController.addListener(_scrollListener);
  }



  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 100 && _showAppBar) {
      setState(() => _showAppBar = false);
    } else if (_scrollController.offset <= 100 && !_showAppBar) {
      setState(() => _showAppBar = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    if (_user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Utilisateur non connecté'),
        ),
      );
    }

    final databaseService = DatabaseService(uid: _user!.uid);

    return Scaffold(
      extendBodyBehindAppBar: _selectedIndex == 0,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem('Accueil', Icons.home_outlined, 0),
              _buildNavItem('Profil', Icons.person_outline, 1),
            ],
          ),
        ),
      ),
      appBar: _selectedIndex == 1
          ? const CustomAppBar(title: 'Profil')
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Image.asset(
                'assets/logo/logo.png',
                height: 40,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await authService.signOut();
                  },
                ),
              ],
            ),
      body: Column(
        children: [
          // Hero Section
          if (_selectedIndex == 0)
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/hero1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black26, Colors.black87],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Bienvenue sur DanAid',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                // Accueil Tab
                StreamBuilder<List<Prestation>>(
                  stream: databaseService.prestations,
                  builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final prestations = snapshot.data ?? [];

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: prestations.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PrestationCard(
                        prestation: prestations[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrestationDetailScreen(
                                prestation: prestations[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                      },
                    );
                  },
                ),
                // Profil Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              child: _user?.photoURL != null && _user!.photoURL!.isNotEmpty
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: _user!.photoURL!,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.person, size: 60),
                                      ),
                                    )
                                  : const Icon(Icons.person, size: 60, color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _user?.displayName ?? 'Utilisateur',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_user?.email != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _user!.email!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      _buildInfoCard(
                        context,
                        'Informations Personnelles',
                        [
                          _buildInfoRow(Icons.phone, 'Téléphone', _user?.phoneNumber ?? 'Non renseigné'),
                          _buildInfoRow(Icons.calendar_today, 'Compte créé le',
                              _user?.metadata.creationTime?.toLocal().toString().split(' ')[0] ?? 'Date inconnue'),
                          _buildInfoRow(Icons.login, 'Dernière connexion',
                              _user?.metadata.lastSignInTime?.toLocal().toString().split('.')[0] ?? 'Inconnue'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        context,
                        'Actions',
                        [
                          ListTile(
                            leading: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                            title: const Text('Modifier le profil'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditPrestationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
              backgroundColor: Theme.of(context).primaryColor,
            )
          : null,
    );
  }

  Widget _buildNavItem(String title, IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: _selectedIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
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
}