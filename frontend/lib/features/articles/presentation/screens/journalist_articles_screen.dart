import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/articles/presentation/bloc/article_cubit.dart';
import 'package:news_app_clean_architecture/features/articles/presentation/bloc/article_state.dart';
import 'package:news_app_clean_architecture/features/articles/presentation/screens/create_article_screen.dart';
import 'package:news_app_clean_architecture/features/articles/presentation/widgets/article_card.dart';

class JournalistArticlesScreen extends StatefulWidget {
  const JournalistArticlesScreen({Key? key}) : super(key: key);

  @override
  State<JournalistArticlesScreen> createState() =>
      _JournalistArticlesScreenState();
}

class _JournalistArticlesScreenState extends State<JournalistArticlesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ArticleCubit>().loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text(
          'My Articles',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<ArticleCubit>().loadArticles(),
          ),
        ],
      ),
      body: BlocBuilder<ArticleCubit, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
            );
          }

          if (state is ArticleFailure) {
            return _buildErrorState(context, state.message);
          }

          if (state is ArticleSuccess) {
            if (state.articles.isEmpty) {
              return _buildEmptyState(context);
            }
            return RefreshIndicator(
              color: const Color(0xFF6C63FF),
              onRefresh: () => context.read<ArticleCubit>().loadArticles(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.articles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return ArticleCard(article: state.articles[index]);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateArticleScreen()),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          'New Article',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.newspaper, size: 80, color: Color(0xFF6C63FF)),
          const SizedBox(height: 16),
          const Text(
            'No articles yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Be the first to share your story',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateArticleScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Write your first article',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<ArticleCubit>().loadArticles(),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF)),
            child:
                const Text('Try again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
