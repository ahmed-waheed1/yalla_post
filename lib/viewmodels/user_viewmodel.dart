import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class UserState {
  final User user;
  final bool isLoading;
  final String? errorMessage;

  const UserState({
    this.user = const User(
      name: 'Ahmed Waheed',
      title: 'Flutter Developer',
      imageUrl: 'https://randomuser.me/api/portraits/lego/7.jpg',
    ),
    this.isLoading = false,
    this.errorMessage,
  });

  UserState copyWith({User? user, bool? isLoading, String? errorMessage}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class UserViewModel extends StateNotifier<UserState> {
  UserViewModel() : super(const UserState());

  void updateUser(User user) {
    state = state.copyWith(user: user);
  }

  void updateUserName(String name) {
    final updatedUser = User(
      name: name,
      title: state.user.title,
      imageUrl: state.user.imageUrl,
    );
    state = state.copyWith(user: updatedUser);
  }

  void updateUserTitle(String title) {
    final updatedUser = User(
      name: state.user.name,
      title: title,
      imageUrl: state.user.imageUrl,
    );
    state = state.copyWith(user: updatedUser);
  }

  void updateUserImage(String imageUrl) {
    final updatedUser = User(
      name: state.user.name,
      title: state.user.title,
      imageUrl: imageUrl,
    );
    state = state.copyWith(user: updatedUser);
  }
}

final userViewModelProvider = StateNotifierProvider<UserViewModel, UserState>((
  ref,
) {
  return UserViewModel();
});
