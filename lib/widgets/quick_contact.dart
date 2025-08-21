import 'package:flutter/material.dart';

class QuickContact extends StatelessWidget {
  const QuickContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
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
            'Tezkor bog\'lanish',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Biz bilan bog\'lanish uchun quyidagi usullardan birini tanlang',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          
          // Contact buttons
          Row(
            children: [
              Expanded(
                child: _buildContactButton(
                  context,
                  icon: Icons.phone,
                  label: 'Qo\'ng\'iroq',
                  color: Colors.green,
                  onTap: () {
                    // Make phone call
                    _makePhoneCall(context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildContactButton(
                  context,
                  icon: Icons.telegram,
                  label: 'Telegram',
                  color: Colors.blue,
                  onTap: () {
                    // Open Telegram
                    _openTelegram(context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildContactButton(
                  context,
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: Colors.green,
                  onTap: () {
                    // Open WhatsApp
                    _openWhatsApp(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
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
      ),
    );
  }

  void _makePhoneCall(BuildContext context) {
    // This will be implemented with URL launcher
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Telefon qo\'ng\'iroq'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _openTelegram(BuildContext context) {
    // This will be implemented with URL launcher
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Telegram ochilmoqda'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _openWhatsApp(BuildContext context) {
    // This will be implemented with URL launcher
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('WhatsApp ochilmoqda'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
