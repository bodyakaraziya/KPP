import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/screens/login_screen.dart';
import '../../tackle/screens/tackle_screen.dart';
import '../../main/screens/main_screen.dart';
import '../../statistics/screens/statistics_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Дані користувача (за замовчуванням твої дані зі скріншоту, які можна змінювати у формі)
  String _firstName = 'Богдан';
  String _lastName = 'Каразія';
  String _email = 'bohdan.karaziia.pz.2024@lpnu.ua';
  String _phone = '+380 68 97 09 647';

  // Обране фото аватара (null = відображається кружечок з ініціалом)
  String? _selectedAvatarUrl =
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=600&q=80';

  // Стани розкриття секцій та редагування
  bool _isPersonalExpanded = false;
  bool _isEditingPersonal = false;
  bool _isPasswordFormOpen = false;

  // Налаштування застосунку
  bool _isDarkTheme = false;
  String _selectedLang = 'УКР';
  bool _isMenuOpen = false;

  // Контролери для форми редагування особистих даних
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  // 5 демо-фотографій для діалогу "Вибрати фото" відповідно до макета Figma
  static const List<String> _demoPhotos = [
    'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1508193638397-1c4234db14d8?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=600&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: _firstName);
    _lastNameCtrl = TextEditingController(text: _lastName);
    _emailCtrl = TextEditingController(text: _email);
    _phoneCtrl = TextEditingController(text: _phone);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String get _fullName => '$_firstName $_lastName'.trim();

  String get _initial =>
      _firstName.isNotEmpty ? _firstName[0].toUpperCase() : 'А';

  @override
  Widget build(BuildContext context) {
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
            // 1. Основний контент: Фіксована шапка зверху + Скрол карток знизу
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: _buildHeader(),
                ),
                Expanded(
                  child: NotificationListener<ScrollStartNotification>(
                    onNotification: (_) {
                      // Якщо користувач почав гортати список — закриваємо меню
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
                          _buildUserSummaryCard(),
                          const SizedBox(height: 14),
                          _buildPersonalDataCard(),
                          const SizedBox(height: 14),
                          _buildAppSettingsCard(),
                          const SizedBox(height: 14),
                          _buildPasswordCard(),
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
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

            // 2. Прозорий перехоплювач натискань поза меню (закриває меню при кліку повз)
            if (_isMenuOpen)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => _isMenuOpen = false),
                  child: const SizedBox.expand(),
                ),
              ),

            // 3. Випадаюче меню, вирівняне рівно під кнопкою (right: 20, top: 68)
            if (_isMenuOpen)
              Positioned(
                top: 68.0, // Рівно під кнопкою 44х44 з урахуванням верхнього відступу 16
                right: 20.0, // Рівно по правому краю кнопки (а не прилипле до краю екрана)
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

  // --- 1. ШАПКА ---
  Widget _buildHeader() {
    return SizedBox(
      height: 70.0,
      child: Stack(
        children: [
          // Header content (title and subtitle)
          Positioned(
            left: 0,
            right: 60, // Leave space for menu button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Профіль',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Налаштування та особисті дані',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Menu button
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => setState(() => _isMenuOpen = !_isMenuOpen),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return RotationTransition(
                      turns: Tween<double>(
                        begin: 0.0,
                        end: 0.5,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: _isMenuOpen
                      ? const Icon(
                          Icons.clear,
                          color: AppColors.textPrimary,
                          size: 22,
                        )
                      : const Icon(
                          Icons.menu_rounded,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                ),
              ),
            ),
          ),
          // Menu panel (when open)
        ],
      ),
    );
  }

  // --- 2. КАРТКА КОРИСТУВАЧА ТА СТАТИСТИКИ ---
  Widget _buildUserSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Аватар з іконкою редагування фото
              GestureDetector(
                onTap: () => _showPickPhotoDialog(context),
                child: Stack(
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryTeal,
                          width: 2.2,
                        ),
                      ),
                      child: ClipOval(
                        child: _selectedAvatarUrl != null
                            ? Image.network(
                                _selectedAvatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppColors.lightAmberBg,
                                  alignment: Alignment.center,
                                  child: Text(
                                    _initial,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.accentAmber,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.lightAmberBg,
                                alignment: Alignment.center,
                                child: Text(
                                  _initial,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.accentAmber,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Ім'я та дата реєстрації
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fullName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'У спільноті з травня 2023',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 16),

          // Три колонки статистики: 18 виїзди | 86,4 кг улов | 12 видів
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildStatColumn(value: '18', label: 'виїзди'),
                ),
                const VerticalDivider(
                  color: AppColors.cardBorder,
                  thickness: 1,
                ),
                Expanded(
                  child: _buildStatColumn(value: '86,4', label: 'кг улов'),
                ),
                const VerticalDivider(
                  color: AppColors.cardBorder,
                  thickness: 1,
                ),
                Expanded(
                  child: _buildStatColumn(value: '12', label: 'видів'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // --- 3. КАРТКА "ОСОБИСТІ ДАНІ" (ПЕРЕГЛЯД + РЕДАГУВАННЯ) ---
  Widget _buildPersonalDataCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          // Заголовок акордеона
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isPersonalExpanded = !_isPersonalExpanded;
                  if (!_isPersonalExpanded) _isEditingPersonal = false;
                });
              },
              borderRadius: BorderRadius.circular(22),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.lightTealBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.primaryTeal,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Особисті дані',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isEditingPersonal
                                ? 'Редагування активне'
                                : '$_fullName · $_email',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isPersonalExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Вміст розгорнутої секції
          if (_isPersonalExpanded) ...[
            const Divider(color: AppColors.cardBorder, height: 1),
            Padding(
              padding: const EdgeInsets.all(18),
              child: _isEditingPersonal
                  ? _buildPersonalEditForm()
                  : _buildPersonalReadOnlyView(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPersonalReadOnlyView() {
    return Column(
      children: [
        _buildInfoRow(Icons.person_outline, _fullName),
        const Divider(color: Color(0xFFEEF3F1), height: 24),
        _buildInfoRow(Icons.mail_outline, _email),
        const Divider(color: Color(0xFFEEF3F1), height: 24),
        _buildInfoRow(Icons.access_time, _phone),
        const Divider(color: Color(0xFFEEF3F1), height: 24),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _firstNameCtrl.text = _firstName;
                _lastNameCtrl.text = _lastName;
                _emailCtrl.text = _email;
                _phoneCtrl.text = _phone;
                _isEditingPersonal = true;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.lightTealBg,
              foregroundColor: AppColors.primaryTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text(
              'Редагувати профіль',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Ім'я"),
        _buildInputField(
          controller: _firstNameCtrl,
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 14),

        _buildFieldLabel('Прізвище'),
        _buildInputField(
          controller: _lastNameCtrl,
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 14),

        _buildFieldLabel('Email'),
        _buildInputField(
          controller: _emailCtrl,
          prefixIcon: Icons.mail_outline,
        ),
        const SizedBox(height: 14),

        _buildFieldLabel('Телефон'),
        _buildInputField(controller: _phoneCtrl),
        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _firstName = _firstNameCtrl.text.trim();
                      _lastName = _lastNameCtrl.text.trim();
                      _email = _emailCtrl.text.trim();
                      _phone = _phoneCtrl.text.trim();
                      _isEditingPersonal = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Особисті дані оновлено!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text(
                    'Зберегти',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 48,
              child: TextButton(
                onPressed: () => setState(() => _isEditingPersonal = false),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.lightTealBg,
                  foregroundColor: AppColors.primaryTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Скасувати',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () =>
                  setState(() => _isPasswordFormOpen = !_isPasswordFormOpen),
              borderRadius: BorderRadius.circular(22),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.lightTealBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.primaryTeal,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Пароль',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Оновлено 3 місяці тому',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isPasswordFormOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_isPasswordFormOpen) ...[
            const Divider(color: AppColors.cardBorder, height: 1),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Поточний пароль'),
                  _buildInputFieldWithToggle(
                    hintText: 'Ваш пароль',
                    labelText: 'Поточний пароль',
                  ),
                  const SizedBox(height: 14),

                  _buildFieldLabel('Новий пароль'),
                  _buildInputFieldWithToggle(
                    hintText: 'Щонайменше 8 символів',
                    labelText: 'Новий пароль',
                  ),
                  const SizedBox(height: 14),

                  _buildFieldLabel('Повторіть пароль'),
                  _buildInputFieldWithToggle(
                    hintText: 'Паролі мають збігатися',
                    labelText: 'Повторіть пароль',
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Пароль успішно оновлено!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Оновити пароль',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Navigate to password recovery screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Функція відновлення паролю буде додана пізніше',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        'Забули пароль?',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- 4. КАРТКА "НАЛАШТУВАННЯ ЗАСТОСУНКУ" ---
  Widget _buildAppSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                color: AppColors.textPrimary,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Налаштування застосунку',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            'Тема оформлення',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),

          // Картки вибору теми: Світла / Темна
          Row(
            children: [
              Expanded(
                child: _buildThemeOptionCard(
                  isLightCard: true,
                  isSelected: !_isDarkTheme,
                  onTap: () => setState(() => _isDarkTheme = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildThemeOptionCard(
                  isLightCard: false,
                  isSelected: _isDarkTheme,
                  onTap: () => setState(() => _isDarkTheme = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0xFFEEF3F1), height: 1),
          const SizedBox(height: 14),

          // Рядок вибору мови: УКР | ENG
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.language, color: AppColors.primaryTeal, size: 22),
                  SizedBox(width: 12),
                  Text(
                    'Мова',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EFED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildLangSegment('УКР'),
                    _buildLangSegment('ENG'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOptionCard({
    required bool isLightCard,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightTealBg : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.cardBorder,
            width: isSelected ? 1.6 : 1.2,
          ),
        ),
        child: Column(
          children: [
            // Прев'ю макета теми
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLightCard
                    ? const Color(0xFFEAF2F0)
                    : const Color(0xFF152627),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: isLightCard
                          ? const Color(0xFFC5D5D2)
                          : const Color(0xFF2B4243),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: isLightCard
                          ? const Color(0xFFC5D5D2)
                          : const Color(0xFF2B4243),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Icon(
              isLightCard
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              size: 18,
              color: isSelected
                  ? AppColors.primaryTeal
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              isLightCard ? 'Світла' : 'Темна',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.primaryTeal
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. КАРТКА "НАЛАШТУВАННЯ ЗАСТОСУНКУ" (КОМПАКТНА ВЕРСІЯ) ---
  // Widget _buildAppSettingsCard() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(22),
  //       border: Border.all(color: AppColors.cardBorder, width: 1.2),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // 1. Вибір теми (Світла / Темна)
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Icon(
  //                   _isDarkTheme
  //                       ? Icons.nightlight_round_outlined
  //                       : Icons.wb_sunny_outlined,
  //                   color: AppColors.primaryTeal,
  //                   size: 22,
  //                 ),
  //                 const SizedBox(width: 12),
  //                 const Text(
  //                   'Тема',
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.w700,
  //                     color: AppColors.textPrimary,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               padding: const EdgeInsets.all(4),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFE9EFED),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Row(
  //                 children: [
  //                   _buildThemeSegment(
  //                     label: 'Світла',
  //                     icon: Icons.wb_sunny_outlined,
  //                     isSelected: !_isDarkTheme,
  //                     onTap: () => setState(() => _isDarkTheme = false),
  //                   ),
  //                   _buildThemeSegment(
  //                     label: 'Темна',
  //                     icon: Icons.nightlight_round_outlined,
  //                     isSelected: _isDarkTheme,
  //                     onTap: () => setState(() => _isDarkTheme = true),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         const Divider(color: Color(0xFFEEF3F1), height: 1),
  //         const SizedBox(height: 12),

  //         // 2. Вибір мови (УКР / ENG)
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Row(
  //               children: [
  //                 Icon(Icons.language, color: AppColors.primaryTeal, size: 22),
  //                 SizedBox(width: 12),
  //                 Text(
  //                   'Мова',
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.w700,
  //                     color: AppColors.textPrimary,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               padding: const EdgeInsets.all(4),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFE9EFED),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Row(
  //                 children: [
  //                   _buildLangSegment('УКР'),
  //                   _buildLangSegment('ENG'),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // // Допоміжний віджет для сегмента теми
  // Widget _buildThemeSegment({
  //   required String label,
  //   required IconData icon,
  //   required bool isSelected,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: AnimatedContainer(
  //       duration: const Duration(milliseconds: 150),
  //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //       decoration: BoxDecoration(
  //         color: isSelected ? Colors.white : Colors.transparent,
  //         borderRadius: BorderRadius.circular(9),
  //         boxShadow: isSelected
  //             ? [
  //                 BoxShadow(
  //                   color: Colors.black.withValues(alpha: 0.05),
  //                   blurRadius: 4,
  //                   offset: const Offset(0, 2),
  //                 )
  //               ]
  //             : null,
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(
  //             icon,
  //             size: 14,
  //             color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary,
  //           ),
  //           const SizedBox(width: 4),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               fontSize: 12,
  //               fontWeight: FontWeight.w800,
  //               color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLangSegment(String lang) {
    final bool isSelected = _selectedLang == lang;
    return GestureDetector(
      onTap: () => setState(() => _selectedLang = lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          lang,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // --- МОДАЛЬНЕ ВІКНО "ВИБРАТИ ФОТО" (ЗГІДНО З МАКЕТОМ FIGMA) ---
  void _showPickPhotoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Вибрати фото',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Виберіть з демо-галереї або підключіть камеру',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() => _selectedAvatarUrl = null);
                          Navigator.pop(ctx);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.lightTealBg,
                          foregroundColor: AppColors.primaryTeal,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.camera_alt_outlined, size: 18),
                        label: const Text(
                          'Камера',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() => _selectedAvatarUrl = _demoPhotos[0]);
                          Navigator.pop(ctx);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.lightTealBg,
                          foregroundColor: AppColors.primaryTeal,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.image_outlined, size: 18),
                        label: const Text(
                          'Галерея',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _demoPhotos.map((url) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAvatarUrl = url);
                        Navigator.pop(ctx);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          url,
                          width: 82,
                          height: 82,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 82,
                            height: 82,
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image,
                              size: 28,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Скасувати',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- ДОПОМІЖНІ ВІДЖЕТИ ПОЛІВ ---
  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildInputField({
    TextEditingController? controller,
    String? initialValue,
    String? hintText,
    IconData? prefixIcon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textSecondary, size: 20)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryTeal,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInputFieldWithToggle({
    String? initialValue,
    String? hintText,
    String? labelText,
    bool obscureText = true,
  }) {
    bool _obscureText = obscureText;

    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          initialValue: initialValue,
          obscureText: _obscureText,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.cardBorder,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primaryTeal,
                width: 1.5,
              ),
            ),
          ),
        );
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
