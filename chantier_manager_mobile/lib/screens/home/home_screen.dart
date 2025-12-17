import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chantier.dart';
import '../../models/enums.dart'; // pour StatutChantier
import '../../state/chantier_provider.dart';
import '../../state/auth_provider.dart';
import '../auth/login_screen.dart';
import '../chantier/chantier_detail_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StatutChantier? _selectedStatus; // null = tous

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<ChantierProvider>().loadChantiers(),
    );
  }

  Future<void> _refresh() async {
    await context.read<ChantierProvider>().loadChantiers();
  }

  @override
  Widget build(BuildContext context) {
    final isResponsable = context.watch<AuthProvider>().isResponsable;

    final chantierProvider = context.watch<ChantierProvider>();
    final auth = context.watch<AuthProvider>();


    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(isResponsable ? 'Tous les chantiers' : 'Mes chantiers'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),

      // bouton flottant visible seulement pour le responsable
      floatingActionButton: isResponsable
          ? FloatingActionButton.extended(
        onPressed: () {
          // on branchera plus tard sur l’écran de création de chantier
          // Navigator.of(context).push(...);
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau chantier'),
      )
          : null,

      body: Builder(
        builder: (context) {
          if (chantierProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chantierProvider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Erreur : ${chantierProvider.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final all = chantierProvider.chantiers;
          if (all.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('Aucun chantier')),
                ],
              ),
            );
          }

          // Filtre
          final filtered = _selectedStatus == null
              ? all
              : all.where((c) => c.statut == _selectedStatus).toList();

          // Stats
          final total = all.length;
          final enCours =
              all.where((c) => c.statut == StatutChantier.EN_COURS).length;
          final termines =
              all.where((c) => c.statut == StatutChantier.TERMINE).length;
          final nonRealises =
              all.where((c) => c.statut == StatutChantier.NON_REALISE).length;
          final interrompus =
              all.where((c) => c.statut == StatutChantier.INTERROMPU).length;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StatsCard(
                  total: total,
                  enCours: enCours,
                  termines: termines,
                  nonRealises: nonRealises,
                  interrompus: interrompus,
                ),
                const SizedBox(height: 16),
                _StatusFilterChips(
                  selected: _selectedStatus,
                  onChanged: (s) => setState(() => _selectedStatus = s),
                ),
                const SizedBox(height: 12),
                ...filtered.map(
                      (c) => _ChantierCard(
                    chantier: c,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChantierDetailScreen(chantier: c),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ---------- Widgets privés ----------

class _StatsCard extends StatelessWidget {
  final int total;
  final int enCours;
  final int termines;
  final int nonRealises;
  final int interrompus;

  const _StatsCard({
    required this.total,
    required this.enCours,
    required this.termines,
    required this.nonRealises,
    required this.interrompus,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget _stat(String label, int value) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString(),
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall,
          ),
        ],
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _stat('Total', total),
            _stat('En cours', enCours),
            _stat('Terminés', termines),
            _stat('Non réalisés', nonRealises),
            _stat('Interrompus', interrompus)
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text("Chantier Manager")),

          // visible pour tous
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Mes chantiers"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/chantiers");
              },

          ),

          const Divider(),

          // visible seulement RESPONSABLE
          if (auth.isResponsable) ...[
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text("Équipes"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/equipes");
              },
            ),
            ListTile(
              leading: const Icon(Icons.handyman),
              title: const Text("Matériels"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/materiels");
                },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text("Véhicules"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/vehicules");
              },
            ),
            const Divider(),
          ],

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Déconnexion"),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}


class _StatusFilterChips extends StatelessWidget {
  final StatutChantier? selected;
  final ValueChanged<StatutChantier?> onChanged;

  const _StatusFilterChips({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = <(String, StatutChantier?)>[
      ('Tous', null),
      ('En cours', StatutChantier.EN_COURS),
      ('Non réalisés', StatutChantier.NON_REALISE),
      ('Terminés', StatutChantier.TERMINE),
      ('Interrompus', StatutChantier.INTERROMPU),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final label = item.$1;
          final value = item.$2;
          final isSelected = selected == value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onChanged(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ChantierCard extends StatelessWidget {
  final Chantier chantier;
  final VoidCallback onTap;

  const _ChantierCard({
    required this.chantier,
    required this.onTap,
  });

  Color _statusColor(BuildContext context) {
    final s = chantier.statut;
    final colorScheme = Theme.of(context).colorScheme;

    switch (s) {
      case StatutChantier.EN_COURS:
        return Colors.orange;
      case StatutChantier.TERMINE:
        return Colors.green;
      case StatutChantier.NON_REALISE:
        return Colors.grey;
      case StatutChantier.INTERROMPU:
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }

  String _statusLabel() {
    switch (chantier.statut) {
      case StatutChantier.EN_COURS:
        return 'En cours';
      case StatutChantier.TERMINE:
        return 'Terminé';
      case StatutChantier.NON_REALISE:
        return 'Non réalisé';
      case StatutChantier.INTERROMPU:
        return 'Interrompu';
      default:
        return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context);

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // petite barre de couleur à gauche
              Container(
                width: 4,
                height: 56,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chantier.objet,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.place, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          chantier.lieu ?? '',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    if (chantier.dateDebut != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            chantier.dateDebut!
                                .toIso8601String()
                                .substring(0, 10),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(
                  _statusLabel(),
                  style: const TextStyle(fontSize: 11),
                ),
                backgroundColor: statusColor.withOpacity(0.1),
                side: BorderSide(color: statusColor),
                labelPadding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
