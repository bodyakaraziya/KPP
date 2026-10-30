import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../../tackle/screens/tackle_screen.dart';
import '../widgets/app_settings_card.dart';
import '../widgets/forgot_password_bottom_sheet.dart';
import '../widgets/personal_data_card.dart';
import '../widgets/password_card.dart';
import '../widgets/photo_picker_dialog.dart';
import '../widgets/profile_header.dart';
import '../widgets/user_summary_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepository = AuthRepository();

  StreamSubscription<User?>? _authSubscription;

  // Поточні дані користувача з Firebase Auth
  String _firstName = '';
  String _email = '';
  String _phone = '';
  String? _avatarUrl;

  // Прапорці інтерфейсу
  bool _isPersonalExpanded = false;
  bool _isEditingPersonal = false;
  bool _isPasswordFormOpen = false;
  bool _isDarkTheme = false;
  String _selectedLang = 'УКР';
  bool _isMenuOpen = false;

  // Контролери
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _currentPasswordCtrl;
  late final TextEditingController _newPasswordCtrl;
  late final TextEditingController _confirmPasswordCtrl;

  @override
  void initState() {
    super.initState();
    _syncUser(_authRepository.currentUser);
    _firstNameCtrl = TextEditingController(text: _firstName);
    _emailCtrl = TextEditingController(text: _email);
    _phoneCtrl = TextEditingController(text: _phone);
    _currentPasswordCtrl = TextEditingController();
    _newPasswordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();

    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (!mounted) return;
      _syncUser(user);
      _firstNameCtrl.text = _firstName;
      _emailCtrl.text = _email;
      _phoneCtrl.text = _phone;
    });
  }

  void _syncUser(User? user) {
    _firstName = (user?.displayName ?? '').trim().isNotEmpty
        ? user!.displayName!
        : 'Користувач';
    _email = user?.email ?? '';
    _avatarUrl = user?.photoURL;
  }

  String get _initial =>
      _firstName.isNotEmpty ? _firstName[0].toUpperCase() : 'А';

  @override
  void dispose() {
    _authSubscription?.cancel();
    _firstNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  // --- Особисті дані ---
  Future<void> _savePersonalData() async {
    final name = _firstNameCtrl.text.trim();
    if (name.isEmpty) {
      showAppSnackBar(
        context,
        title: 'Помилка',
        message: 'Будь ласка, введіть ім\'я',
        isError: true,
      );
      return;
    }

    // Телефон опціональний, але якщо введено — має бути валідним.
    final phoneText = _phoneCtrl.text.trim();
    String? phoneToSave;
    if (phoneText.isNotEmpty && phoneText != '+380 ') {
      final digits = phoneText.replaceAll(RegExp(r'\D'), '');
      String number = digits;
      if (number.startsWith('380')) {
        number = number.substring(3);
      }
      if (number.isEmpty || number.length != 9) {
        showAppSnackBar(
          context,
          title: 'Помилка',
          message:
              'Номер телефону має містити 9 цифр після коду +380.',
          isError: true,
        );
        return;
      }
      phoneToSave = phoneText;
    }

    try {
      await _authRepository.updateProfile(displayName: name);
      if (!mounted) return;
      setState(() {
        _firstName = name;
        _email = _emailCtrl.text.trim();
        _phone = phoneToSave ?? '';
        _isEditingPersonal = false;
      });
      showAppSnackBar(
        context,
        message: 'Особисті дані оновлено!',
        isError: false,
      );
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        title: 'Помилка',
        message: authErrorMessage(e),
        isError: true,
      );
    }
  }

  // --- Пароль ---
  Future<void> _changePassword() async {
    final current = _currentPasswordCtrl.text.trim();
    final newPassword = _newPasswordCtrl.text.trim();
    final confirm = _confirmPasswordCtrl.text.trim();

    if (current.isEmpty || newPassword.isEmpty || confirm.isEmpty) {
      showAppSnackBar(
        context,
        title: 'Помилка',
        message: 'Будь ласка, заповніть всі поля',
        isError: true,
      );
      return;
    }

    if (newPassword.length < 8) {
      showAppSnackBar(
        context,
        title: 'Помилка',
        message: 'Новий пароль має містити щонайменше 8 символів',
        isError: true,
      );
      return;
    }

    if (newPassword != confirm) {
      showAppSnackBar(
        context,
        title: 'Помилка',
        message: 'Паролі не збігаються',
        isError: true,
      );
      return;
    }

    try {
      await _authRepository.updatePassword(
        currentPassword: current,
        newPassword: newPassword,
      );
      if (!mounted) return;
      _currentPasswordCtrl.clear();
      _newPasswordCtrl.clear();
      _confirmPasswordCtrl.clear();
      setState(() => _isPasswordFormOpen = false);
      showAppSnackBar(
        context,
        message: 'Пароль успішно оновлено!',
        isError: false,
      );
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        title: 'Помилка',
        message: authErrorMessage(e),
        isError: true,
      );
    }
  }

  // --- Вихід ---
  Future<void> _signOut() async {
    await _authRepository.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authRepository.currentUser;
    final hasPassword = user?.email != null;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          stops: [0.0, 0.3],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Основний контент
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: ProfileHeader(
                    onMenuTap: () => setState(() => _isMenuOpen = !_isMenuOpen),
                    isMenuOpen: _isMenuOpen,
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollStartNotification>(
                    onNotification: (_) {
                      if (_isMenuOpen) {
                        setState(() => _isMenuOpen = false);
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserSummaryCard(
                            name: _firstName,
                            avatarUrl: _avatarUrl,
                            initial: _initial,
                            onAvatarTap: () => _showPickPhotoDialog(),
                          ),
                          const SizedBox(height: 14),
                          PersonalDataCard(
                            name: _firstName,
                            email: _email,
                            phone: _phone,
                            isExpanded: _isPersonalExpanded,
                            isEditing: _isEditingPersonal,
                            onExpandToggle: () {
                              setState(() {
                                _isPersonalExpanded = !_isPersonalExpanded;
                                if (!_isPersonalExpanded) {
                                  _isEditingPersonal = false;
                                }
                              });
                            },
                            onEditTap: () {
                              setState(() {
                                _firstNameCtrl.text = _firstName;
                                _emailCtrl.text = _email;
                                _phoneCtrl.text =
                                    _phone.isEmpty ? '+380 ' : _phone;
                                _isEditingPersonal = true;
                              });
                            },
                            onSave: _savePersonalData,
                            onCancel: () =>
                                setState(() => _isEditingPersonal = false),
                            firstNameCtrl: _firstNameCtrl,
                            emailCtrl: _emailCtrl,
                            phoneCtrl: _phoneCtrl,
                          ),
                          const SizedBox(height: 14),
                          AppSettingsCard(
                            isDarkTheme: _isDarkTheme,
                            selectedLang: _selectedLang,
                            onThemeLight: () =>
                                setState(() => _isDarkTheme = false),
                            onThemeDark: () =>
                                setState(() => _isDarkTheme = true),
                            onLangChanged: (lang) =>
                                setState(() => _selectedLang = lang),
                          ),
                          const SizedBox(height: 14),
                          PasswordCard(
                            isOpen: _isPasswordFormOpen,
                            hasPassword: hasPassword,
                            onToggle: () =>
                                setState(() => _isPasswordFormOpen =
                                    !_isPasswordFormOpen),
                            onForgotPassword: _showForgotPasswordBottomSheet,
                            onChangePassword: _changePassword,
                            currentPasswordCtrl: _currentPasswordCtrl,
                            newPasswordCtrl: _newPasswordCtrl,
                            confirmPasswordCtrl: _confirmPasswordCtrl,
                            currentPasswordValidator:
                                requiredValidator(
                                    fieldName: 'Поточний пароль'),
                            newPasswordValidator: passwordValidator(
                                minLength: 8),
                            confirmPasswordValidator:
                                requiredValidator(
                                    fieldName: 'Повторіть пароль'),
                          ),
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _signOut,
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFFCEEEE),
                                foregroundColor: const Color(0xFFB3261E),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.logout_rounded, size: 20),
                              label: const Text(
                                'Вийти з профілю',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Прозорий перехоплювач натискань поза меню
            if (_isMenuOpen)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => _isMenuOpen = false),
                  child: const SizedBox.expand(),
                ),
              ),

            // Випадаюче меню
            if (_isMenuOpen)
              Positioned(
                top: 68.0,
                right: 20.0,
                width: 220,
                child: Material(
                  elevation: 12,
                  shadowColor: Colors.black.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                          child: Text(
                            'Додатково',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const Divider(color: AppColors.cardBorder, height: 1),
                        _buildMenuItem(
                          icon: Icons.phishing_rounded,
                          label: 'Снасті',
                          onTap: () {
                            setState(() => _isMenuOpen = false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TackleScreen(),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.bar_chart_rounded,
                          label: 'Статистика',
                          onTap: () {
                            setState(() => _isMenuOpen = false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StatisticsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Діялоги / панелі ---
  void _showPickPhotoDialog() {
    showPhotoPickerDialog(
      context: context,
      onSelect: (url) async {
        setState(() => _avatarUrl = url);
        try {
          await _authRepository.updateProfile(photoURL: url);
        } catch (_) {}
      },
    );
  }

  void _showForgotPasswordBottomSheet() {
    showForgotPasswordBottomSheet(
      context: context,
      initialEmail: _email,
      onSend: (email) async {
        Navigator.pop(context);
        try {
          await _authRepository.sendPasswordResetEmail(email);
          if (!mounted) return;
          showAppSnackBar(
            context,
            message:
                'Посилання для скидання паролю надіслано на вашу пошту.',
            isError: false,
          );
        } catch (e) {
          if (!mounted) return;
          showAppSnackBar(
            context,
            title: 'Помилка відновлення пароля',
            message: authErrorMessage(e),
            isError: true,
          );
        }
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
