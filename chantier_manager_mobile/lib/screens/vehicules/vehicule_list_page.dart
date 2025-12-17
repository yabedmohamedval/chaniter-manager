import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_provider.dart';
import '../../state/vehicule_provider.dart';
import 'vehicule_detail_page.dart';
import 'vehicule_manage_page.dart';

class VehiculeListPage extends StatefulWidget {
  const VehiculeListPage({super.key});

  @override
  State<VehiculeListPage> createState() => _VehiculeListPageState();
}

class _VehiculeListPageState extends State<VehiculeListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehiculeProvider>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isResponsable) {
      return const Scaffold(body: Center(child: Text("Accès refusé")));
    }

    final p = context.watch<VehiculeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Véhicules")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const VehiculeManagePage()));
          if (mounted) context.read<VehiculeProvider>().fetchAll();
        },
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.error != null
          ? Center(child: Text(p.error!))
          : p.items.isEmpty
          ? const Center(child: Text("Aucun véhicule."))
          : ListView.separated(
        itemCount: p.items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final v = p.items[i];
          return ListTile(
            title: Text(v.libelle ?? "Véhicule #${v.id}"),
            subtitle: Text("Immat: ${v.immatriculation ?? '-'} • Type: ${v.type ?? '-'}"),
            trailing: Icon(v.disponible ? Icons.check_circle : Icons.block),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VehiculeDetailPage(vehiculeId: v.id)),
            ),
          );
        },
      ),
    );
  }
}
