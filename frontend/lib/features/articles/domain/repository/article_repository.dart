import 'dart:io';

import '../../../../core/resources/data_state.dart';
import '../entities/article_entity.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getArticles();

  Future<DataState<void>> createArticle({
    required ArticleEntity article,
    File? thumbnailFile,
  });
}
