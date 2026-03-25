import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/features/articles/domain/entities/article_entity.dart';

abstract class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object?> get props => [];
}

class ArticleInitial extends ArticleState {
  const ArticleInitial();
}

class ArticleLoading extends ArticleState {
  const ArticleLoading();
}

class ArticleSuccess extends ArticleState {
  final List<ArticleEntity> articles;
  const ArticleSuccess(this.articles);

  @override
  List<Object?> get props => [articles];
}

class ArticleFailure extends ArticleState {
  final String message;
  const ArticleFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ArticleCreating extends ArticleState {
  const ArticleCreating();
}

class ArticleCreated extends ArticleState {
  const ArticleCreated();
}

class ArticleCreateFailure extends ArticleState {
  final String message;
  const ArticleCreateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
