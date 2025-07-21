import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/favorites_viewmodel.dart';
import '../widgets/post_card.dart';
import '../widgets/post_search_delegate.dart';

class FavoritePostsPage extends ConsumerWidget {
  const FavoritePostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearchDelegate(posts: favoritesState.favorites),
              );
            },
          ),
          if (favoritesState.favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                _showClearAllDialog(context, ref);
              },
            ),
        ],
      ),
      body: _buildBody(context, ref, favoritesState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    FavoritesState favoritesState,
  ) {
    if (favoritesState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favoritesState.favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorite posts yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart icon on any post to add it to favorites',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: favoritesState.favorites.length,
      itemBuilder: (context, index) {
        final post = favoritesState.favorites[index];
        return PostCard(post: post);
      },
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Favorites'),
          content: const Text(
            'Are you sure you want to remove all posts from favorites? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(favoritesViewModelProvider.notifier)
                    .clearAllFavorites();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All favorites cleared'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}
