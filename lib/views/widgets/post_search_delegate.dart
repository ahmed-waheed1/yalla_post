import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/post.dart';
import 'post_card.dart';

class PostSearchDelegate extends SearchDelegate<Post?> {
  final List<Post> posts;

  PostSearchDelegate({required this.posts});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredPosts = posts
        .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Consumer(
      builder: (context, ref, child) {
        return ListView.builder(
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) {
            final post = filteredPosts[index];
            return PostCard(post: post, onTap: () => close(context, post));
          },
        );
      },
    );
  }
}
