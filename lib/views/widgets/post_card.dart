import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/post.dart';
import '../../viewmodels/favorites_viewmodel.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesViewModel = ref.read(favoritesViewModelProvider.notifier);
    final isFavorite = ref.watch(
      favoritesViewModelProvider.select(
        (state) => state.favorites.any((p) => p.id == post.id),
      ),
    );

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => favoritesViewModel.toggleFavorite(post),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
