import 'dart:io';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/articles/data/data_sources/remote/article_firebase_data_source.dart';
import 'package:news_app_clean_architecture/features/articles/data/models/article_model.dart';
import 'package:news_app_clean_architecture/features/articles/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/articles/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleFirebaseDataSource _dataSource;

  ArticleRepositoryImpl(this._dataSource);

  @override
  Future<DataState<List<ArticleEntity>>> getArticles() async {
    try {
      final articles = await _dataSource.getArticles();
      return DataSuccess(articles);
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }

  @override
  Future<DataState<void>> createArticle({
    required ArticleEntity article,
    File? thumbnailFile,
  }) async {
    try {
      await _dataSource.createArticle(
        ArticleModel.fromEntity(article),
        thumbnailFile,
      );
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }
}
