import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


final themeModeProvider = StateProvider<bool>((ref) => false); // false = Light Mode


final monthlyBudgetProvider = StateProvider<double>((ref) => 50000.0);