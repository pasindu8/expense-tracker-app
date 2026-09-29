import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/categories.dart';
import '../../../core/theme/app_theme.dart';
import '../data/expense_service.dart';
import '../models/expense_model.dart';
import 'add_edit_expense_screen.dart';
import 'settings_provider.dart';
import 'package:fl_chart/fl_chart.dart';


class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;
  DateTime _currentMonth = DateTime.now();
  String? _selectedFilterCategory;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    
    final isDark = ref.watch(themeModeProvider);
    
    
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.background;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.surface;
    final textColor = isDark ? Colors.white : AppTheme.textPrimary;
    final textSecColor = isDark ? Colors.white70 : AppTheme.textSecondary;

    final screens = [
      _buildHomeScreen(isDark, surfaceColor, textColor, textSecColor),
      _buildHistoryScreen(isDark, surfaceColor, textColor, textSecColor),
      _buildProfileScreen(isDark, surfaceColor, textColor, textSecColor),
    ];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: isDark ? AppTheme.primaryTeal.withOpacity(0.3) : AppTheme.primaryContainer,
        backgroundColor: surfaceColor,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: AppTheme.primaryTeal), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long, color: AppTheme.primaryTeal), label: 'History'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: AppTheme.primaryTeal), label: 'Profile'),
        ],
      ),
      floatingActionButton: _currentIndex != 2
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditExpenseScreen())),
              backgroundColor: AppTheme.primaryTeal,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            )
          : null,
    );
  }
  Widget _buildHomeScreen(bool isDark, Color surfaceColor, Color textColor, Color textSecColor) {
    final expenseService = ExpenseService();
    final budget = ref.watch(monthlyBudgetProvider); 

    return StreamBuilder<List<Expense>>(
      stream: expenseService.streamExpenses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal));
        }
        final allExpenses = snapshot.data ?? [];
        final monthExpenses = allExpenses.where((e) => e.date.year == _currentMonth.year && e.date.month == _currentMonth.month).toList();
        final totalSpent = monthExpenses.fold(0.0, (sum, item) => sum + item.amount);

        Map<String, double> categorySums = {};
        for (var e in monthExpenses) {
          categorySums[e.category] = (categorySums[e.category] ?? 0.0) + e.amount;
        }

        final double budgetPercentage = budget > 0 ? (totalSpent / budget).clamp(0.0, 1.0) : 0.0;
        final bool isBudgetWarning = budgetPercentage >= 0.8; 

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRACK · HOME', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecColor, letterSpacing: 1.2)),
                    Text('Expense Tracker', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                  ],
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none, color: textColor)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: textColor),
                  onPressed: () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1)),
                ),
                Text(DateFormat('MMMM yyyy').format(_currentMonth), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: textColor),
                  onPressed: () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            
            GestureDetector(
              onTap: () => _showBudgetDialog(surfaceColor, textColor, textSecColor, budget),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isBudgetWarning ? AppTheme.errorRed : AppTheme.primaryTeal, 
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Spent this month', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                          child: Text('${(budgetPercentage * 100).toStringAsFixed(0)}% of Budget', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('LKR ${NumberFormat("#,##0").format(totalSpent)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: budgetPercentage,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Budget: LKR ${NumberFormat("#,##0").format(budget)}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        const Icon(Icons.edit, color: Colors.white70, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            if (categorySums.isNotEmpty) ...[
              Text('Expense Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: categorySums.entries.map((e) {
                      final cat = appCategories.firstWhere((c) => c.id == e.key, orElse: () => appCategories.last);
                      final percentage = (e.value / totalSpent) * 100;
                      return PieChartSectionData(
                        color: cat.color,
                        value: e.value,
                        title: '${percentage.toStringAsFixed(0)}%',
                        radius: percentage > 10 ? 50 : 45,
                        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }).toList(),
                  )
                ),
              ),
              const SizedBox(height: 24),
              Text('By category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 12),
              
              // Category Progress Bars
              ...categorySums.entries.map((entry) {
                final cat = appCategories.firstWhere((c) => c.id == entry.key, orElse: () => appCategories.last);
                final percentage = entry.value / totalSpent;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(cat.icon, color: cat.color, size: 20),
                          const SizedBox(width: 12),
                          Expanded(child: Text(entry.key, style: TextStyle(fontWeight: FontWeight.w600, color: textColor))),
                          Text('LKR ${NumberFormat("#,##0").format(entry.value)}', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage,
                          minHeight: 4,
                          backgroundColor: cat.color.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(cat.color),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                TextButton(onPressed: () => setState(() => _currentIndex = 1), child: const Text('See history', style: TextStyle(color: AppTheme.primaryTeal))),
              ],
            ),
            if (monthExpenses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text('No expenses recorded this month.', style: TextStyle(color: textSecColor))),
              )
            else
              ...monthExpenses.take(5).map((expense) => _buildExpenseTile(expense, surfaceColor, textColor, textSecColor)),
          ],
        );
      },
    );
  }

  Widget _buildHistoryScreen(bool isDark, Color surfaceColor, Color textColor, Color textSecColor) {
    final expenseService = ExpenseService();
    return StreamBuilder<List<Expense>>(
      stream: expenseService.streamExpenses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal));
        }
        var expenses = snapshot.data ?? [];
        
       
        if (_searchQuery.isNotEmpty) {
          expenses = expenses.where((e) => 
            e.merchant.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();
        }

        
        if (_selectedFilterCategory != null) {
          expenses = expenses.where((e) => e.category == _selectedFilterCategory).toList();
        }

        final filteredTotal = expenses.fold(0.0, (sum, item) => sum + item.amount);

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('REVIEW · EXPENSES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecColor, letterSpacing: 1.2)),
                    Text('History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: textColor),
                  onPressed: () => _openFilterBottomSheet(surfaceColor, textColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
           
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search expenses...',
                hintStyle: TextStyle(color: textSecColor),
                prefixIcon: Icon(Icons.search, color: textSecColor),
                filled: true,
                fillColor: surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 16),
            // ---------------------------------

            if (_selectedFilterCategory != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Chip(
                      label: Text(_selectedFilterCategory!, style: TextStyle(color: isDark ? Colors.black : Colors.black)),
                      backgroundColor: isDark ? AppTheme.primaryTeal : AppTheme.primaryContainer,
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() => _selectedFilterCategory = null),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: isDark ? AppTheme.primaryTeal.withOpacity(0.2) : AppTheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filtered total · ${expenses.length} expenses', style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryTeal)),
                  Text('LKR ${NumberFormat("#,##0").format(filteredTotal)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryTeal, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (expenses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: textSecColor),
                    const SizedBox(height: 12),
                    Text('No expenses match', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  ],
                ),
              )
            else
              ...expenses.map((expense) => _buildExpenseTile(expense, surfaceColor, textColor, textSecColor)),
          ],
        );
      },
    );
  }

  Widget _buildProfileScreen(bool isDark, Color surfaceColor, Color textColor, Color textSecColor) {
    final user = FirebaseAuth.instance.currentUser;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('ACCOUNT · SETTINGS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecColor, letterSpacing: 1.2)),
        Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppTheme.primaryTeal, borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Text(user?.email?.substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.displayName ?? 'User', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(user?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSettingTile(Icons.person_outline, 'Account details', 'Name and email', surfaceColor, textColor, textSecColor),
        _buildSettingTile(Icons.currency_exchange, 'Currency', 'Sri Lankan rupee - LKR', surfaceColor, textColor, textSecColor),
        _buildSettingTile(Icons.lock_outline, 'Privacy & security', 'Password and data', surfaceColor, textColor, textSecColor),
        
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: const Icon(Icons.dark_mode_outlined, color: AppTheme.primaryTeal),
            title: Text('Dark mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
            subtitle: Text('Toggle light or dark theme', style: TextStyle(fontSize: 12, color: textSecColor)),
            trailing: Switch(
              value: isDark,
              activeColor: AppTheme.primaryTeal,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state = value;
              },
            ),
          ),
        ),

        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          icon: const Icon(Icons.logout, color: AppTheme.errorRed),
          label: const Text('Log out', style: TextStyle(color: AppTheme.errorRed, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.errorRed),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 20),
        Center(child: Text('Expense Tracker · Version 1.0.0', style: TextStyle(color: textSecColor, fontSize: 12))),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle, Color surfaceColor, Color textColor, Color textSecColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryTeal),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: textSecColor)),
        trailing: Icon(Icons.chevron_right, color: textSecColor),
       
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title settings will be available in the next update.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.primaryTeal,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpenseTile(Expense expense, Color surfaceColor, Color textColor, Color textSecColor) {
    final cat = appCategories.firstWhere((c) => c.id == expense.category, orElse: () => appCategories.last);
    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: AppTheme.errorRed, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (dir) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: surfaceColor,
            title: Text('Delete this expense?', style: TextStyle(color: textColor)),
            content: Text('${expense.merchant} · LKR ${NumberFormat("#,##0").format(expense.amount)} will be removed permanently.', style: TextStyle(color: textSecColor)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep expense')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed, foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete expense'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ExpenseService().deleteExpense(expense.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expense deleted')));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditExpenseScreen(expense: expense)));
          },
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: cat.color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(cat.icon, color: cat.color, size: 22),
          ),
          title: Text(expense.merchant, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
          subtitle: Text('${expense.category} · ${DateFormat('dd MMM').format(expense.date)}', style: TextStyle(fontSize: 12, color: textSecColor)),
          trailing: Text('- LKR ${NumberFormat("#,##0").format(expense.amount)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
        ),
      ),
    );
  }

  void _openFilterBottomSheet(Color surfaceColor, Color textColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: Icon(Icons.close, color: textColor)),
                ],
              ),
              const SizedBox(height: 16),
              Text('Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: appCategories.map((c) {
                  final isSelected = _selectedFilterCategory == c.id;
                  return ChoiceChip(
                    label: Text(c.label),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedFilterCategory = val ? c.id : null);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  void _showBudgetDialog(Color surfaceColor, Color textColor, Color textSecColor, double currentBudget) {
    final TextEditingController budgetController = TextEditingController(text: currentBudget.toStringAsFixed(0));
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text('Set Monthly Budget', style: TextStyle(color: textColor)),
        content: TextField(
          controller: budgetController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: 'Enter budget amount',
            hintStyle: TextStyle(color: textSecColor),
            prefixText: 'LKR ',
            prefixStyle: TextStyle(color: textColor),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textSecColor)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryTeal)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryTeal, foregroundColor: Colors.white),
            onPressed: () {
              final newBudget = double.tryParse(budgetController.text);
              if (newBudget != null && newBudget > 0) {
                
                ref.read(monthlyBudgetProvider.notifier).state = newBudget;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budget updated successfully!')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}