import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ??
          GoogleSignIn(
            serverClientId:
                '198956360446-6g58p1kgqho36lm2laup9lebhlscff8p.apps.googleusercontent.com',
          );

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

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

  // Вхід через Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Закрити поточний сеанс Google, щоб завжди з'являлася панель вибору акаунту
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Скасовано користувачем

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(_translateAuthError(e.code));
    } catch (e) {
      throw Exception('Не вдалося увійти через Google: $e');
    }
  }

  // Скидання пароля — лист містить посилання, яке відкриє саме додаток
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final actionCodeSettings = ActionCodeSettings(
        url: 'fishlog://reset-password',
        handleCodeInApp: true,
        androidPackageName: 'com.example.fishlog',
        androidInstallApp: false,
      );
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
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
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
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
