import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? content;
  final String? author;
  final String? category;
  final String? thumbnailURL;
  final String? source;
  final String? url;
  final String? publishedAt;

  const ArticleEntity({
    this.id,
    this.title,
    this.description,
    this.content,
    this.author,
    this.category,
    this.thumbnailURL,
    this.source,
    this.url,
    this.publishedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        author,
        category,
        thumbnailURL,
        source,
        url,
        publishedAt,
      ];
}
