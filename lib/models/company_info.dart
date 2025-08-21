class CompanyInfo {
  final String id;
  final String phonePrimary;
  final String? phoneSecondary;
  final String? telegramUsername;
  final String? whatsappNumber;
  final String? email;
  final String? address;
  final String? workingHours;
  final String? aboutText;
  final DateTime updatedAt;

  CompanyInfo({
    required this.id,
    required this.phonePrimary,
    this.phoneSecondary,
    this.telegramUsername,
    this.whatsappNumber,
    this.email,
    this.address,
    this.workingHours,
    this.aboutText,
    required this.updatedAt,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      id: json['id'] as String,
      phonePrimary: json['phone_primary'] as String,
      phoneSecondary: json['phone_secondary'] as String?,
      telegramUsername: json['telegram_username'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      workingHours: json['working_hours'] as String?,
      aboutText: json['about_text'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_primary': phonePrimary,
      'phone_secondary': phoneSecondary,
      'telegram_username': telegramUsername,
      'whatsapp_number': whatsappNumber,
      'email': email,
      'address': address,
      'working_hours': workingHours,
      'about_text': aboutText,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get telegramUrl {
    if (telegramUsername == null || telegramUsername!.isEmpty) return '';
    final username = telegramUsername!.startsWith('@') 
        ? telegramUsername!.substring(1) 
        : telegramUsername!;
    return 'https://t.me/$username';
  }

  String get whatsappUrl {
    if (whatsappNumber == null || whatsappNumber!.isEmpty) return '';
    final number = whatsappNumber!.replaceAll(RegExp(r'[^\d]'), '');
    return 'https://wa.me/$number';
  }

  String get phoneUrl {
    return 'tel:$phonePrimary';
  }

  String get emailUrl {
    if (email == null || email!.isEmpty) return '';
    return 'mailto:$email';
  }

  @override
  String toString() {
    return 'CompanyInfo(id: $id, phonePrimary: $phonePrimary)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyInfo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
