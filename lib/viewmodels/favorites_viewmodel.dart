import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../services/favorite_service.dart';

class FavoritesState {
  final List<Post> favorites;
  final bool isLoading;
  final String? errorMessage;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FavoritesState copyWith({
    List<Post>? favorites,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class FavoritesViewModel extends StateNotifier<FavoritesState> {
  FavoritesViewModel() : super(const FavoritesState()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    state = state.copyWith(isLoading: true);

    try {
      final favorites = await FavoriteService.getFavorites();
      state = state.copyWith(
        favorites: favorites,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addFavorite(Post post) async {
    if (isFavorite(post)) return;

    state = state.copyWith(favorites: [...state.favorites, post]);

    try {
      await FavoriteService.addFavorite(post);
    } catch (e) {
      state = state.copyWith(
        favorites: state.favorites.where((p) => p.id != post.id).toList(),
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> removeFavorite(Post post) async {
    final previousFavorites = state.favorites;

    state = state.copyWith(
      favorites: state.favorites.where((p) => p.id != post.id).toList(),
    );

    try {
      await FavoriteService.removeFavorite(post);
    } catch (e) {
      state = state.copyWith(
        favorites: previousFavorites,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> toggleFavorite(Post post) async {
    if (isFavorite(post)) {
      await removeFavorite(post);
    } else {
      await addFavorite(post);
    }
  }

  bool isFavorite(Post post) {
    return state.favorites.any((p) => p.id == post.id);
  }

  List<Post> searchFavorites(String query) {
    if (query.isEmpty) return state.favorites;

    return state.favorites
        .where(
          (post) =>
              post.title.toLowerCase().contains(query.toLowerCase()) ||
              post.body.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Future<void> clearAllFavorites() async {
    final previousFavorites = state.favorites;

    state = state.copyWith(favorites: []);

    try {
      await FavoriteService.saveFavorites([]);
    } catch (e) {
      state = state.copyWith(
        favorites: previousFavorites,
        errorMessage: e.toString(),
      );
    }
  }
}

final favoritesViewModelProvider =
    StateNotifierProvider<FavoritesViewModel, FavoritesState>((ref) {
      return FavoritesViewModel();
    });
