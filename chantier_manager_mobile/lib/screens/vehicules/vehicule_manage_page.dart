import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vehicule.dart';
import '../../state/vehicule_provider.dart';

class VehiculeManagePage extends StatefulWidget {
  final Vehicule? existing;
  const VehiculeManagePage({super.key, this.existing});

  @override
  State<VehiculeManagePage> createState() => _VehiculeManagePageState();
}

class _VehiculeManagePageState extends State<VehiculeManagePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _immat;
  late final TextEditingController _type;
  late final TextEditingController _libelle;
  bool _dispo = true;

  @override
  void initState() {
    super.initState();
    _immat = TextEditingController(text: widget.existing?.immatriculation ?? "");
    _type = TextEditingController(text: widget.existing?.type ?? "");
    _libelle = TextEditingController(text: widget.existing?.libelle ?? "");
    _dispo = widget.existing?.disponible ?? true;
  }

  @override
  void dispose() {
    _immat.dispose();
    _type.dispose();
    _libelle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<VehiculeProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? "Nouveau véhicule" : "Modifier véhicule")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _libelle,
                decoration: const InputDecoration(labelText: "Libellé (optionnel)"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _immat,
                decoration: const InputDecoration(labelText: "Immatriculation (optionnel)"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _type,
                decoration: const InputDecoration(labelText: "Type (optionnel)"),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text("Disponible"),
                value: _dispo,
                onChanged: (v) => setState(() => _dispo = v),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: p.loading ? null : () async {
                    if (!_formKey.currentState!.validate()) return;

                    final immat = _immat.text.trim().isEmpty ? null : _immat.text.trim();
                    final type = _type.text.trim().isEmpty ? null : _type.text.trim();
                    final libelle = _libelle.text.trim().isEmpty ? null : _libelle.text.trim();

                    if (widget.existing == null) {
                      await context.read<VehiculeProvider>().create(immat, type, libelle, _dispo);
                    } else {
                      await context.read<VehiculeProvider>().update(widget.existing!.id, immat, type, libelle, _dispo);
                    }
                    if (mounted) Navigator.pop(context);
                  },
                  child: p.loading ? const CircularProgressIndicator() : const Text("Enregistrer"),
                ),
              ),
              if (p.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(p.error!, style: const TextStyle(color: Colors.red)),
                )
            ],
          ),
        ),
      ),
    );
  }
}
