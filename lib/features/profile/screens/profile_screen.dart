import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../../tackle/screens/tackle_screen.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_settings_card.dart';
import '../widgets/email_confirmation_banner.dart';
import '../widgets/forgot_password_bottom_sheet.dart';
import '../widgets/password_card.dart';
import '../widgets/password_confirmation_dialog.dart';
import '../widgets/personal_data_card.dart';
import '../widgets/photo_picker_dialog.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu.dart';
import '../widgets/user_summary_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  final AuthRepository _authRepository = AuthRepository();

  Timer? _emailStatusTimer;
  bool _isRefreshingEmail = false;
  String? _pendingEmail;

  // Контролери
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _currentPasswordCtrl;
  late final TextEditingController _newPasswordCtrl;
  late final TextEditingController _confirmPasswordCtrl;

  // Прапорці інтерфейсу
  bool _isPersonalExpanded = false;
  bool _isEditingPersonal = false;
  bool _isPasswordFormOpen = false;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _currentPasswordCtrl = TextEditingController();
    _newPasswordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refreshEmailStatus());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshEmailStatus());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _emailStatusTimer?.cancel();
    _firstNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _startEmailStatusPolling() {
    _emailStatusTimer?.cancel();
    _emailStatusTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_pendingEmail != null) {
        unawaited(_refreshEmailStatus());
      }
    });
  }

  Future<void> _refreshEmailStatus() async {
    if (_isRefreshingEmail) return;
    _isRefreshingEmail = true;

    try {
      final expectedEmail = _pendingEmail;
      final user = await _authRepository.reloadCurrentUser();
      if (!mounted || user == null) return;

      if (expectedEmail != null && user.email == expectedEmail) {
        _emailStatusTimer?.cancel();
        await _authRepository.signOut();
        return;
      }

      if (!mounted) return;
      setState(() {
        if (!_isEditingPersonal) {
          _emailCtrl.text = user.email ?? '';
        }
      });
    } catch (_) {
      // Оновлення пошти не повинно блокувати роботу профілю.
    } finally {
      _isRefreshingEmail = false;
    }
  }

  // --- Особисті дані ---
  Future<String?> _askForPassword() {
    return showDialog<String>(
      context: context,
      builder: (_) => const PasswordConfirmationDialog(),
    );
  }

  void _unfocusPersonalDataEditor() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Групує цифри номера за шаблоном 2-3-2-2 (наприклад 551234567 → 55 123 45 67).
  String _groupDigits(String digits) {
    final groups = <String>[];
    var i = 0;
    for (final len in [2, 3, 2, 2]) {
      if (i >= digits.length) break;
      final end = digits.length < i + len ? digits.length : i + len;
      groups.add(digits.substring(i, end));
      i = end;
    }
    if (i < digits.length) {
      groups.add(digits.substring(i));
    }
    return groups.join(' ');
  }

  Future<void> _savePersonalData() async {
    _unfocusPersonalDataEditor();

    final auth = context.read<AuthProvider>();
    final currentEmail = auth.user?.email ?? '';
    final currentUid = auth.user?.uid ?? '';

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
    if (name.length > 20) {
      showAppSnackBar(
        context,
        title: 'Помилка',
        message: "Ім'я не може містити більше 20 символів.",
        isError: true,
      );
      return;
    }

    final newEmail = _emailCtrl.text.trim();
    final emailChanged = newEmail.isNotEmpty && newEmail != currentEmail;
    if (emailChanged && !_authRepository.usesPasswordProvider) {
      showAppSnackBar(
        context,
        title: 'Пошту не змінено',
        message:
            'Для зміни пошти потрібен акаунт із входом через email і пароль.',
        isError: true,
      );
      return;
    }
    if (emailChanged) {
      final emailError = emailValidator()(newEmail);
      if (emailError != null) {
        showAppSnackBar(
          context,
          title: 'Помилка',
          message: emailError,
          isError: true,
        );
        return;
      }
    }

    // Нормалізація номера телефону
    final phoneText = _phoneCtrl.text.trim();
    String? phoneToSave;
    if (phoneText.isNotEmpty) {
      final digits = phoneText.replaceAll(RegExp(r'\D'), '');
      if (digits.isNotEmpty && digits.length != 9) {
        showAppSnackBar(
          context,
          title: 'Помилка',
          message: 'Номер телефону має містити 9 цифр після коду +380.',
          isError: true,
        );
        return;
      }
      if (digits.length == 9) {
        phoneToSave = '+380 $digits';
      }
    }

    String? currentPassword;
    if (emailChanged) {
      final emailTaken = await _authRepository.isEmailTaken(newEmail)
          || await _authRepository.isEmailTakenByAnotherUser(
              newEmail, currentUid);
      if (!mounted) return;
      if (emailTaken) {
        showAppSnackBar(
          context,
          title: 'Пошту не змінено',
          message: 'Обліковий запис з таким Email вже існує.',
          isError: true,
        );
        return;
      }

      currentPassword = await _askForPassword();
      if (currentPassword == null) return;
    }

    setState(() => _isEditingPersonal = false);

    try {
      if (emailChanged) {
        await _authRepository.updateEmail(
          newEmail: newEmail,
          currentPassword: currentPassword!,
        );
        if (!mounted) return;
        setState(() => _pendingEmail = newEmail);
        _startEmailStatusPolling();
      }
      await auth.updateProfile(
        displayName: name,
        phone: phoneToSave ?? '',
        email: emailChanged ? newEmail : currentEmail,
      );
      if (!mounted) return;

      setState(() {
        _isPersonalExpanded = false; // Закриваємо панельку після збереження
      });

      showAppSnackBar(
        context,
        message: emailChanged
            ? 'Особисті дані збережено. Лист для підтвердження надіслано на $newEmail.'
            : 'Особисті дані успішно збережено!',
        isError: false,
      );
    } catch (e) {
      if (!mounted) return;
      final message = authErrorMessage(e);
      final isEmailTaken = message.contains('вже існує')
          || message.contains('вже використовуються');
      if (isEmailTaken) {
        showAppSnackBar(
          context,
          title: 'Пошту не змінено',
          message: 'Обліковий запис з таким Email вже існує.',
          isError: true,
        );
      } else {
        showAppSnackBar(
          context,
          title: 'Помилка збереження',
          message: message,
          isError: true,
        );
      }
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
        message: 'Заповніть усі поля для зміни пароля',
        isError: true,
      );
      return;
    }

    if (newPassword.length < 8) {
      showAppSnackBar(
        context,
        title: 'Помилка',
        message: 'Пароль має містити щонайменше 8 символів',
        isError: true,
      );
      return;
    }

    if (newPassword != confirm) {
      showAppSnackBar(
        context,
        title: 'Помилка',
        message: 'Введені паролі не збігаються',
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
        message: 'Пароль успішно змінено!',
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

  Future<void> _signOut() => context.read<AuthProvider>().signOut();

  @override
  Widget build(BuildContext context) {
    // Дані користувача беруться реактивно з AuthProvider (лаба №5, завдання 3.1–3.2).
    final auth = context.watch<AuthProvider>();
    final settings = context.watch<SettingsProvider>();
    final user = auth.user;
    final profile = auth.profile;

    final firstName = (profile?.displayName ?? user?.displayName ?? '')
        .trim()
        .isNotEmpty
        ? (profile?.displayName ?? user?.displayName ?? 'Користувач')
        : 'Користувач';
    final email = profile?.email ?? user?.email ?? '';
    final phone = profile?.phone ?? '';
    final avatarUrl = (profile?.photoURL ?? user?.photoURL ?? '').isNotEmpty
        ? (profile?.photoURL ?? user?.photoURL)
        : null;
    final initial = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'А';

    final hasPassword = _authRepository.usesPasswordProvider;

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
                            name: firstName,
                            avatarUrl: avatarUrl,
                            initial: initial,
                            onAvatarTap: () => _showPickPhotoDialog(),
                          ),
                          const SizedBox(height: 14),
                          PersonalDataCard(
                            name: firstName,
                            email: email,
                            phone: phone,
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
                                _firstNameCtrl.text = firstName;
                                _emailCtrl.text = email;
                                final rawDigits = phone.replaceAll(
                                  RegExp(r'\D'),
                                  '',
                                );
                                final localDigits = rawDigits.startsWith('380') &&
                                        rawDigits.length == 12
                                    ? rawDigits.substring(3)
                                    : rawDigits;
                                _phoneCtrl.text = _groupDigits(localDigits);
                                _isEditingPersonal = true;
                              });
                            },
                            onSave: _savePersonalData,
                            onCancel: () => setState(() {
                              _isEditingPersonal = false;
                            }),
                            firstNameCtrl: _firstNameCtrl,
                            emailCtrl: _emailCtrl,
                            phoneCtrl: _phoneCtrl,
                          ),
                          if (_pendingEmail != null) ...[
                            const SizedBox(height: 14),
                            EmailConfirmationBanner(pendingEmail: _pendingEmail!),
                          ],
                          const SizedBox(height: 14),
                          AppSettingsCard(
                            isDarkTheme: settings.isDarkTheme,
                            selectedLang: settings.language,
                            onThemeLight: () =>
                                settings.setTheme(false),
                            onThemeDark: () =>
                                settings.setTheme(true),
                            onLangChanged: (lang) =>
                                settings.setLanguage(lang),
                          ),
                          const SizedBox(height: 14),
                          PasswordCard(
                            isOpen: _isPasswordFormOpen,
                            hasPassword: hasPassword,
                            onToggle: () => setState(
                              () => _isPasswordFormOpen = !_isPasswordFormOpen,
                            ),
                            onForgotPassword: _showForgotPasswordBottomSheet,
                            onChangePassword: _changePassword,
                            currentPasswordCtrl: _currentPasswordCtrl,
                            newPasswordCtrl: _newPasswordCtrl,
                            confirmPasswordCtrl: _confirmPasswordCtrl,
                            currentPasswordValidator: requiredValidator(
                              fieldName: 'Поточний пароль',
                            ),
                            newPasswordValidator: passwordValidator(
                              minLength: 8,
                            ),
                            confirmPasswordValidator: requiredValidator(
                              fieldName: 'Повторіть пароль',
                            ),
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
            if (_isMenuOpen)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => _isMenuOpen = false),
                  child: const SizedBox.expand(),
                ),
              ),
            ProfileMenu(
              isMenuOpen: _isMenuOpen,
              onClose: () => setState(() => _isMenuOpen = false),
              onTackleTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TackleScreen()),
                );
              },
              onStatisticsTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPickPhotoDialog() {
    showPhotoPickerDialog(
      context: context,
      onSelect: (url) async {
        try {
          await context.read<AuthProvider>().updateAvatar(url);
          if (!mounted) return;
          setState(() {});
          showAppSnackBar(
            context,
            message: url == null ? 'Аватар видалено.' : 'Аватар оновлено.',
            isError: false,
          );
        } catch (e) {
          if (!mounted) return;
          showAppSnackBar(
            context,
            title: 'Не вдалося зберегти аватар',
            message: authErrorMessage(e),
            isError: true,
          );
        }
      },
    );
  }

  void _showForgotPasswordBottomSheet() {
    showForgotPasswordBottomSheet(
      context: context,
      initialEmail: context.read<AuthProvider>().user?.email ?? '',
      onSend: (email) async {
        Navigator.pop(context);
        try {
          await _authRepository.sendPasswordResetEmail(email);
          if (!mounted) return;
          showAppSnackBar(
            context,
            message: 'Посилання для скидання паролю надіслано на вашу пошту.',
            isError: false,
          );
        } catch (e) {
          if (!mounted) return;
          showAppSnackBar(
            context,
            title: 'Помилка відновлення паролю',
            message: authErrorMessage(e),
            isError: true,
          );
        }
      },
    );
  }
}
