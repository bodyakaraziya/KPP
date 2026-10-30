import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  bool get usesPasswordProvider =>
      currentUser?.providerData.any(
        (provider) => provider.providerId == 'password',
      ) ??
      false;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  CollectionReference<Map<String, dynamic>> get _userProfiles =>
      FirebaseFirestore.instance.collection('users');

  Stream<Map<String, dynamic>?> watchUserProfile(String uid) =>
      _userProfiles.doc(uid).snapshots().map((snapshot) => snapshot.data());

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snapshot = await _userProfiles.doc(uid).get();
    return snapshot.data();
  }

  Future<void> saveProfileData({
    required String name,
    required String phone,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('Користувача не знайдено');

    await user.updateDisplayName(name);
    await _userProfiles.doc(user.uid).set({
      'displayName': name,
      'phone': phone,
    }, SetOptions(merge: true));
  }

  Future<void> saveProfileAvatar(String? photoURL) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('Користувача не знайдено');

    await user.updatePhotoURL(photoURL);
    await _userProfiles.doc(user.uid).set({
      'photoURL': photoURL,
    }, SetOptions(merge: true));
  }

  Future<String?> ensureProfileName(String? fallbackName) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final document = _userProfiles.doc(user.uid);
    final snapshot = await document.get();
    final storedName = snapshot.data()?['displayName'];
    if (storedName is String && storedName.trim().isNotEmpty) {
      return storedName.trim();
    }

    final name = (fallbackName ?? user.displayName ?? '').trim();
    if (name.isEmpty) return null;

    await document.set({'displayName': name}, SetOptions(merge: true));
    return name;
  }

  Future<String?> reloadCurrentUserEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    await user.reload();
    return _firebaseAuth.currentUser?.email;
  }

  // Реєстрація через Email та Пароль
  Future<UserCredential> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (displayName != null && displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_translateAuthError(e.code));
    }
  }

  // Вхід через Email та Пароль
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_translateAuthError(e.code));
    }
  }

  // Скидання пароля — лист містить посилання на стандартну сторінку Firebase
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_translateAuthError(e.code));
    }
  }

  // Підтвердження скидання паролю за кодом із листа
  Future<void> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
        code: oobCode,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_translateAuthError(e.code));
    }
  }

  // Оновлення профілю (ім'я / аватар)
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('Користувача не знайдено');

      if (displayName != null) await user.updateDisplayName(displayName);
      if (photoURL != null) await user.updatePhotoURL(photoURL);
    } on FirebaseAuthException catch (e) {
      throw Exception(_translateAuthError(e.code));
    }
  }

  // Надсилає підтвердження після повторної автентифікації.
  Future<void> updateEmail({required String newEmail}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('Користувача не знайдено');

      await user.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw Exception(_translateAuthError(e.code));
    }
  }

  // Зміна пароля з повторною автентифікацією
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('Користувач не авторизований');
      }

      // Повторна автентифікація перед зміною
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(_translateAuthError(e.code));
    }
  }

  // Вихід із системи
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Переклад помилок Firebase Auth
  String _translateAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Користувача з такою електронною поштою не знайдено.';
      case 'wrong-password':
        return 'Невірний пароль. Спробуйте ще раз.';
      case 'email-already-in-use':
        return 'Обліковий запис із цією поштою вже існує.';
      case 'invalid-email':
        return 'Некоректний формат електронної пошти.';
      case 'weak-password':
        return 'Пароль занадто простий. Використайте щонайменше 8 символів.';
      case 'requires-recent-login':
        return 'Для виконання цієї операції потрібно повторно увійти в акаунт.';
      case 'user-disabled':
        return 'Цей обліковий запис було заблоковано.';
      case 'too-many-requests':
        return 'Забагато невдалих спроб. Зачекайте декілька хвилин.';
      case 'invalid-credential':
        return 'Неправильний Email або пароль.';
      case 'account-exists-with-different-credential':
        return 'Обліковий запис вже існує з іншим методом входу.';
      case 'credential-already-in-use':
        return 'Ці облікові дані вже використовуються.';
      case 'operation-not-allowed':
        return 'Цей метод входу не дозволений.';
      case 'invalid-verification-code':
        return 'Невірний код підтвердження.';
      case 'invalid-verification-id':
        return 'Некоректний ідентифікатор підтвердження.';
      case 'network-request-failed':
        return 'Помилка мережі. Перевірте підключення до інтернету.';
      default:
        return 'Сталася помилка автентифікації. Спробуйте пізніше.';
    }
  }
}
