

# DanAid

Application Flutter moderne avec Firebase (Auth + Firestore) pour gérer les prestations. Compatible Web et Mobile.

## Fonctionnalités

* Authentification par email/mot de passe (connexion & inscription)
* Édition du profil (nom d’affichage, photo de profil)
* Ajout/Modification/Suppression de prestations filtrées par utilisateur connecté
* Interface attrayante : barre d’application personnalisée, en-tête avec effet héro, cartes, badges, formulaires soignés
* Initialisation Firebase corrigée pour Flutter Web

## Prérequis

* Flutter 3.32.4 
* Dart 3.8.1
* DevTools 2.45.1
* Projet Firebase (Auth + Firestore activés)
* Git
* Android Studio
* Visual Studio Code


## Mise en route

1. Cloner le projet

```bash
git clone https://github.com/FokoJunior/DanAid.git
cd DanAid/danaid
```

2. Installer les dépendances

```bash
flutter pub get
```

3. Configurer Firebase

* Créer un projet Firebase.
* Activer l’authentification (Email/Mot de passe) et Firestore.
* Utiliser FlutterFire pour générer `lib/firebase_options.dart` :


```bash
flutterfire configure
```

* Pour le Web, assurez-vous que `web/index.html` contient les balises SDK Firebase ou utilisez `firebase_options.dart` avec `DefaultFirebaseOptions.currentPlatform` dans `lib/main.dart`.

4. Règles de sécurité Firestore (en développement)
   Utiliser des règles permissives pour les utilisateurs authentifiés pendant le développement :

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /prestations/{id} {
      allow read, write: if request.auth != null && request.auth.uid != null;
    }
    match /users/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```


5. Lancer l’application

```bash
flutter run -d chrome
# ou
flutter run
```

## Structure du projet

* `lib/main.dart` – Point d’entrée et initialisation Firebase
* `lib/screens/` – Écrans de l’UI (accueil, auth, profil, ajout/édition prestation, détails)
* `lib/widgets/` – Widgets réutilisables (ex. CustomAppBar, CustomTextField)
* `lib/services/` – Abstractions pour Firebase (AuthService, DatabaseService)
* `lib/models/` – Modèles de données (ex. Prestation)

## Interface notable

* `lib/widgets/custom_app_bar.dart` – Logo plus grand, bouton retour, barres unifiées
* `lib/screens/home_screen.dart` – Image héro sur l’accueil, affichage vide s’il n’y a pas de prestations
* `lib/screens/prestation_detail_screen.dart` – En-tête dégradé avec badges et boutons d’action
* `lib/screens/add_edit_prestation_screen.dart` – Formulaire dans une carte avec validation et bouton de soumission pleine largeur
* `lib/screens/auth_screen.dart` – Connexion/Inscription avec confirmation du mot de passe à l’inscription

## Environnement & Assets

* Vérifiez que les assets sont déclarés dans `pubspec.yaml` :

```yaml
assets:
  - assets/logo/logo.png
  - assets/image/hero1.png
```

## Problèmes courants

* **FirebaseOptions nul sur le Web** : vérifiez que `DefaultFirebaseOptions.currentPlatform` est utilisé dans `main.dart` et que `firebase_options.dart` existe.
* **Erreur permission-denied Firestore** : vérifiez les règles et que l’utilisateur est bien authentifié.
* **Problèmes CORS sur le Web** : exécutez via `flutter run -d chrome` ou un hébergement approprié.

## Scripts

* Analyse du code : `flutter analyze`
* Formatage : `flutter format .`

