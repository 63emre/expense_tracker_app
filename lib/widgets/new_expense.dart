import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Define a formatter for consistent date formatting
final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  // Callback function to add a new expense to the parent widget
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  // Controllers for text input fields
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  // State variables for form data
  DateTime? _selectedDate;
  Category? _selectedCategory = Category.leisure; // Default category

  // Opens a date picker and updates the selected date
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // Validates and submits the expense data
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // Validate all required inputs
    if (_titleController.text.trim().isEmpty ||
        _selectedDate == null ||
        amountIsInvalid ||
        _selectedCategory == null) {
      // Show error message if any input is invalid
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
            "Please make sure a valid title, amount, date, and category was entered",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Create and add the new expense using the provided callback
    widget.onAddExpense(
      Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory!,
      ),
    );

    // Close the modal after saving
    Navigator.pop(context);
  }

  // Clean up controllers when the widget is removed
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final isWideLayout = constraints.maxWidth >= 600;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                isWideLayout ? 48 : 16,
                16,
                keyboardSpace + 16,
              ),
              child: Column(
                children: [
                  if (isWideLayout)
                    // Wide layout: inputs in rows
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              label: Text("Title"),
                            ),
                            maxLength: 50,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            decoration: const InputDecoration(
                              prefixText: '\$',
                              label: Text("Amount"),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    // Narrow layout: title on its own row
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(label: Text("Title")),
                      maxLength: 50,
                    ),

                  if (isWideLayout)
                    const SizedBox(height: 24)
                  else
                    Row(
                      children: [
                        // Amount input field with dollar sign prefix
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            decoration: const InputDecoration(
                              prefixText: '\$',
                              label: Text("Amount"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Date picker section with calendar icon
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  _selectedDate == null
                                      ? 'No date selected'
                                      : formatter.format(_selectedDate!),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  if (isWideLayout)
                    // Wide layout: date and category in same row
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  _selectedDate == null
                                      ? 'No date selected'
                                      : formatter.format(_selectedDate!),
                                ),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: DropdownButton(
                            value: _selectedCategory,
                            isExpanded: true,
                            items: Category.values.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(height: 16),

                  if (!isWideLayout)
                    // Narrow layout: category and buttons in separate row
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text("Save Expense"),
                        ),
                      ],
                    ),

                  if (isWideLayout) ...[
                    const SizedBox(height: 24),
                    // Wide layout: buttons centered at bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text("Save Expense"),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
