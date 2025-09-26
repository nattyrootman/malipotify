

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/models/user_model.dart';

part 'user_notifier.g.dart';

@Riverpod()
class UserNotifier extends _$UserNotifier {
  @override
  UserModel? build() {
    return null;
  }

  void addUser(UserModel user) {
    state = user;
  }

  void removeUser() {
    state = null;
  }
}
