import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_provider.dart';
import '../../state/chantier_vehicule_provider.dart';
import '../../models/vehicule.dart';

class ChantierVehiculesScreen extends StatefulWidget {
  final int chantierId;
  const ChantierVehiculesScreen({super.key, required this.chantierId});

  @override
  State<ChantierVehiculesScreen> createState() => _ChantierVehiculesScreenState();
}

class _ChantierVehiculesScreenState extends State<ChantierVehiculesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChantierVehiculeProvider>().load(widget.chantierId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final p = context.watch<ChantierVehiculeProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Véhicules - Chantier #${widget.chantierId}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (auth.isResponsable)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Affecter un véhicule"),
                  onPressed: p.loading ? null : () async {
                    final picked = await _pickVehicule(context, p.available);
                    if (picked != null) {
                      await context.read<ChantierVehiculeProvider>()
                          .affecter(widget.chantierId, picked.id);
                      if (mounted && p.error == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Véhicule affecté ✅")),
                        );
                      }
                    }
                  },
                ),
              ),

            const SizedBox(height: 12),

            if (p.loading) const LinearProgressIndicator(),
            if (p.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(p.error!, style: const TextStyle(color: Colors.red)),
              ),

            const SizedBox(height: 12),

            Expanded(
              child: p.assigned.isEmpty
                  ? const Center(child: Text("Aucun véhicule affecté à ce chantier."))
                  : ListView.separated(
                itemCount: p.assigned.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final v = p.assigned[i];
                  return ListTile(
                    title: Text(v.libelle ?? "Véhicule #${v.id}"),
                    subtitle: Text("Immat: ${v.immatriculation ?? '-'} • Type: ${v.type ?? '-'}"),
                    trailing: auth.isResponsable
                        ? IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: "Désaffecter",
                      onPressed: p.loading ? null : () async {
                        await context.read<ChantierVehiculeProvider>()
                            .desaffecter(widget.chantierId, v.id);
                      },
                    )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Vehicule?> _pickVehicule(BuildContext context, List<Vehicule> vehicules) {
    return showModalBottomSheet<Vehicule>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final controller = TextEditingController();
        List<Vehicule> filtered = vehicules;

        return StatefulBuilder(
          builder: (ctx, setState) {
            void filter(String q) {
              final query = q.toLowerCase().trim();
              setState(() {
                filtered = vehicules.where((v) {
                  final title = (v.libelle ?? "").toLowerCase();
                  final immat = (v.immatriculation ?? "").toLowerCase();
                  final type = (v.type ?? "").toLowerCase();
                  return title.contains(query) || immat.contains(query) || type.contains(query);
                }).toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16, right: 16, top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Choisir un véhicule", style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Rechercher...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: filter,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 420,
                    child: filtered.isEmpty
                        ? const Center(child: Text("Aucun véhicule disponible"))
                        : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final v = filtered[i];
                        return ListTile(
                          title: Text(v.libelle ?? "Véhicule #${v.id}"),
                          subtitle: Text("Immat: ${v.immatriculation ?? '-'} • Type: ${v.type ?? '-'}"),
                          onTap: () => Navigator.pop(ctx, v),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
