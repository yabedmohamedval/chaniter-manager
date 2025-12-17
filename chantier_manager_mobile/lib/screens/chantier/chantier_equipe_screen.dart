import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_provider.dart';

class ChantierEquipeScreen extends StatelessWidget {
  final int chantierId;
  const ChantierEquipeScreen({super.key, required this.chantierId});

  @override
  Widget build(BuildContext context) {
    final isResponsable = context.watch<AuthProvider>().isResponsable;

    return Scaffold(
      appBar: AppBar(title: Text("Équipe - Chantier #$chantierId")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Équipe affectée à ce chantier",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // TODO: afficher équipe affectée (nom, chef, membres)
            const Card(
              child: ListTile(
                title: Text("TODO: Nom équipe"),
                subtitle: Text("TODO: Chef + nb membres"),
              ),
            ),

            const SizedBox(height: 16),

            if (isResponsable)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text("Affecter / Changer l’équipe"),
                  onPressed: () {
                    // TODO: ouvrir un picker d’équipes (EquipeListPage en mode sélection)
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
