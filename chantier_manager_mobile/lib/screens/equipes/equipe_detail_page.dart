import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/equipe_provider.dart';
import '../home/home_screen.dart';
import 'equipe_manage_page.dart';


class EquipeDetailPage extends StatefulWidget {
  final int equipeId;
  const EquipeDetailPage({super.key, required this.equipeId});

  @override
  State<EquipeDetailPage> createState() => _EquipeDetailPageState();
}

class _EquipeDetailPageState extends State<EquipeDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipeProvider>().fetchById(widget.equipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<EquipeProvider>();
    final e = p.selected;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Détails équipe"),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts),
            tooltip: "Gérer",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EquipeManagePage(equipeId: widget.equipeId),
                ),
              );
              if (mounted) {
                context.read<EquipeProvider>().fetchById(widget.equipeId);
              }
            },
          ),
        ],
      ),

      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.error != null
          ? Center(child: Text(p.error!))
          : e == null
          ? const Center(child: Text("Equipe introuvable"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.nom, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text("Chef: ${e.chef?.fullName ?? '-'}"),
            const SizedBox(height: 16),
            Text("Membres (${e.membres.length})",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: e.membres.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final m = e.membres[i];
                  return ListTile(
                    title: Text(m.fullName),
                    subtitle: Text(m.role),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
