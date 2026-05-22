import 'package:flutter/material.dart';
import '../pages/send_money_page.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAction(
            context,
            icon: Icons.store_outlined,
            label: 'Payer\nMarchand',
            onTap: () {},
          ),
          _buildAction(
            context,
            icon: Icons.phone_android_outlined,
            label: 'Crédit\nTéléphone',
            onTap: () {},
          ),
          _buildAction(
            context,
            icon: Icons.send_outlined,
            label: 'Envoyer\nArgent',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SendMoneyPage()),
              );
            },
          ),
          _buildAction(
            context,
            icon: Icons.account_balance_wallet_outlined,
            label: 'Retrait\nEspèces',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFFF7900),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}