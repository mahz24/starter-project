import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/articles/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    String? id,
    String? title,
    String? description,
    String? content,
    String? author,
    String? category,
    String? thumbnailURL,
    String? source,
    String? url,
    String? publishedAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          content: content,
          author: author,
          category: category,
          thumbnailURL: thumbnailURL,
          source: source,
          url: url,
          publishedAt: publishedAt,
        );

  factory ArticleModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return ArticleModel(
      id: snap.id,
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      content: data['content']?.toString() ?? '',
      author: data['author']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      thumbnailURL: data['thumbnailURL']?.toString() ?? '',
      source: data['source']?.toString() ?? '',
      url: data['url']?.toString() ?? '',
      publishedAt: data['publishedAt'] is Timestamp
          ? (data['publishedAt'] as Timestamp).toDate().toIso8601String()
          : data['publishedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'title': title ?? '',
      'description': description ?? '',
      'content': content ?? '',
      'author': author ?? '',
      'category': category ?? '',
      'thumbnailURL': thumbnailURL ?? '',
      'source': source ?? '',
      'url': url ?? '',
      'publishedAt': Timestamp.fromDate(
        DateTime.tryParse(publishedAt ?? '') ?? DateTime.now(),
      ),
    };
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      content: entity.content,
      author: entity.author,
      category: entity.category,
      thumbnailURL: entity.thumbnailURL,
      source: entity.source,
      url: entity.url,
      publishedAt: entity.publishedAt,
    );
  }
}
