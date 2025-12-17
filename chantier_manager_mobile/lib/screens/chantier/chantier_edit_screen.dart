import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chantier.dart';
import '../../models/enums.dart';
import '../../state/chantier_provider.dart';

class ChantierEditScreen extends StatefulWidget {
  final Chantier chantier;

  const ChantierEditScreen({super.key, required this.chantier});

  @override
  State<ChantierEditScreen> createState() => _ChantierEditScreenState();
}

class _ChantierEditScreenState extends State<ChantierEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _objetController;
  late TextEditingController _lieuController;
  late TextEditingController _nbDemiJourneesController;
  late TextEditingController _clientNomController;
  late TextEditingController _clientTelController;
  StatutChantier? _statut;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.chantier;
    _objetController = TextEditingController(text: c.objet);
    _lieuController = TextEditingController(text: c.lieu ?? '');
    _nbDemiJourneesController =
        TextEditingController(text: c.nbDemiJournees?.toString() ?? '');
    _clientNomController =
        TextEditingController(text: c.contactClientNom ?? '');
    _clientTelController =
        TextEditingController(text: c.contactClientTelephone ?? '');
    _statut = c.statut ?? StatutChantier.EN_COURS;
  }

  @override
  void dispose() {
    _objetController.dispose();
    _lieuController.dispose();
    _nbDemiJourneesController.dispose();
    _clientNomController.dispose();
    _clientTelController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final int? nbDemi;
    if (_nbDemiJourneesController.text.trim().isEmpty) {
      nbDemi = null;
    } else {
      nbDemi = int.tryParse(_nbDemiJourneesController.text.trim());
    }

    final updated = Chantier(
      id: widget.chantier.id,
      objet: _objetController.text.trim(),
      lieu: _lieuController.text.trim().isEmpty
          ? null
          : _lieuController.text.trim(),
      nbDemiJournees: nbDemi,
      dateDebut: widget.chantier.dateDebut,
      contactClientNom: _clientNomController.text.trim().isEmpty
          ? null
          : _clientNomController.text.trim(),
      contactClientTelephone: _clientTelController.text.trim().isEmpty
          ? null
          : _clientTelController.text.trim(),
      statut: _statut,
      chefId: widget.chantier.chefId,
      chef: widget.chantier.chef,
      equipeId: widget.chantier.equipeId,
    );

    try {
      await context.read<ChantierProvider>().updateChantier(updated);

      if (mounted) {
        Navigator.of(context).pop(updated);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sauvegarde : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le chantier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _objetController,
                decoration: const InputDecoration(
                  labelText: 'Objet',
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Obligatoire'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lieuController,
                decoration: const InputDecoration(
                  labelText: 'Lieu',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nbDemiJourneesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nombre de demi-journées',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientNomController,
                decoration: const InputDecoration(
                  labelText: 'Nom du client',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientTelController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone du client',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<StatutChantier>(
                value: _statut,
                items: StatutChantier.values
                    .map(
                      (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.name),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() => _statut = value);
                },
                decoration: const InputDecoration(
                  labelText: 'Statut',
                ),
              ),
              const SizedBox(height: 24),
              _saving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Sauvegarder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
