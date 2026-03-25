import 'dart:io';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/articles/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/articles/domain/repository/article_repository.dart';

class CreateArticleParams {
  final ArticleEntity article;
  final File? thumbnailFile;

  const CreateArticleParams({
    required this.article,
    this.thumbnailFile,
  });
}

class CreateArticleUseCase
    implements UseCase<DataState<void>, CreateArticleParams> {
  final ArticleRepository _articleRepository;

  CreateArticleUseCase(this._articleRepository);

  @override
  Future<DataState<void>> call({CreateArticleParams? params}) {
    return _articleRepository.createArticle(
      article: params!.article,
      thumbnailFile: params.thumbnailFile,
    );
  }
}