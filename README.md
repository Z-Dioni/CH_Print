# CH Print 🖨️ 🚘

CH Print est une application mobile utilitaire développée en **Flutter**. Elle est conçue spécifiquement pour les professionnels du transit automobile (notamment en zones frontalières) afin d'automatiser et d'accélérer la création d'étiquettes de numéros de châssis.

Le processus manuel de création et d'impression de ces numéros (à coller à l'avant et à l'arrière des véhicules) est chronophage et sujet aux erreurs. CH Print résout ce problème avec une interface minimaliste, rapide et **100 % hors ligne**.

## ✨ Fonctionnalités principales

- **Saisie dynamique** : Ajout d'un nombre illimité de véhicules avec validation stricte (exactement 4 chiffres par numéro).
- **Moteur PDF intelligent** : 
  - Format A4 en orientation paysage.
  - Règle métier automatisée : 1 véhicule = 1 numéro = 2 exemplaires (avant/arrière).
  - Pagination automatique : Maximum 2 véhicules (soit 4 étiquettes) par page.
  - Lignes de découpe intégrées pour faciliter le travail sur le terrain.
- **Impression & Partage** : Aperçu natif, impression directe (Wi-Fi/Bluetooth) et partage du PDF généré.
- **Historique local** : Sauvegarde automatique des sessions de génération avec SQLite, consultable à tout moment sans connexion.
- **Mode sombre/clair** : Interface adaptative et ergonomique.

## 🛠️ Technologies et Packages

- **Framework** : [Flutter](https://flutter.dev/) (Dart)
- **Gestion d'état** : `flutter_bloc` & `equatable`
- **Génération PDF** : `pdf`
- **Impression et Aperçu** : `printing`
- **Base de données** : `sqflite` & `path_provider` (Historique local)
- **Architecture** : Clean Architecture simplifiée (Séparation claire entre UI, State, Services et Data).

## 🏗️ Architecture du projet

```text
lib/
├── core/       # Thème, constantes et utilitaires (validateurs)
├── data/       # Modèles de données (Vehicle, PrintHistory) et config SQLite
├── services/   # Logique métier pure (Génération PDF, appels base de données)
├── state/      # Blocs (VehicleBloc, HistoryBloc) pour la gestion d'état réactive
├── screens/    # Écrans de l'application (Accueil, Historique, Aperçu, etc.)
└── widgets/    # Composants UI réutilisables (ChassisInput, VehicleCard)

🚀 Installation et exécution

    Clonez ce dépôt :
    Bash

    git clone [https://github.com/votre-nom/ch_print.git](https://github.com/votre-nom/ch_print.git)

    Accédez au dossier du projet :
    Bash

    cd ch_print

    Installez les dépendances :
    Bash

    flutter pub get

    Lancez l'application (sur un émulateur ou un appareil physique) :
    Bash

    flutter run

🔒 Confidentialité et Données

CH Print a été pensée pour la confidentialité et la fiabilité. Aucune donnée ne quitte l'appareil. L'application ne contient aucun backend, aucune API externe, et ne requiert aucune connexion Internet pour fonctionner.

Développé avec ❤️ pour simplifier le quotidien des professionnels du transit.


<FollowUp label="C'est parfait, je l'ai ajouté. Reprenons à l'étape 5 (Validation des champs) !" query="Le README est sur GitHub ! Reprenons à l'étape 5 : Ajout de la validation métier pour empêcher la génération si un champ est invalide."/>