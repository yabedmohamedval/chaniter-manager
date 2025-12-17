import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_provider.dart';
import '../../state/materiel_provider.dart';
import 'materiel_detail_page.dart';
import 'materiel_manage_page.dart';

class MaterielListPage extends StatefulWidget {
  const MaterielListPage({super.key});

  @override
  State<MaterielListPage> createState() => _MaterielListPageState();
}

class _MaterielListPageState extends State<MaterielListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaterielProvider>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isResponsable) {
      return const Scaffold(body: Center(child: Text("Accès refusé")));
    }

    final p = context.watch<MaterielProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Matériels")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterielManagePage()));
          if (mounted) context.read<MaterielProvider>().fetchAll();
        },
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.error != null
          ? Center(child: Text(p.error!))
          : p.items.isEmpty
          ? const Center(child: Text("Aucun matériel."))
          : ListView.separated(
        itemCount: p.items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final m = p.items[i];
          return ListTile(
            title: Text(m.libelle),
            subtitle: Text(m.type == null ? "-" : "Type: ${m.type}"),
            trailing: Text("Qté: ${m.quantiteTotale}"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MaterielDetailPage(materielId: m.id)),
            ),
          );
        },
      ),
    );
  }
}
