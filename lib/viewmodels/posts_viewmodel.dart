import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../services/post_service.dart';

enum PostsLoadingState { initial, loading, loaded, error }

class PostsState {
  final List<Post> posts;
  final PostsLoadingState loadingState;
  final String? errorMessage;

  const PostsState({
    this.posts = const [],
    this.loadingState = PostsLoadingState.initial,
    this.errorMessage,
  });

  PostsState copyWith({
    List<Post>? posts,
    PostsLoadingState? loadingState,
    String? errorMessage,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PostsViewModel extends StateNotifier<PostsState> {
  PostsViewModel() : super(const PostsState());

  Future<void> loadPosts() async {
    state = state.copyWith(loadingState: PostsLoadingState.loading);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final posts = await PostService.fetchPosts();
      state = state.copyWith(
        posts: posts,
        loadingState: PostsLoadingState.loaded,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: PostsLoadingState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshPosts() async {
    await loadPosts();
  }

  List<Post> searchPosts(String query) {
    if (query.isEmpty) return state.posts;

    return state.posts
        .where(
          (post) =>
              post.title.toLowerCase().contains(query.toLowerCase()) ||
              post.body.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Post? getPostById(int id) {
    try {
      return state.posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }
}

final postsViewModelProvider =
    StateNotifierProvider<PostsViewModel, PostsState>((ref) {
      final viewModel = PostsViewModel();
      Future.microtask(() => viewModel.loadPosts());
      return viewModel;
    });
