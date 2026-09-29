import 'package:flutter/material.dart';

class ExpenseCategoryItem {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const ExpenseCategoryItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

const List<ExpenseCategoryItem> appCategories = [
  ExpenseCategoryItem(
    id: 'Housing',
    label: 'Housing',
    icon: Icons.home_outlined,
    color: Color(0xFF3B82F6),
  ),
  ExpenseCategoryItem(
    id: 'Food',
    label: 'Food',
    icon: Icons.restaurant,
    color: Color(0xFFF59E0B),
  ),
  ExpenseCategoryItem(
    id: 'Transport',
    label: 'Transport',
    icon: Icons.directions_bus,
    color: Color(0xFF8B5CF6),
  ),
  ExpenseCategoryItem(
    id: 'Bills',
    label: 'Bills',
    icon: Icons.receipt_long,
    color: Color(0xFFEC4899),
  ),
  ExpenseCategoryItem(
    id: 'Other',
    label: 'Other',
    icon: Icons.category_outlined,
    color: Color(0xFF6B7280),
  ),
];