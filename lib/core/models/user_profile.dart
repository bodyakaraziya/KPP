/// Модель профілю користувача (імя, email, телефон, аватар).
class UserProfile {
  final String uid;
  final String displayName;
  final String? email;
  final String? phone;
  final String? photoURL;

  UserProfile({
    required this.uid,
    required this.displayName,
    this.email,
    this.phone,
    this.photoURL,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (photoURL != null) 'photoURL': photoURL,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        uid: json['uid'] as String,
        displayName: json['displayName'] as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        photoURL: json['photoURL'] as String?,
      );
}
