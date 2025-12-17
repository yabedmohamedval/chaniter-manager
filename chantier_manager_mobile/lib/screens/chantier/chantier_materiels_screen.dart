import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_provider.dart';

class ChantierMaterielsScreen extends StatelessWidget {
  final int chantierId;
  const ChantierMaterielsScreen({super.key, required this.chantierId});

  @override
  Widget build(BuildContext context) {
    final isResponsable = context.watch<AuthProvider>().isResponsable;

    return Scaffold(
      appBar: AppBar(title: Text("Matériel - Chantier #$chantierId")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isResponsable)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Affecter du matériel"),
                  onPressed: () {},
                ),
              ),
            const SizedBox(height: 12),
            const Expanded(
              child: Center(child: Text("TODO: Liste du matériel affecté à ce chantier")),
            ),
          ],
        ),
      ),
    );
  }
}
