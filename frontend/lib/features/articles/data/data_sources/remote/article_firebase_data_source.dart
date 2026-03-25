import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app_clean_architecture/features/articles/data/models/article_model.dart';

abstract class ArticleFirebaseDataSource {
  Future<List<ArticleModel>> getArticles();
  Future<void> createArticle(ArticleModel article, File? thumbnailFile);
}

class ArticleFirebaseDataSourceImpl implements ArticleFirebaseDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ArticleFirebaseDataSourceImpl(this._firestore, this._storage);

  @override
  Future<List<ArticleModel>> getArticles() async {
    final snapshot = await _firestore
        .collection('articles')
        .orderBy('publishedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => ArticleModel.fromSnapshot(doc)).toList();
  }

  @override
  Future<void> createArticle(ArticleModel article, File? thumbnailFile) async {
    String thumbnailURL = article.thumbnailURL ?? '';

    if (thumbnailFile != null) {
      final fileName = '${article.id}_${DateTime.now().millisecondsSinceEpoch}';
      final ref = _storage.ref().child('media/articles/$fileName');
      await ref.putFile(thumbnailFile);
      thumbnailURL = await ref.getDownloadURL();
    }

    final articleWithThumbnail = ArticleModel(
      id: article.id,
      title: article.title,
      description: article.description,
      content: article.content,
      author: article.author,
      category: article.category,
      thumbnailURL: thumbnailURL,
      source: article.source,
      url: article.url,
      publishedAt: article.publishedAt,
    );

    await _firestore
        .collection('articles')
        .doc(article.id)
        .set(articleWithThumbnail.toJson());
  }
}
