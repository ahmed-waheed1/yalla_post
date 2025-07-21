import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/post.dart';

class FavoriteService {
  static const String _favoritesKey = 'favorite_posts';

  static Future<List<Post>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson != null) {
        final List<dynamic> favoritesList = json.decode(favoritesJson);
        return favoritesList.map((json) => Post.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> saveFavorites(List<Post> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(
        favorites.map((post) => post.toJson()).toList(),
      );
      return await prefs.setString(_favoritesKey, favoritesJson);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addFavorite(Post post) async {
    final favorites = await getFavorites();
    if (!favorites.any((p) => p.id == post.id)) {
      favorites.add(post);
      return await saveFavorites(favorites);
    }
    return true;
  }

  static Future<bool> removeFavorite(Post post) async {
    final favorites = await getFavorites();
    favorites.removeWhere((p) => p.id == post.id);
    return await saveFavorites(favorites);
  }

  static Future<bool> isFavorite(Post post) async {
    final favorites = await getFavorites();
    return favorites.any((p) => p.id == post.id);
  }
}
