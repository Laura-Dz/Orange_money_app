import 'package:flutter/material.dart';
import '../widgets/balance_section.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/services_section.dart';
import '../widgets/partners_section.dart';
import '../widgets/tips_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            backgroundColor: const Color(0xFFFF7900),
            elevation: 0,
            titleSpacing: 16,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/om_logo_white.png',
                  height: 28,
                  errorBuilder: (_, __, ___) => const Text(
                    'Orange Money',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 24),
                onPressed: () {},
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: const [
                BalanceSection(),
                QuickActionsSection(),
                ServicesSection(),
                PartnersSection(),
                TipsSection(),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}