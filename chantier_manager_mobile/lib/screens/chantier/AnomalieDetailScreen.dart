import 'package:flutter/material.dart';
import '../../models/anomalie.dart';
import '../../config/api_config.dart';




class AnomalieDetailScreen extends StatelessWidget {
  final Anomalie anomalie;

  const AnomalieDetailScreen({super.key, required this.anomalie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Anomalie #${anomalie.id}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Description
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
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    anomalie.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (anomalie.creeLe != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          anomalie.creeLe!
                              .toIso8601String()
                              .substring(0, 16),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Photos
          const Text(
            'Photos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          if (anomalie.photos.isEmpty)
            const Text('Aucune photo pour cette anomalie.')
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: anomalie.photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final url = anomalie.photos[index].url;
                final imgBaseUrl = ApiConfig.hostBaseUrl;
                final fullUrl = "$imgBaseUrl${url.startsWith('/') ? '' : '/'}$url";
                debugPrint("IMG = $fullUrl");

                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: () {
                      // plein écran éventuellement plus tard
                    },
                    child: Image.network(
                      fullUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
