import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/vehicule_provider.dart';
import 'vehicule_manage_page.dart';

class VehiculeDetailPage extends StatefulWidget {
  final int vehiculeId;
  const VehiculeDetailPage({super.key, required this.vehiculeId});

  @override
  State<VehiculeDetailPage> createState() => _VehiculeDetailPageState();
}

class _VehiculeDetailPageState extends State<VehiculeDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehiculeProvider>().fetchById(widget.vehiculeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<VehiculeProvider>();
    final v = p.selected;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails véhicule"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: v == null ? null : () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VehiculeManagePage(existing: v)),
              );
              if (mounted) context.read<VehiculeProvider>().fetchById(widget.vehiculeId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await context.read<VehiculeProvider>().delete(widget.vehiculeId);
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.error != null
          ? Center(child: Text(p.error!))
          : v == null
          ? const Center(child: Text("Introuvable"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(v.libelle ?? "Véhicule #${v.id}", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text("Immatriculation: ${v.immatriculation ?? '-'}"),
            const SizedBox(height: 8),
            Text("Type: ${v.type ?? '-'}"),
            const SizedBox(height: 8),
            Text("Disponible: ${v.disponible ? 'Oui' : 'Non'}"),
          ],
        ),
      ),
    );
  }
}
