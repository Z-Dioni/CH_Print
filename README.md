# CH Print 🖨️ 🚘

CH Print est une application mobile développée avec Flutter pour faciliter la création et l'impression d'étiquettes de numéros de châssis dans le secteur du transit automobile.

L'objectif est simple : éliminer le travail manuel, réduire les erreurs et permettre une impression rapide et fiable, directement depuis le terrain, sans dépendre d'un serveur ni d'une connexion Internet.

## ✨ Fonctionnalités

- Saisie rapide de plusieurs véhicules
- Validation stricte des numéros de châssis (4 chiffres par véhicule)
- Génération automatique de documents PDF au format A4 paysage
- Règle métier intégrée : 1 véhicule = 1 numéro = 2 impressions (avant/arrière)
- Pagination automatique des étiquettes
- Lignes de découpe intégrées pour faciliter la découpe et l'application
- Aperçu natif avant impression
- Impression directe via le système d'impression du device
- Partage du PDF généré
- Historique local sauvegardé en base SQLite
- Support du thème clair et sombre
- 100 % hors ligne

## 🛠️ Stack technique

- Flutter
- Dart
- flutter_bloc
- equatable
- pdf
- printing
- sqflite
- path_provider
- intl
- url_launcher

## 🏗️ Structure du projet

```text
lib/
├── core/        # Thème, utilitaires et validations
├── data/        # Modèles de données et base SQLite
├── services/    # Logique métier et génération PDF
├── state/       # Blocs et gestion d'état
├── screens/     # Écrans de l'application
├── widgets/     # Composants UI réutilisables
├── main.dart    # Point d'entrée de l'application
└── README.md    # Documentation du projet
```

## ✅ Prérequis

Avant de lancer le projet, assurez-vous d'avoir installé :

- Flutter SDK
- Android Studio ou VS Code avec les outils Flutter
- Un émulateur Android ou un appareil physique connecté

Vérifiez la bonne installation avec :

```bash
flutter --version
```

## 🚀 Installation

1. Clonez le dépôt :

```bash
git clone https://github.com/votre-nom/ch_print.git
```

2. Accédez au dossier du projet :

```bash
cd ch_print
```

3. Installez les dépendances :

```bash
flutter pub get
```

## ▶️ Lancer l'application

```bash
flutter run
```

Pour une version spécifique de plateforme :

```bash
flutter run -d android
```

## 📄 Utilisation

1. Ajoutez un ou plusieurs véhicules.
2. Saisissez le numéro de châssis correspondant.
3. Vérifiez la validation automatique des champs.
4. Générez le PDF.
5. Prévisualisez, imprimez ou partagez le document.

## 🔒 Confidentialité et sécurité

CH Print fonctionne entièrement localement. Aucune donnée n'est envoyée vers un backend externe et l'application ne nécessite pas de connexion Internet pour fonctionner.

## 📌 À propos

Ce projet a été conçu pour simplifier le quotidien des professionnels du transit automobile, en réduisant les erreurs humaines et en accélérant les tâches de préparation et d'impression.

Développé avec ❤️ en Flutter.
