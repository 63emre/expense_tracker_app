import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

const categoryIcons = {
  Category.food: Icons.lunch_dining_sharp,
  Category.travel: Icons.flight_takeoff_outlined,
  Category.leisure: Icons.movie_sharp,
  Category.work: Icons.work_outlined,
};

enum Category { food, leisure, travel, work }

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
  final String title;
  final double amount;
  final String id;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses = allExpenses
          .where((expense) => expense.category == category)
          .toList();

  final Category category;
  final List<Expense> expenses;
  double? get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
