import 'package:flutter/material.dart';
import 'package:news_apps/features/data/models/article_model.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استقبال الـ ArticleModel اللي تم إرساله عبر الـ arguments
    final article = ModalRoute.of(context)!.settings.arguments as ArticleModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details News'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image != null && article.image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  article.image!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 220, color: Colors.grey[300]),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              article.title ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              article.subTitle ?? 'لا يوجد تفاصيل إضافية متاحة.',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}