import 'package:chantier_manager_mobile/screens/materiels/materiel_list_page.dart';
import 'package:chantier_manager_mobile/screens/vehicules/vehicule_list_page.dart';
import 'package:chantier_manager_mobile/services/chantier_vehicule_service.dart';
import 'package:chantier_manager_mobile/services/materiel_service.dart';
import 'package:chantier_manager_mobile/services/vehicule_service.dart';
import 'package:chantier_manager_mobile/state/chantier_vehicule_provider.dart';
import 'package:chantier_manager_mobile/state/materiel_provider.dart';
import 'package:chantier_manager_mobile/state/vehicule_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'state/auth_provider.dart';
import 'state/chantier_provider.dart';
import 'state/equipe_provider.dart';
import 'services/api_client.dart';
import 'services/equipe_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/equipes/equipe_list_page.dart';


void main() {
  runApp(const ChantierManagerApp());
}

class ChantierManagerApp extends StatelessWidget {
  const ChantierManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => ChantierProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => EquipeProvider(
            EquipeService(ApiClient(getToken: () async => await authService.getToken())),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MaterielProvider(
            MaterielService(ApiClient(getToken: authService.getToken)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => VehiculeProvider(
            VehiculeService(ApiClient(getToken: authService.getToken)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ChantierVehiculeProvider(
            ChantierVehiculeService(
              ApiClient(getToken: authService.getToken),
            ),
          ),
        ),

      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Chantier Manager',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: auth.isLoggedIn ? '/chantiers' : '/login',

            routes: {
              '/login': (_) => const LoginScreen(),
              '/chantiers': (_) => const HomeScreen(),
              '/equipes': (_) => const EquipeListPage(),
              '/materiels': (_) => const MaterielListPage(),
              '/vehicules': (_) => const VehiculeListPage(),
            },
          );
        },
      ),
    );
  }
}
