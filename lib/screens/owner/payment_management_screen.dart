// lib/screens/owner/payment_management_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/payment_model.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../utils/runtime_storage.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';

class PaymentManagementScreen extends StatefulWidget {
  const PaymentManagementScreen({Key? key}) : super(key: key);

  @override
  State<PaymentManagementScreen> createState() =>
      _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 3; // Index for the 'Payments' tab
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/owner/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/owner/members');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/owner/trainers');
        break;
      case 3:
        // Already on payments screen
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/owner/more');
        break;
    }
  }

  List<Payment> _getFilteredPayments(String status) {
    List<Payment> payments =
        DummyData.payments
            .where((payment) => payment.status == status)
            .toList();

    if (_searchQuery.isNotEmpty) {
      // Get user names for searching
      final users = DummyData.users;
      payments =
          payments.where((payment) {
            final user = users.firstWhere(
              (user) => user.id == payment.userId,
              orElse:
                  () =>
                      User(id: '', name: '', email: '', role: '', password: ''),
            );
            return user.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                payment.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
          }).toList();
    }

    return payments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Payment Management',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search payments...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Due Payments'),
                Tab(text: 'Paid Payments'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Due Payments Tab
                _buildPaymentsTab('Due'),

                // Paid Payments Tab
                _buildPaymentsTab('Paid'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPaymentDialog();
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: OwnerBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildPaymentsTab(String status) {
    final payments = _getFilteredPayments(status);
    final users = DummyData.users;

    return payments.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                status == 'Due' ? Icons.pending_actions : Icons.check_circle,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'No ${status.toLowerCase()} payments found',
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final payment = payments[index];
            final user = users.firstWhere(
              (user) => user.id == payment.userId,
              orElse:
                  () => User(
                    id: '',
                    name: 'Unknown',
                    email: '',
                    role: '',
                    password: '',
                  ),
            );

            return _buildPaymentCard(payment, user, status);
          },
        );
  }

  Widget _buildPaymentCard(Payment payment, User user, String status) {
    final dateFormat = DateFormat('MM/dd/yyyy');
    final formattedDate = dateFormat.format(payment.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  radius: 24,
                  child: Text(
                    user.name.substring(0, 1),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        payment.description,
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
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      status == 'Due' ? Icons.pending : Icons.check_circle,
                      color: status == 'Due' ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status,
                      style: TextStyle(
                        color: status == 'Due' ? Colors.orange : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (status == 'Due')
                  ElevatedButton(
                    onPressed: () => _markAsPaid(payment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(8),
                    ),
                    child: const Text('Mark as Paid'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String? selectedUserId;

    final members =
        DummyData.users
            .where((user) => user.role == AppConstants.roleMember)
            .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Member dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Member'),
                  items:
                      members.map((member) {
                        return DropdownMenuItem<String>(
                          value: member.id,
                          child: Text(member.name),
                        );
                      }).toList(),
                  onChanged: (String? value) {
                    selectedUserId = value;
                  },
                ),

                // Amount field
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount (\$)'),
                  keyboardType: TextInputType.number,
                ),

                // Description field
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedUserId != null &&
                    amountController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  final newPayment = Payment(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    userId: selectedUserId!,
                    amount: double.tryParse(amountController.text) ?? 0.0,
                    description: descriptionController.text,
                    date: DateTime.now(),
                    status: 'Due',
                  );

                  // Add to runtime storage or database
                  RuntimeStorage.addPayment(newPayment);

                  Navigator.of(context).pop();
                  setState(() {}); // Refresh the UI
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _markAsPaid(Payment payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Payment'),
          content: Text(
            'Mark payment of \$${payment.amount.toStringAsFixed(2)} as paid?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update payment status
                RuntimeStorage.updatePaymentStatus(payment.id, 'Paid');

                Navigator.of(context).pop();
                setState(() {}); // Refresh the UI
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
