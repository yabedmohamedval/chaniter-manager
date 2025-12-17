import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chantier.dart';
import '../../models/enums.dart';
import '../../state/auth_provider.dart';
import '../../state/chantier_provider.dart';
import 'chantier_edit_screen.dart';
import 'chantier_anomalies_screen.dart';
import 'chantier_equipe_screen.dart';
import 'chantier_materiels_screen.dart';
import 'chantier_vehicules_screen.dart';


class ChantierDetailScreen extends StatefulWidget {
  final Chantier chantier;

  const ChantierDetailScreen({super.key, required this.chantier});

  @override
  State<ChantierDetailScreen> createState() => _ChantierDetailScreenState();
}

class _ChantierDetailScreenState extends State<ChantierDetailScreen> {
  late Chantier _chantier;


  @override
  void initState() {
    super.initState();
    _chantier = widget.chantier;
  }



  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Chantier>(
      MaterialPageRoute(
        builder: (_) => ChantierEditScreen(chantier: _chantier),
      ),
    );

    if (updated != null && mounted) {
      setState(() {
        _chantier = updated;
      });
      await context.read<ChantierProvider>().loadChantiers();
    }
  }

  Color _statusColor(StatutChantier? s) {
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
        return Colors.blueGrey;
    }
  }

  String _statusLabel(StatutChantier? s) {
    switch (s) {
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
    final c = _chantier;
    final isResponsable = context.watch<AuthProvider>().isResponsable;


    return Scaffold(
      appBar: AppBar(
        title: Text('Chantier #${c.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _openEdit,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChantierAnomaliesScreen(chantier: c),
            ),
          );
        },
        icon: const Icon(Icons.report_problem),
        label: const Text('Anomalies'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- Carte principale (UNE seule fois) ----
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre du chantier
                  Text(
                    c.objet,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Ligne "Statut  [badge]"
                  Row(
                    children: [
                      const Text(
                        'Statut',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      // petit badge pour le statut
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _statusColor(c.statut)),
                        ),
                        child: Text(
                          _statusLabel(c.statut),
                          style: TextStyle(
                            color: _statusColor(c.statut),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Lieu + date alignés à droite, icônes à gauche du texte
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bloc LIEU à gauche
                      Row(
                        children: [
                          const Icon(Icons.place, size: 16),
                          const SizedBox(width: 4),
                          Text(c.lieu ?? '—'),
                        ],
                      ),

                      // Bloc DATE à droite (uniquement si présente)
                      if (c.dateDebut != null)
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              c.dateDebut!.toIso8601String().substring(0, 10),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),

            ),
          ),

          const SizedBox(height: 16),


    _ModuleCard(
    title: "Anomalies",
    subtitle: "Voir / ajouter les anomalies du chantier",
    icon: Icons.report_problem,
    onTap: () {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ChantierAnomaliesScreen(chantier: c)),
    );
    },
    ),

    const SizedBox(height: 12),

    _ModuleCard(
    title: "Équipe",
    subtitle: isResponsable
    ? "Affecter / gérer l’équipe sur ce chantier"
        : "Voir l’équipe du chantier",
    icon: Icons.groups,
    onTap: () {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ChantierEquipeScreen(chantierId: c.id!)),
    );
    },
    ),

    const SizedBox(height: 12),

    _ModuleCard(
    title: "Matériel",
    subtitle: isResponsable
    ? "Affecter du matériel existant"
        : "Voir le matériel affecté au chantier",
    icon: Icons.handyman,
    onTap: () {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ChantierMaterielsScreen(chantierId: c.id!)),
    );
    },
    ),

    const SizedBox(height: 12),

    _ModuleCard(
    title: "Véhicules",
    subtitle: isResponsable
    ? "Affecter des véhicules existants"
        : "Voir les véhicules affectés au chantier",
    icon: Icons.local_shipping,
    onTap: () {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ChantierVehiculesScreen(chantierId: c.id!)),
    );
    },
    ),


    // ici tu remets "Détails du chantier", _InfoRow(...), etc.
          const Text(
            'Détails du chantier',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Nb demi-journées',
            value: c.nbDemiJournees?.toString() ?? '—',
          ),
          _InfoRow(
            label: 'Client',
            value: c.contactClientNom ?? '—',
          ),
          _InfoRow(
            label: 'Téléphone client',
            value: c.contactClientTelephone ?? '—',
          ),
          // ... (le reste de tes infos)
          const SizedBox(height: 80),
        ],
      ),
    );
  }

}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}


class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label :',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final StatutChantier? statut;

  const _StatusBadge({required this.statut});

  String _label() {
    switch (statut) {
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

  Color _color() {
    switch (statut) {
      case StatutChantier.EN_COURS:
        return Colors.orange;
      case StatutChantier.TERMINE:
        return Colors.green;
      case StatutChantier.NON_REALISE:
        return Colors.grey;
      case StatutChantier.INTERROMPU:
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        label: Text(_label()),
        backgroundColor: color.withOpacity(0.1),
        side: BorderSide(color: color),
      ),
    );
  }
}

