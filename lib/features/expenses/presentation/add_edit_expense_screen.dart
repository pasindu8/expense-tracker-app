import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/categories.dart';
import '../../../core/theme/app_theme.dart';
import '../data/expense_service.dart';
import '../models/expense_model.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddEditExpenseScreen({super.key, this.expense});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toStringAsFixed(0);
      _merchantController.text = widget.expense!.merchant;
      _noteController.text = widget.expense!.note;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    }
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount'), backgroundColor: AppTheme.errorRed),
      );
      return;
    }

    if (_merchantController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter merchant/title'), backgroundColor: AppTheme.errorRed),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ExpenseService();
      if (widget.expense == null) {
        await service.addExpense(Expense(
          id: '',
          merchant: _merchantController.text.trim(),
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate,
          note: _noteController.text.trim(),
        ));
      } else {
        await service.updateExpense(Expense(
          id: widget.expense!.id,
          merchant: _merchantController.text.trim(),
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate,
          note: _noteController.text.trim(),
        ));
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.expense == null ? 'Expense added.' : 'Expense updated.'),
            backgroundColor: AppTheme.primaryTeal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't save. Please check your connection."), backgroundColor: AppTheme.errorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.expense != null;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit expense' : 'Add expense', style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text('AMOUNT', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('LKR ', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      IntrinsicWidth(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(border: InputBorder.none, hintText: '0', hintStyle: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: appCategories.map((cat) {
                  final isSelected = _selectedCategory == cat.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat.id),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryContainer : AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? AppTheme.primaryTeal : Colors.transparent, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Icon(cat.icon, color: cat.color, size: 24),
                          const SizedBox(height: 4),
                          Text(cat.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? AppTheme.primaryTeal : AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Merchant / Title', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _merchantController,
              decoration: InputDecoration(
                hintText: 'e.g. Keells Super, PickMe Ride',
                prefixIcon: const Icon(Icons.storefront_outlined),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, color: AppTheme.textSecondary),
                        const SizedBox(width: 12),
                        Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      ],
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Note (Optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLength: 120,
              decoration: InputDecoration(
                hintText: 'Add an optional note',
                prefixIcon: const Icon(Icons.notes_outlined),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(isEdit ? 'Save changes' : '+ Add expense', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}