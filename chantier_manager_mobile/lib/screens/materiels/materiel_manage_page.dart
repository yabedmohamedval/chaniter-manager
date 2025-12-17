import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/materiel.dart';
import '../../state/materiel_provider.dart';

class MaterielManagePage extends StatefulWidget {
  final Materiel? existing;
  const MaterielManagePage({super.key, this.existing});

  @override
  State<MaterielManagePage> createState() => _MaterielManagePageState();
}

class _MaterielManagePageState extends State<MaterielManagePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _libelle;
  late final TextEditingController _type;
  late final TextEditingController _qte;

  @override
  void initState() {
    super.initState();
    _libelle = TextEditingController(text: widget.existing?.libelle ?? "");
    _type = TextEditingController(text: widget.existing?.type ?? "");
    _qte = TextEditingController(text: (widget.existing?.quantiteTotale ?? 0).toString());
  }

  @override
  void dispose() {
    _libelle.dispose();
    _type.dispose();
    _qte.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MaterielProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? "Nouveau matériel" : "Modifier matériel")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _libelle,
                decoration: const InputDecoration(labelText: "Libellé"),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Champ requis" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _type,
                decoration: const InputDecoration(labelText: "Type (optionnel)"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _qte,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quantité totale"),
                validator: (v) {
                  final n = int.tryParse(v ?? "");
                  if (n == null || n < 0) return "Quantité invalide";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: p.loading ? null : () async {
                    if (!_formKey.currentState!.validate()) return;

                    final libelle = _libelle.text.trim();
                    final type = _type.text.trim().isEmpty ? null : _type.text.trim();
                    final qte = int.parse(_qte.text.trim());

                    if (widget.existing == null) {
                      await context.read<MaterielProvider>().create(libelle, type, qte);
                    } else {
                      await context.read<MaterielProvider>().update(widget.existing!.id, libelle, type, qte);
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
