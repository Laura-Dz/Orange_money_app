import 'package:flutter/material.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _selectedNetwork = 'MTN';

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envoyer de l\'argent'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Envoyer vers un numéro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),
            _buildNetworkSelector(),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _recipientController,
                    label: 'Numéro du destinataire',
                    hintText: '+237 6 77 77 77 77',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _amountController,
                    label: 'Montant',
                    hintText: '25 000 XAF',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _messageController,
                    label: 'Motif (optionnel)',
                    hintText: 'Ex: Cadeau, facture, prêt',
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Destinataires récents',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),
            _buildRecentRecipient(
              name: 'Jean Paul',
              number: '+237 6 99 99 99 99',
              icon: Icons.person,
            ),
            _buildRecentRecipient(
              name: 'Marie Claire',
              number: '+237 6 88 88 88 88',
              icon: Icons.person,
            ),
            _buildRecentRecipient(
              name: 'Orange Business',
              number: 'ORNG-1234-5678',
              icon: Icons.business,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7900),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _onSendPressed,
                child: const Text(
                  'Continuer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Réseau',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.w600,
            ),
          ),
          DropdownButton<String>(
            value: _selectedNetwork,
            underline: const SizedBox.shrink(),
            items: const [
              DropdownMenuItem(value: 'MTN', child: Text('MTN')),
              DropdownMenuItem(value: 'Orange', child: Text('Orange')),
              DropdownMenuItem(value: 'Nexttel', child: Text('Nexttel')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedNetwork = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  Widget _buildRecentRecipient({
    required String name,
    required String number,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFF7900).withOpacity(0.12),
          child: Icon(icon, color: const Color(0xFFFF7900)),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        subtitle: Text(number),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          color: const Color(0xFF9E9E9E),
          onPressed: () {
            _recipientController.text = number;
          },
        ),
      ),
    );
  }

  void _onSendPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Vérifier l\'envoi'),
            content: Text(
              'Vous enverrez ${_amountController.text.trim()} à ${_recipientController.text.trim()} via $_selectedNetwork.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7900)),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transfert initié avec succès.'),
                    ),
                  );
                },
                child: const Text('Confirmer'),
              ),
            ],
          );
        },
      );
    }
  }
}
