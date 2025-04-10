// lib/screens/member/payment_screen.dart
import 'package:flutter/material.dart';
import '../../models/payment_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/common/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _currentIndex = 0; // This will be set based on navigation

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/member/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/member/progress');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/member/workouts');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/member/diets');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/member/more');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get payment data for current user
    final payments =
        DummyData.payments
            .where(
              (payment) => payment.userId == '1',
            ) // Hardcoded for prototype
            .toList();

    // Sort payments by date (newest first)
    payments.sort((a, b) => b.date.compareTo(a.date));

    // Check if there are any due payments
    final hasDuePayment = payments.any((payment) => payment.status == 'Due');

    return Scaffold(
      appBar: const CustomAppBar(title: AppConstants.paymentsTitle),
      body: Column(
        children: [
          // Payment summary card
          if (hasDuePayment) _buildDuePaymentCard(payments),

          // Payment history
          Expanded(child: _buildPaymentHistory(payments)),
        ],
      ),
      bottomNavigationBar: MemberBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildDuePaymentCard(List<Payment> payments) {
    final duePayments =
        payments.where((payment) => payment.status == 'Due').toList();
    final totalDue = duePayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              Text(
                'Payment Due: \$${totalDue.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: AppConstants.payNowText,
            onPressed: () {
              _showPaymentMethodDialog();
            },
            backgroundColor: Colors.red,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory(List<Payment> payments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Payment History',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              return _buildPaymentItem(payment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentItem(Payment payment) {
    final isPaid = payment.status == 'Paid';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  isPaid
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPaid ? Icons.check_circle : Icons.pending,
              color: isPaid ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${payment.date.month}/${payment.date.day}/${payment.date.year}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                payment.status,
                style: TextStyle(
                  color: isPaid ? Colors.green : Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPaymentMethodItem(
                icon: Icons.credit_card,
                title: 'Credit/Debit Card',
                onTap: () {
                  Navigator.pop(context);
                  _showPaymentSuccessDialog();
                },
              ),
              const SizedBox(height: 8),
              _buildPaymentMethodItem(
                icon: Icons.account_balance,
                title: 'Bank Transfer',
                onTap: () {
                  Navigator.pop(context);
                  _showPaymentSuccessDialog();
                },
              ),
              const SizedBox(height: 8),
              _buildPaymentMethodItem(
                icon: Icons.payment,
                title: 'PayPal',
                onTap: () {
                  Navigator.pop(context);
                  _showPaymentSuccessDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text(
                'Your payment has been processed successfully.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  // In a real app, this would update the payment status in the database
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
