# Baker-eat

## 🥐 Uber Eats des Boulangeries — Commande & Gestion en Temps Réel

**Baker-eat** est une application mobile et web inspirée d’Uber Eats, dédiée aux boulangeries. Elle permet aux clients de découvrir les produits, de commander en ligne, de gérer un panier, et d’être livrés ou de retirer en boutique, tandis que les boulangers gèrent facilement leur offre et leurs commandes en temps réel.

---

## 🚀 Fonctionnalités principales

- 📜 **Menu interactif** : Parcours facile des produits et offres de chaque boulangerie.
- 🏠 **Page Boulangerie** : Présentation de la boulangerie avec description, horaires, coordonnées, etc.
- 🥐 **Page Produit** : Détail du produit avec description, prix, visuel et possibilité d’ajouter au panier.
- 🛒 **Panier** : Ajout et gestion des produits sélectionnés, modification des quantités, passage de commande.
- 📦 **Commande en ligne** : Paiement sécurisé, choix retrait ou livraison.
- 🔔 **Notifications** : Suivi en temps réel de la commande.

---

## 🔧 Technologies utilisées

| Technologie       | Rôle                                                        |
|-------------------|-------------------------------------------------------------|
| **Flutter & Dart**| Frontend mobile (Android, iOS) et web, interface utilisateur|
| **Node.js**       | Backend (API, gestion des commandes, paniers, produits)     |
| **Railway**       | Déploiement et hébergement du backend Node.js               |
| **Android**       | Déploiement natif mobile                                    |

---

## 🧪 Installation et utilisation

### 1️⃣ Prérequis : Installer Flutter

Rendez-vous sur la documentation officielle pour installer Flutter et Dart :  
👉 [Installer Flutter](https://docs.flutter.dev/get-started/install)

Assurez-vous que la commande suivante fonctionne :

```bash
flutter --version
```

### 2️⃣ Structure du projet

Le repository contient deux répertoires principaux :
- `app` : le frontend Flutter (mobile/web)
- `api` : le backend Node.js (API REST)

```
/app     # Application Flutter (front)
/api     # API Node.js (back)
```

### 3️⃣ Installation des dépendances

#### a. Application Flutter (`app`)

```bash
cd app
flutter pub get
```

#### b. API Node.js (`api`)

```bash
cd ../api
npm install
```

### 4️⃣ Lancement en local

#### a. Démarrer l’API

```bash
cd api
npm run dev
```

#### b. Démarrer l’application Flutter

```bash
cd ../app
flutter run
```

### 5️⃣ Déploiement

- **Backend Node.js** : Déployé sur [Railway](https://railway.app/)
- **Frontend Android** : Génération APK ou bundle via `flutter build apk` ou publication sur Google Play

---

## 📚 Documentation

- 📖 [Flutter](https://docs.flutter.dev/) — Développement mobile/web multiplateforme.
- 🧑‍💻 [Dart](https://dart.dev/guides) — Langage principal du frontend.
- 🚀 [Node.js](https://nodejs.org/fr/docs/) — Backend et API REST.
- ☁️ [Railway](https://docs.railway.app/) — Déploiement du backend.
- 🤖 [Android](https://developer.android.com/docs) — Déploiement mobile natif.

---

## 📄 LICENSE

© 2025 – Tous droits réservés.

Ce projet est protégé. Il ne peut être copié, distribué ou utilisé sans autorisation préalable de l’auteur.  
Voir le fichier [LICENSE](./LICENSE) pour plus d’informations.
