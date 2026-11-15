import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/models/user_profile.dart';
import '../repositories/auth_repository.dart';

/// Управляє станом автентифікації та профілю користувача (лаба №5, завдання 3.1–3.2).
/// Огортає AuthRepository та сповіщає віджети через ChangeNotifier.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  User? _user;
  UserProfile? _profile;
  bool _loading = false;
  String? _error;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<Map<String, dynamic>?>? _profileSubscription;

  AuthProvider(this._repository) {
    final user = _repository.currentUser;
    _user = user;
    if (user != null) {
      _loadProfile(user.uid);
    }
    _listenAuth();
  }

  /// Геттери стану
  User? get user => _user;
  UserProfile? get profile => _profile;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    if (value != null) notifyListeners();
  }

  /// Слухає зміни стану автентифікації Firebase.
  void _listenAuth() {
    _authSubscription = _repository.authStateChanges.listen((user) {
      _user = user;
      _error = null;
      if (user != null) {
        _loadProfile(user.uid);
      } else {
        _profile = null;
        _profileSubscription?.cancel();
        _profileSubscription = null;
      }
      notifyListeners();
    });
  }

  /// Підписка на оновлення профілю користувача у Firestore.
  void _loadProfile(String uid) {
    _profileSubscription?.cancel();
    _profileSubscription = _repository.watchUserProfile(uid).listen((data) {
      if (data != null) {
        _profile = UserProfile(
          uid: uid,
          displayName: (data['displayName'] as String? ?? '').isNotEmpty
              ? data['displayName'] as String
              : (_user?.displayName ?? 'Користувач'),
          email: data['email'] as String? ?? _user?.email,
          phone: data['phone'] as String?,
          photoURL: (data['photoURL'] as String? ?? '').isNotEmpty
              ? data['photoURL'] as String
              : _user?.photoURL,
        );
      } else {
        _profile = UserProfile(
          uid: uid,
          displayName: _user?.displayName ?? 'Користувач',
          email: _user?.email,
          photoURL: _user?.photoURL,
        );
      }
      notifyListeners();
    });
  }

  /// Вхід користувача.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.signIn(email: email, password: password);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Реєстрація нового користувача.
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Вихід із системи.
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _repository.signOut();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Оновлення особистих даних (ім'я, телефон, email).
  Future<void> updateProfile({
    String? displayName,
    String? phone,
    String? email,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      if (_user == null) throw Exception('Користувач не авторизований');
      await _repository.saveProfileData(
        name: displayName ?? _user!.displayName ?? 'Користувач',
        phone: phone ?? '',
        email: email,
      );
      if (displayName != null) {
        await _repository.updateProfile(displayName: displayName);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Оновлення аватара.
  Future<void> updateAvatar(String? photoURL) async {
    _setLoading(true);
    _setError(null);
    try {
      if (_user == null) throw Exception('Користувач не авторизований');
      await _repository.saveProfileAvatar(photoURL);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    super.dispose();
  }
}
