import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/articles/presentation/screens/journalist_articles_screen.dart';
import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/pages/article_detail/article_detail.dart';
import '../../features/daily_news/presentation/pages/home/daily_news.dart';
import '../../features/daily_news/presentation/pages/saved_article/saved_article.dart';

class AppRoutes {
  static const home = '/';
  static const articleDetails = '/ArticleDetails';
  static const savedArticles = '/SavedArticles';
  static const journalistArticles = '/JournalistArticles';

  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _materialRoute(const DailyNews());
      case articleDetails:
        return _materialRoute(
          ArticleDetailsView(article: settings.arguments as ArticleEntity),
        );
      case savedArticles:
        return _materialRoute(const SavedArticles());
      case journalistArticles:
        return _materialRoute(const JournalistArticlesScreen());
      default:
        return _materialRoute(const DailyNews());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}