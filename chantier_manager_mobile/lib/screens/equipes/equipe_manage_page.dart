// pages/equipe_manage_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/utilisateur_light.dart';
import '../../state/auth_provider.dart';
import '../../state/equipe_provider.dart';
import '../../services/utilisateur_service.dart';
import '../../services/api_client.dart';
import '../home/home_screen.dart';

class EquipeManagePage extends StatefulWidget {
  final int equipeId;
  const EquipeManagePage({super.key, required this.equipeId});

  @override
  State<EquipeManagePage> createState() => _EquipeManagePageState();
}

class _EquipeManagePageState extends State<EquipeManagePage> {
  late final UtilisateurService userService;

  List<UtilisateurLight> chefs = [];
  List<UtilisateurLight> equipiers = [];
  bool loadingUsers = true;
  String? usersError;

  @override
  void initState() {
    super.initState();

    // Si tu as déjà un ApiClient singleton, utilise-le.
    final apiClient = ApiClient(
      getToken: () async => context.read<AuthProvider>().token,
    );

    userService = UtilisateurService(apiClient);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<EquipeProvider>().fetchById(widget.equipeId);
      await _loadUsers();
    });
  }

  Future<void> _loadUsers() async {
    setState(() { loadingUsers = true; usersError = null; });
    try {
      chefs = await userService.getByRole("CHEF_CHANTIER");
      equipiers = await userService.getByRole("EQUIPIER");
    } catch (e) {
      usersError = e.toString();
    } finally {
      setState(() { loadingUsers = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isResponsable) {
      return const Scaffold(body: Center(child: Text("Accès refusé")));
    }
    final p = context.watch<EquipeProvider>();
    final equipe = p.selected;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Gestion équipe")),
      body: p.loading && equipe == null
          ? const Center(child: CircularProgressIndicator())
          : p.error != null
          ? Center(child: Text(p.error!))
          : equipe == null
          ? const Center(child: Text("Équipe introuvable"))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(equipe.nom, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),

          _sectionChef(context, p, equipe.chef),
          const SizedBox(height: 24),

          _sectionMembres(context, p, equipe.membres),
          const SizedBox(height: 16),

          if (loadingUsers) const Center(child: CircularProgressIndicator()),
          if (usersError != null) Text(usersError!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _sectionChef(BuildContext context, EquipeProvider p, UtilisateurLight? chef) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.badge),
            const SizedBox(width: 12),
            Expanded(
              child: Text("Chef: ${chef?.fullName ?? '-'}"),
            ),
            TextButton(
              onPressed: loadingUsers ? null : () async {
                final picked = await _pickUser(
                  context: context,
                  title: "Choisir un chef",
                  users: chefs,
                );
                if (picked != null) {
                  await p.changeChef(equipeId: widget.equipeId, chefId: picked.id);
                }
              },
              child: const Text("Changer"),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionMembres(BuildContext context, EquipeProvider p, List<UtilisateurLight> membres) {
    final equipeChefId = p.selected?.chef?.id;
    final membreIds = membres.map((m) => m.id).toSet();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.group),
                const SizedBox(width: 12),
                Expanded(child: Text("Membres (${membres.length})",
                    style: Theme.of(context).textTheme.titleMedium)),
                IconButton(
                  tooltip: "Ajouter",
                  onPressed: loadingUsers ? null : () async {
                    // candidates = equipiers non déjà membres et != chef
                    final candidates = equipiers.where((u) =>
                    !membreIds.contains(u.id) && u.id != equipeChefId
                    ).toList();

                    final picked = await _pickUser(
                      context: context,
                      title: "Ajouter un membre",
                      users: candidates,
                    );
                    if (picked != null) {
                      await p.addMembre(equipeId: widget.equipeId, userId: picked.id);
                    }
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                )
              ],
            ),
            const Divider(),
            if (membres.isEmpty)
              const Text("Aucun membre.")
            else
              ...membres.map((m) => ListTile(
                dense: true,
                title: Text(m.fullName),
                subtitle: Text(m.role),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () async {
                    await p.removeMembre(equipeId: widget.equipeId, userId: m.id);
                  },
                ),
              )),
          ],
        ),
      ),
    );
  }

  Future<UtilisateurLight?> _pickUser({
    required BuildContext context,
    required String title,
    required List<UtilisateurLight> users,
  }) async {
    return showModalBottomSheet<UtilisateurLight>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final controller = TextEditingController();
        List<UtilisateurLight> filtered = users;

        return StatefulBuilder(
          builder: (ctx, setState) {
            void filter(String q) {
              final query = q.toLowerCase().trim();
              setState(() {
                filtered = users.where((u) =>
                u.fullName.toLowerCase().contains(query) ||
                    u.role.toLowerCase().contains(query)
                ).toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16, right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: Theme.of(ctx).textTheme.titleLarge),
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
                        ? const Center(child: Text("Aucun résultat"))
                        : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final u = filtered[i];
                        return ListTile(
                          title: Text(u.fullName),
                          subtitle: Text(u.role),
                          onTap: () => Navigator.pop(ctx, u),
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
