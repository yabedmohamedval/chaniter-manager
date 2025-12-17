import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_provider.dart';
import '../../state/equipe_provider.dart';
import '../home/home_screen.dart';
import 'equipe_detail_page.dart';

class EquipeListPage extends StatefulWidget {
  const EquipeListPage({super.key});

  @override
  State<EquipeListPage> createState() => _EquipeListPageState();
}

class _EquipeListPageState extends State<EquipeListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipeProvider>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<EquipeProvider>();
    final auth = context.watch<AuthProvider>();
    if (!auth.isResponsable) {
      return const Scaffold(body: Center(child: Text("Accès refusé")));
    }

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Équipes")),
      body: Builder(
        builder: (_) {
          if (p.loading) return const Center(child: CircularProgressIndicator());
          if (p.error != null) return Center(child: Text(p.error!));
          if (p.equipes.isEmpty) return const Center(child: Text("Aucune équipe."));

          return ListView.separated(
            itemCount: p.equipes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final e = p.equipes[index];
              return ListTile(
                title: Text(e.nom),
                subtitle: Text(e.chef == null ? "Chef: - " : "Chef: ${e.chef!.fullName}"),
                trailing: Text("${e.membres.length} membres"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EquipeDetailPage(equipeId: e.id)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
