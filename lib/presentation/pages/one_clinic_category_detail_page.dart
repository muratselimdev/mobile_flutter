import 'package:flutter/material.dart';

class OneClinicCategoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> detail;

  const OneClinicCategoryDetailPage({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detail['label'] ?? 'Category Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${detail['id']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Category Item ID: ${detail['categoryItemId']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Label: ${detail['label']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Detail: ${detail['detail']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Image URL: ${detail['imageUrl']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Video URL: ${detail['videoUrl']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Created At: ${detail['createdAt']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Is Active: ${detail['isActive']}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
