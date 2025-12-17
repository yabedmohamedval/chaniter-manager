# Chantier Manager — Application mobile + API


## 1) Présentation
Chantier Manager est une application permettant de gérer des chantiers (suivi, détails, anomalies, équipes, véhicules, matériels) avec une API sécurisée et une application mobile Flutter.

L’application est **rôle-based** :
- **RESPONSABLE_CHANTIERS** : accès global (tous les chantiers + gestion des référentiels : équipes, véhicules, matériels + affectations).
- **CHEF_CHANTIER** : accès aux chantiers qui le concernent (consultation + actions autorisées selon le besoin).
- **EQUIPIER** : accès limité (consultation selon règles).

## 2) Technologies utilisées
### Backend (API)
- Java + Spring Boot
- Spring Web (REST)
- Spring Security + JWT
- JPA / Hibernate
- Base de données : PostgreSQL (ou autre selon configuration)
- Gestion des fichiers statiques : `/uploads/**` via ResourceHandler (photos d’anomalies)

### Mobile
- Flutter (Dart)
- Provider (state management)
- HTTP + stockage sécurisé du token (FlutterSecureStorage)

## 3) Fonctionnalités implémentées
### Authentification & sécurité
- Connexion via email/mot de passe
- JWT stocké en local (secure storage)
- Rôles et filtrage d’accès aux écrans & endpoints

### Chantiers
- Liste des chantiers (filtrage par statut)
- Détails d’un chantier
- Écran de navigation vers modules du chantier (anomalies, véhicules, matériels, équipe)

### Anomalies + photos
- Liste des anomalies d’un chantier
- Ajout d’anomalies
- Upload photo côté backend + accès via URL `/uploads/...`
- Affichage des photos sur mobile

### Équipes (référentiel + gestion)
- Liste des équipes
- Détails d’une équipe (chef + membres)
- Gestion : changer chef, ajouter/supprimer des membres (sélection depuis liste des utilisateurs existants)

### Véhicules
- CRUD véhicules (référentiel)
- Affectation d’un véhicule à un chantier (1 véhicule → 0..1 chantier)
- Liste des véhicules affectés à un chantier + désaffectation
- Liste des véhicules disponibles (`/api/vehicules/disponibles`)

### Matériels
- CRUD matériels (référentiel)
- (Optionnel selon implémentation) affectation au chantier / liste par chantier

## 4) Lancer le projet
### Backend
1. Configurer la BDD (application.properties / application.yml)
2. Lancer l’API Spring Boot
3. Vérifier les endpoints :
   - `GET /api/chantiers`
   - `GET /api/chantiers/{id}/vehicules`
   - `GET /api/vehicules/disponibles`
   - `GET /uploads/...` (photos)

### Mobile
1. Mettre à jour l’IP de l’API dans :
   - `ApiConfig.hostBaseUrl` (ex: `http://<IP>:8083`)
2. `flutter pub get`
3. `flutter run`


