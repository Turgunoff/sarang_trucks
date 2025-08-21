// lib/screens/contact_screen.dart - TUZATILGAN URL LAUNCHER BILAN
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Pulse animation for online indicator
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withOpacity(0.8),
                    colorScheme.secondary.withOpacity(0.6),
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.support_agent_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Bog\'lanish',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                background: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(painter: _ContactPatternPainter()),
                    ),
                    // Decorative elements
                    Positioned(
                      top: 60,
                      right: 30,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Company info header
                          _buildCompanyHeader(),

                          const SizedBox(height: 30),

                          // Quick contact section
                          _buildQuickContactSection(),

                          const SizedBox(height: 30),

                          // Contact methods
                          _buildContactMethods(),

                          const SizedBox(height: 30),

                          // Office info
                          _buildOfficeInfo(),

                          const SizedBox(height: 30),

                          // Working hours
                          _buildWorkingHours(),

                          const SizedBox(height: 30),

                          // About company
                          _buildAboutSection(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final safeScale = value.clamp(0.0, 2.0);
        return Transform.scale(
          scale: safeScale,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Company logo/icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_shipping_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // Company name
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 8),

                // Company description
                Text(
                  AppConstants.appDescription,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Online status
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Hozir onlayn',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.flash_on_rounded,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tezkor yordam',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '24/7 mijozlar xizmati',
                  style: TextStyle(
                    color: Colors.orange.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Faol',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethods() {
    final methods = [
      {
        'icon': Icons.phone_rounded,
        'title': 'Telefon qo\'ng\'iroq',
        'subtitle': 'Darhol javob beramiz',
        'value': AppConstants.companyPhone,
        'color': Colors.green,
        'action': () => _makePhoneCall(AppConstants.companyPhone),
      },

      {
        'icon': Icons.telegram,
        'title': 'Telegram',
        'subtitle': 'Tezkor xabar almashuv',
        'value': '@${AppConstants.companyTelegram}',
        'color': Colors.blue,
        'action': () => _openTelegram(),
      },
      {
        'icon': Icons.chat_rounded,
        'title': 'WhatsApp',
        'subtitle': 'Qulay muloqot',
        'value': AppConstants.companyWhatsApp,
        'color': Colors.green,
        'action': () => _openWhatsApp(),
      },
      {
        'icon': Icons.email_rounded,
        'title': 'Email',
        'subtitle': 'Rasmiy murojaat',
        'value': AppConstants.companyEmail,
        'color': Colors.orange,
        'action': () => _sendEmail(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Bog\'lanish usullari', Icons.contacts_rounded),
        const SizedBox(height: 16),
        ...methods.asMap().entries.map((entry) {
          final index = entry.key;
          final method = entry.value;
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              final safeOpacity = value.clamp(0.0, 1.0);
              return Transform.translate(
                offset: Offset(30 * (1 - safeOpacity), 0),
                child: Opacity(
                  opacity: safeOpacity,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildContactMethodCard(method),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildContactMethodCard(Map<String, dynamic> method) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: method['action'],
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: method['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(method['icon'], color: method['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method['subtitle'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: method['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          method['value'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: method['color'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: method['color'],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfficeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Ofis ma\'lumotlari', Icons.location_on_rounded),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(
                Icons.location_on_outlined,
                'Manzil',
                AppConstants.companyAddress,
                Colors.red,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.business_outlined,
                'Kompaniya',
                'Arisu Sarang MCHJ',
                Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.star_outline,
                'Tajriba',
                '5+ yil ishonchli xizmat',
                Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkingHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Ish vaqti', Icons.access_time_rounded),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.withOpacity(0.1),
                Colors.green.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.schedule_rounded,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ish kunlari',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppConstants.companyWorkingHours,
                          style: TextStyle(
                            color: Colors.green.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Ochiq',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Favqulodda vaziyatlarda 24/7 qo\'ng\'iroq qabul qilamiz',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Kompaniya haqida', Icons.info_outline_rounded),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.companyAbout,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFeatureBadge(
                    'Ishonchli',
                    Icons.verified_outlined,
                    Colors.green,
                  ),
                  _buildFeatureBadge(
                    'Professional',
                    Icons.star_outline,
                    Colors.blue,
                  ),
                  _buildFeatureBadge(
                    'Arzon narx',
                    Icons.attach_money_outlined,
                    Colors.orange,
                  ),
                  _buildFeatureBadge(
                    'Tezkor',
                    Icons.speed_outlined,
                    Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // 🔧 TUZATILGAN ACTION METHODS

  /// Telefon qo'ng'iroq qilish
  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      // Haptic feedback
      HapticFeedback.lightImpact();

      // Telefon raqamini tozalash (faqat raqamlar qoldirish)
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // Telefon URL yaratish
      final Uri phoneUri = Uri(scheme: 'tel', path: cleanNumber);

      debugPrint('🔧 Telefon qo\'ng\'iroq: $phoneUri');

      // URL ochish mumkinligini tekshirish
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);

        // Muvaffaqiyatli feedback
        _showContactFeedback(
          icon: Icons.phone,
          title: 'Telefon ochildi',
          subtitle: cleanNumber,
          color: Colors.green,
        );
      } else {
        throw Exception('Telefon ilovasi ochilmadi');
      }
    } catch (e) {
      debugPrint('❌ Telefon qo\'ng\'iroq xatosi: $e');

      // Xato feedback
      _showContactFeedback(
        icon: Icons.error_outline,
        title: 'Xatolik',
        subtitle: 'Telefon ilovasi ochilmayapti',
        color: Colors.red,
      );
    }
  }

  /// Telegram ochish
  Future<void> _openTelegram() async {
    try {
      // Haptic feedback
      HapticFeedback.lightImpact();

      // Telegram username ni tozalash (@ belgisini olib tashlash)
      final username = AppConstants.companyTelegram.replaceAll('@', '');

      // Telegram URL yaratish - app va web variantlari
      final Uri telegramAppUri = Uri.parse('tg://resolve?domain=$username');
      final Uri telegramWebUri = Uri.parse('https://t.me/$username');

      debugPrint('🔧 Telegram ochish: $telegramAppUri');

      // Avval Telegram app'ni ochishga harakat qilish
      bool launched = false;
      if (await canLaunchUrl(telegramAppUri)) {
        launched = await launchUrl(
          telegramAppUri,
          mode: LaunchMode.externalApplication,
        );
      }

      // Agar app ochilmasa, web versiyasini ochish
      if (!launched) {
        debugPrint(
          '🔧 Telegram app ochilmadi, web versiyasini ochish: $telegramWebUri',
        );
        if (await canLaunchUrl(telegramWebUri)) {
          await launchUrl(telegramWebUri, mode: LaunchMode.externalApplication);
          launched = true;
        }
      }

      if (launched) {
        // Muvaffaqiyatli feedback
        _showContactFeedback(
          icon: Icons.telegram,
          title: 'Telegram ochildi',
          subtitle: '@$username',
          color: Colors.blue,
        );
      } else {
        throw Exception('Telegram ochilmadi');
      }
    } catch (e) {
      debugPrint('❌ Telegram ochish xatosi: $e');

      // Xato feedback
      _showContactFeedback(
        icon: Icons.error_outline,
        title: 'Xatolik',
        subtitle: 'Telegram ochilmayapti',
        color: Colors.red,
      );
    }
  }

  /// WhatsApp ochish
  Future<void> _openWhatsApp() async {
    try {
      // Haptic feedback
      HapticFeedback.lightImpact();

      // WhatsApp raqamini tozalash (faqat raqamlar qoldirish)
      final cleanNumber = AppConstants.companyWhatsApp.replaceAll(
        RegExp(r'[^\d]'),
        '',
      );

      // WhatsApp URL yaratish - app va web variantlari
      final Uri whatsAppUri = Uri.parse('whatsapp://send?phone=$cleanNumber');
      final Uri whatsAppWebUri = Uri.parse('https://wa.me/$cleanNumber');

      debugPrint('🔧 WhatsApp ochish: $whatsAppUri');

      // Avval WhatsApp app'ni ochishga harakat qilish
      bool launched = false;
      if (await canLaunchUrl(whatsAppUri)) {
        launched = await launchUrl(
          whatsAppUri,
          mode: LaunchMode.externalApplication,
        );
      }

      // Agar app ochilmasa, web versiyasini ochish
      if (!launched) {
        debugPrint(
          '🔧 WhatsApp app ochilmadi, web versiyasini ochish: $whatsAppWebUri',
        );
        if (await canLaunchUrl(whatsAppWebUri)) {
          await launchUrl(whatsAppWebUri, mode: LaunchMode.externalApplication);
          launched = true;
        }
      }

      if (launched) {
        // Muvaffaqiyatli feedback
        _showContactFeedback(
          icon: Icons.chat,
          title: 'WhatsApp ochildi',
          subtitle: '+$cleanNumber',
          color: Colors.green,
        );
      } else {
        throw Exception('WhatsApp ochilmadi');
      }
    } catch (e) {
      debugPrint('❌ WhatsApp ochish xatosi: $e');

      // Xato feedback
      _showContactFeedback(
        icon: Icons.error_outline,
        title: 'Xatolik',
        subtitle: 'WhatsApp ochilmayapti',
        color: Colors.red,
      );
    }
  }

  /// Email yuborish
  Future<void> _sendEmail() async {
    try {
      // Haptic feedback
      HapticFeedback.lightImpact();

      // Email URI yaratish
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: AppConstants.companyEmail,
        query: _buildEmailQuery(),
      );

      debugPrint('🔧 Email yuborish: $emailUri');

      // Email ilovasini ochish
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);

        // Muvaffaqiyatli feedback
        _showContactFeedback(
          icon: Icons.email,
          title: 'Email ilovasi ochildi',
          subtitle: AppConstants.companyEmail,
          color: Colors.orange,
        );
      } else {
        throw Exception('Email ilovasi ochilmadi');
      }
    } catch (e) {
      debugPrint('❌ Email yuborish xatosi: $e');

      // Xato feedback
      _showContactFeedback(
        icon: Icons.error_outline,
        title: 'Xatolik',
        subtitle: 'Email ilovasi ochilmayapti',
        color: Colors.red,
      );
    }
  }

  /// Email query parametrlarini yaratish
  String _buildEmailQuery() {
    final Map<String, String> queryParams = {
      'subject': 'Sarang Trucks - Murojaat',
      'body': '''Salom!

Men Sarang Trucks xizmatlari haqida ma'lumot olmoqchiman.

Iltimos, menga quyidagi mavzularda yordam bering:
- Mavjud yuk mashinalari ro'yxati
- Narxlar va shartlar
- Ijara muddati
- Qo'shimcha xizmatlar

Rahmat!''',
    };

    return queryParams.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  /// Feedback ko'rsatish
  void _showContactFeedback({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// Custom painter for background pattern
class _ContactPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw subtle geometric pattern
    for (int i = 0; i < size.width; i += 60) {
      for (int j = 0; j < size.height; j += 60) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 3, paint);
      }
    }

    // Draw connecting lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 0; i < size.width.toInt(); i += 120) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i + 60, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
