import 'package:flutter/material.dart';
import 'package:news_apps/features/data/models/article_model.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is! ArticleModel) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Details News'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('بيانات الخبر غير متاحة'),
        ),
      );
    }

    final article = arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details News'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image != null &&
                article.image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article.image!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              article.title ?? 'بدون عنوان',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              article.subTitle?.isNotEmpty == true
                  ? article.subTitle!
                  : 'لا توجد تفاصيل إضافية متاحة.',
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