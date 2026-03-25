import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// daily_news — existente
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';

// articles — nuevo feature
import 'package:news_app_clean_architecture/features/articles/data/data_sources/remote/article_firebase_data_source.dart';
import 'package:news_app_clean_architecture/features/articles/data/repository/article_repository_impl.dart'
    as firebase_repo;
import 'package:news_app_clean_architecture/features/articles/domain/repository/article_repository.dart'
    as firebase_article_repo;
import 'package:news_app_clean_architecture/features/articles/domain/use_cases/get_articles.dart';
import 'package:news_app_clean_architecture/features/articles/domain/use_cases/create_article.dart';
import 'package:news_app_clean_architecture/features/articles/presentation/bloc/article_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ── Base de datos local (daily_news) ──────────────────────
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  // ── Dio (daily_news) ──────────────────────────────────────
  sl.registerSingleton<Dio>(Dio());

  // ── daily_news dependencies ───────────────────────────────
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));
  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl(), sl()),
  );
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerSingleton<GetSavedArticleUseCase>(GetSavedArticleUseCase(sl()));
  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));
  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));
  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc(sl()));
  sl.registerFactory<LocalArticleBloc>(
    () => LocalArticleBloc(sl(), sl(), sl()),
  );

  // ── Firebase (articles) ───────────────────────────────────
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);

  sl.registerSingleton<ArticleFirebaseDataSource>(
    ArticleFirebaseDataSourceImpl(sl(), sl()),
  );
  sl.registerSingleton<firebase_article_repo.ArticleRepository>(
    firebase_repo.ArticleRepositoryImpl(sl()),
  );
  sl.registerSingleton<GetArticlesUseCase>(
    GetArticlesUseCase(sl<firebase_article_repo.ArticleRepository>()),
  );
  sl.registerSingleton<CreateArticleUseCase>(
    CreateArticleUseCase(sl<firebase_article_repo.ArticleRepository>()),
  );
  sl.registerFactory<ArticleCubit>(
    () => ArticleCubit(sl(), sl()),
  );
}
