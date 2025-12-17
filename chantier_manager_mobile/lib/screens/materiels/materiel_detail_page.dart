import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/materiel_provider.dart';
import 'materiel_manage_page.dart';

class MaterielDetailPage extends StatefulWidget {
  final int materielId;
  const MaterielDetailPage({super.key, required this.materielId});

  @override
  State<MaterielDetailPage> createState() => _MaterielDetailPageState();
}

class _MaterielDetailPageState extends State<MaterielDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaterielProvider>().fetchById(widget.materielId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MaterielProvider>();
    final m = p.selected;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails matériel"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: m == null ? null : () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MaterielManagePage(existing: m)),
              );
              if (mounted) context.read<MaterielProvider>().fetchById(widget.materielId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await context.read<MaterielProvider>().delete(widget.materielId);
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.error != null
          ? Center(child: Text(p.error!))
          : m == null
          ? const Center(child: Text("Introuvable"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(m.libelle, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text("Type: ${m.type ?? '-'}"),
            const SizedBox(height: 8),
            Text("Quantité totale: ${m.quantiteTotale}"),
          ],
        ),
      ),
    );
  }
}
