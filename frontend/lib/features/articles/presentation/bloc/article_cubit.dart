import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/articles/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/articles/domain/use_cases/create_article.dart' show CreateArticleUseCase, CreateArticleParams;
import 'package:news_app_clean_architecture/features/articles/domain/use_cases/get_articles.dart' show GetArticlesUseCase;
import 'package:uuid/uuid.dart';
import 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final GetArticlesUseCase _getArticlesUseCase;
  final CreateArticleUseCase _createArticleUseCase;

  ArticleCubit(this._getArticlesUseCase, this._createArticleUseCase)
      : super(const ArticleInitial());

  Future<void> loadArticles() async {
    emit(const ArticleLoading());
    final result = await _getArticlesUseCase();
    if (result is DataSuccess) {
      emit(ArticleSuccess(result.data ?? []));
    } else {
      emit(ArticleFailure(result.error?.toString() ?? 'Error loading articles'));
    }
  }

  Future<void> createArticle({
    required String title,
    required String description,
    required String content,
    required String author,
    required String category,
    required String source,
    String url = '',
    File? thumbnailFile,
  }) async {
    emit(const ArticleCreating());

    final article = ArticleEntity(
      id: const Uuid().v4(),
      title: title,
      description: description,
      content: content,
      author: author,
      category: category,
      thumbnailURL: '',
      source: source,
      url: url,
      publishedAt: DateTime.now().toIso8601String(),
    );

    final result = await _createArticleUseCase(
      params: CreateArticleParams(article: article, thumbnailFile: thumbnailFile),
    );

    if (result is DataSuccess) {
      emit(const ArticleCreated());
      await loadArticles(); // refresca la lista después de crear
    } else {
      emit(ArticleCreateFailure(result.error?.toString() ?? 'Error creating article'));
    }
  }
}