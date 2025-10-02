import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
  
class Expense {
  Expense({required this.title, required this.amount, required this.date})
    : id = uuid.v4();
  final String title;
  final double amount;
  final String id;
  final DateTime date;


  final String category;
    food,
    leisure,
    travel,
    work,
}}
