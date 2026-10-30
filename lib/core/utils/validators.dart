import 'package:flutter/material.dart';

/// Спільні валідатори для форм автентифікації
/// (вхід, реєстрація, відновлення пароля) та допоміжні функції
/// для виведення кастомних повідомлень про помилки.

/// Регулярний вираз для перевірки формату електронної пошти.
final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Валідатор обов'язкового поля.
FormFieldValidator<String> requiredValidator({String fieldName = 'поле'}) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Будь ласка, введіть $fieldName';
    }
    return null;
  };
}

/// Валідатор електронної пошти.
FormFieldValidator<String> emailValidator() {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Будь ласка, введіть Email';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Введіть коректний Email';
    }
    return null;
  };
}

/// Валідатор пароля.
/// Якщо задано [minLength], перевіряє також мінімальну довжину пароля.
FormFieldValidator<String> passwordValidator({int? minLength}) {
  return (value) {
    if (value == null || value.isEmpty) {
      return 'Будь ласка, введіть пароль';
    }
    if (minLength != null && value.length < minLength) {
      return 'Пароль має бути щонайменше $minLength символів';
    }
    return null;
  };
}

/// Валідатор поля "Підтвердження пароля".
/// [password] — функція, що повертає поточне значення поля пароля
/// (читайте його динамічно під час валідації).
FormFieldValidator<String> confirmPasswordValidator(String Function() password) {
  return (value) {
    final currentPassword = password();
    if (value == null || value.isEmpty) {
      return 'Будь ласка, підтвердіть пароль';
    }
    if (value != currentPassword) {
      return 'Паролі не збігаються';
    }
    return null;
  };
}

/// Мапить коди помилок Firebase Auth на українські повідомлення.
final _firebaseErrorMessages = {
  'user-not-found': 'Користувача з таким Email не знайдено.',
  'wrong-password': 'Невірний пароль.',
  'email-already-in-use': 'Обліковий запис з таким Email вже існує.',
  'invalid-email': 'Введіть коректну адресу електронної пошти.',
  'weak-password': 'Пароль занадто простий. Мінімум 8 символів.',
  'requires-recent-login': 'Потрібно повторно увійти в акаунт.',
  'user-disabled': 'Цей обліковий запис заблоковано.',
  'too-many-requests': 'Забагато спроб. Зачекайте і спробуйте пізніше.',
  'invalid-credential': 'Неправильний Email або пароль.',
  'account-exists-with-different-credential': 'Акаунт вже існує з іншим методом входу.',
  'credential-already-in-use': 'Ці облікові дані вже використовуються.',
  'operation-not-allowed': 'Цей метод входу не дозволений.',
  'invalid-verification-code': 'Невірний код підтвердження.',
  'invalid-verification-id': 'Некоректний ідентифікатор підтвердження.',
  'network-request-failed': 'Помилка мережі. Перевірте підключення.',
};

/// Витягує текст помилки з Exception, кинутого [AuthRepository],
/// прибираючи службовий префікс 'Exception: ' та підставляючи
/// конкретне українське повідомлення для відомих кодів помилок Firebase.
String authErrorMessage(Object error) {
  final message = error.toString();
  const prefix = 'Exception: ';
  final cleanMessage = message.startsWith(prefix)
      ? message.substring(prefix.length)
      : message;

  // Якщо повідомлення містить відомий код помилки Firebase, повертаємо конкретний текст
  for (final entry in _firebaseErrorMessages.entries) {
    if (cleanMessage.contains(entry.key)) {
      return entry.value;
    }
  }

  return cleanMessage.isNotEmpty ? cleanMessage : 'Сталася невідома помилка.';
}
