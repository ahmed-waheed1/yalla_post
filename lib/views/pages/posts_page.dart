import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/posts_viewmodel.dart';
import '../widgets/post_card.dart';
import '../widgets/post_search_delegate.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (postsState.loadingState == PostsLoadingState.loaded) {
                showSearch(
                  context: context,
                  delegate: PostSearchDelegate(posts: postsState.posts),
                );
              }
            },
          ),
        ],
      ),
      body: _buildBody(context, ref, postsState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    PostsState postsState,
  ) {
    switch (postsState.loadingState) {
      case PostsLoadingState.initial:
      case PostsLoadingState.loading:
        return const Center(child: CircularProgressIndicator());

      case PostsLoadingState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${postsState.errorMessage}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(postsViewModelProvider.notifier).refreshPosts();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case PostsLoadingState.loaded:
        if (postsState.posts.isEmpty) {
          return const Center(
            child: Text('No posts available', style: TextStyle(fontSize: 18)),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(postsViewModelProvider.notifier).refreshPosts();
          },
          child: ListView.builder(
            itemCount: postsState.posts.length,
            itemBuilder: (context, index) {
              final post = postsState.posts[index];
              return PostCard(post: post);
            },
          ),
        );
    }
  }
}
