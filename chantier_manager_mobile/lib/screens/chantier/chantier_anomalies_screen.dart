import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/chantier.dart';
import '../../models/anomalie.dart';
import '../../state/chantier_provider.dart';
import 'AnomalieDetailScreen.dart';

class ChantierAnomaliesScreen extends StatefulWidget {
  final Chantier chantier;

  const ChantierAnomaliesScreen({super.key, required this.chantier});

  @override
  State<ChantierAnomaliesScreen> createState() =>
      _ChantierAnomaliesScreenState();
}

class _ChantierAnomaliesScreenState extends State<ChantierAnomaliesScreen> {
  late Future<List<Anomalie>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = context
        .read<ChantierProvider>()
        .getAnomalies(widget.chantier.id!);
    setState(() {});
  }

  Future<void> _openCreateDialog() async {
    final controller = TextEditingController();

    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Nouvelle anomalie'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;
                Navigator.of(ctx).pop(text);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      try {
        await context
            .read<ChantierProvider>()
            .createAnomalie(widget.chantier.id!, result);
        _reload();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anomalies du chantier #${widget.chantier.id}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,  // ta création d’anomalie existe déjà
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Anomalie>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final anomalies = snapshot.data ?? [];

          if (anomalies.isEmpty) {
            return const Center(child: Text('Aucune anomalie'));
          }

          return ListView.builder(
            itemCount: anomalies.length,
            itemBuilder: (ctx, i) {
              final a = anomalies[i];
              return ListTile(
                title: Text(a.description ?? ''),
                subtitle: Text('id=${a.id}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: () => _pickAndUploadPhoto(a),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AnomalieDetailScreen(anomalie: a),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadPhoto(Anomalie anomalie) async {
    // 1) Demander la source (caméra ou galerie)
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.of(ctx).pop(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir depuis la galerie'),
                onTap: () {
                  Navigator.of(ctx).pop(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      // l'utilisateur a fermé le sheet sans choisir
      return;
    }

    // 2) Récupérer l'image selon la source choisie
    final image = await _picker.pickImage(
      source: source,
      imageQuality: 60,   // compresser un peu pour éviter les fichiers énormes
      maxWidth: 1280,
    );

    if (image == null) return;

    try {
      await context
          .read<ChantierProvider>()
          .uploadAnomaliePhoto(anomalie.id, image);

      // éventuellement recharger la page
      //_reload();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo uploadée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur upload photo: $e')),
      );
    }
  }



}
