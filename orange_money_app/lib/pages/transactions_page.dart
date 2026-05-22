import 'package:flutter/material.dart';
import '../models/transaction.dart' as tx_model;
import '../services/database_helper.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    final str = amount.abs().toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('\u202F');
      buffer.write(str[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join();
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'payment':
        return Icons.shopping_cart_outlined;
      case 'top up':
        return Icons.arrow_downward_rounded;
      case 'transfer':
        return Icons.send_outlined;
      case 'bill':
        return Icons.receipt_outlined;
      default:
        return Icons.swap_horiz;
    }
  }

  Color _colorForType(String type) {
    switch (type.toLowerCase()) {
      case 'top up':
        return const Color(0xFF43A047);
      case 'bill':
        return const Color(0xFF8E24AA);
      default:
        return const Color(0xFFFF7900);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFF7900),
        elevation: 0,
        title: const Text(
          'Historique',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: const Color(0xFFFF7900),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              tabs: const [
                Tab(text: 'Tout'),
                Tab(text: 'Reçus'),
                Tab(text: 'Envoyés'),
                Tab(text: 'Factures'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary card
          _buildSummaryCard(),

          // Tab content
          Expanded(
            child: FutureBuilder<List<tx_model.Transaction>>(
              future: DatabaseHelper.instance.getTransactionsByUser(1),
              builder: (context, snapshot) {
                final dbTransactions = snapshot.data ?? [];

                // Merge static + DB transactions for rich demo
                final allTransactions = [
                  ..._staticTransactions(),
                  ...dbTransactions.map((t) => _TransactionItem(
                        icon: _iconForType(t.type),
                        title: t.merchant,
                        subtitle: t.type,
                        amount: t.amount < 0 ? t.amount : -t.amount,
                        date: t.date,
                        iconBg: _colorForType(t.type).withOpacity(0.12),
                        iconColor: _colorForType(t.type),
                      )),
                ];

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildList(allTransactions),
                    _buildList(allTransactions.where((t) => t.amount > 0).toList()),
                    _buildList(allTransactions.where((t) => t.amount < 0 && t.subtitle != 'Facture').toList()),
                    _buildList(allTransactions.where((t) => t.subtitle == 'Facture').toList()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reçu ce mois',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '+50 000 XAF',
                  style: TextStyle(
                    color: Color(0xFF43A047),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFEEEEEE)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dépenses ce mois',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '-75 000 XAF',
                    style: TextStyle(
                      color: Color(0xFFFF7900),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<_TransactionItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            const Text(
              'Aucune transaction',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isPositive = item.amount > 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20),
            ),
            title: Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              '${item.subtitle} • ${item.date}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9E9E9E),
              ),
            ),
            trailing: Text(
              '${isPositive ? '+' : '-'}${_formatAmount(item.amount)} XAF',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isPositive
                    ? const Color(0xFF43A047)
                    : const Color(0xFF212121),
              ),
            ),
          ),
        );
      },
    );
  }

  List<_TransactionItem> _staticTransactions() {
    return [
      _TransactionItem(
        icon: Icons.send_outlined,
        title: 'Envoi à Marie Ngo',
        subtitle: 'Transfert',
        amount: -25000,
        date: "Aujourd'hui",
        iconBg: const Color(0xFFFF7900).withOpacity(0.1),
        iconColor: const Color(0xFFFF7900),
      ),
      _TransactionItem(
        icon: Icons.arrow_downward_rounded,
        title: 'Reçu de Paul Mbarga',
        subtitle: 'Réception',
        amount: 50000,
        date: 'Hier',
        iconBg: const Color(0xFF43A047).withOpacity(0.1),
        iconColor: const Color(0xFF43A047),
      ),
      _TransactionItem(
        icon: Icons.receipt_outlined,
        title: 'Facture ENEO',
        subtitle: 'Facture',
        amount: -18500,
        date: '19 Mai',
        iconBg: const Color(0xFF8E24AA).withOpacity(0.1),
        iconColor: const Color(0xFF8E24AA),
      ),
      _TransactionItem(
        icon: Icons.phone_android_outlined,
        title: 'Crédit Orange',
        subtitle: 'Recharge',
        amount: -1000,
        date: '18 Mai',
        iconBg: const Color(0xFFFF7900).withOpacity(0.1),
        iconColor: const Color(0xFFFF7900),
      ),
    ];
  }
}

class _TransactionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final double amount;
  final String date;
  final Color iconBg;
  final Color iconColor;

  const _TransactionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.iconBg,
    required this.iconColor,
  });
}