import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app_clean_architecture/features/articles/domain/entities/article_entity.dart';

class ArticleCard extends StatelessWidget {
  final ArticleEntity article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThumbnail(),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryBadge(),
                const SizedBox(height: 8),
                Text(
                  article.title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  article.description ?? '',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 13, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    final url = article.thumbnailURL ?? '';
    if (url.isEmpty) {
      return Container(
        height: 160,
        color: const Color(0xFF0F3460),
        child: const Center(
          child: Icon(Icons.newspaper, color: Color(0xFF6C63FF), size: 48),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: 160,
        color: const Color(0xFF0F3460),
        child: const Center(
            child: CircularProgressIndicator(color: Color(0xFF6C63FF))),
      ),
      errorWidget: (_, __, ___) => Container(
        height: 160,
        color: const Color(0xFF0F3460),
        child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white38, size: 48)),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.4)),
      ),
      child: Text(
        article.category ?? '',
        style: const TextStyle(
            color: Color(0xFF6C63FF),
            fontSize: 11,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildFooter() {
    final date = _formatDate(article.publishedAt);
    return Row(
      children: [
        const Icon(Icons.person_outline, color: Colors.white38, size: 14),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            article.author ?? '',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(Icons.schedule, color: Colors.white38, size: 14),
        const SizedBox(width: 4),
        Text(date, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      return DateFormat('MMM d, yyyy').format(DateTime.parse(isoDate));
    } catch (_) {
      return '';
    }
  }
}
