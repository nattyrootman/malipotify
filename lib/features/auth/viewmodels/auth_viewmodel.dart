import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/providers/user_notifier.dart';
import 'package:myapp/features/auth/models/user_model.dart';
import 'package:myapp/features/auth/repositories/auth_local_repository.dart';
import 'package:myapp/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late UserNotifier _userNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _userNotifier = ref.watch(userNotifierProvider.notifier);
    _checkExistingSession();
    return null;
  }

  Future<void> _checkExistingSession() async {
    try {
      final token = await _authLocalRepository.getToken();
      final localUser = await _authLocalRepository.getUser();

      if (token != null && localUser != null) {
        // First set the local user immediately for faster UI
        _userNotifier.addUser(localUser);
        state = AsyncValue.data(localUser);

        // Then verify with server in background
        final res = await _authRemoteRepository.getcurrentUser(token);
        res.fold(
          (failure) {
            // If server validation fails, clear local data
            _clearSession();
            state = AsyncValue.error(failure.message, StackTrace.current);
          },
          (serverUser) {
            // Update with fresh server data
            _loginSuccess(serverUser);
          },
        );
      }
    } catch (e) {
      print('Error checking existing session: $e');
    }
  }


  Future<void>initSharePref() async{
    await _authLocalRepository.init();
  }

  Future<void> _clearSession() async {
    await _authLocalRepository.clearAuthData();

    _userNotifier.removeUser();
    state = null;
  }


  Future<void> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signUp(
      name: name,
      email: email,
      password: password,
    );

    final resValue = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),

      Right(value: final r) => _loginSuccess(r),
    };
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.login(email, password);

    final resValue = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),

      Right(value: final r) => _loginSuccess(r),
    };
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _authLocalRepository.saveUser(user);
    _userNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getDatatUser() async {
    state = const AsyncValue.loading();

    final token = await _authLocalRepository.getToken();
    final localUser = await _authLocalRepository.getUser();

    if (token != null || localUser != null) {
      final res = await _authRemoteRepository.getcurrentUser(token);
      final resValue = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),

        Right(value: final r) => _getSuccesDataUser(r),
      };

      return resValue.value;
    }

    return null;
  }

  AsyncValue<UserModel> _getSuccesDataUser(UserModel user) {
    _authLocalRepository.getToken();
    _authLocalRepository.getUser();
    _userNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
