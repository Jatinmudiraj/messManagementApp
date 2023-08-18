import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MessExpenseCalculator extends StatefulWidget {
  @override
  _MessExpenseCalculatorState createState() => _MessExpenseCalculatorState();
}

class _MessExpenseCalculatorState extends State<MessExpenseCalculator> {
  int _daysPresent = 0;
  double _costPerMeal = 0.0;
  int _numberOfMealsPerDay = 0;
  double _totalExpense = 0.0;

  void _calculateTotalExpense() {
    setState(() {
      _totalExpense =
          _daysPresent.clamp(1, 31) * _costPerMeal * _numberOfMealsPerDay.toDouble();
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mess Expense Calculator'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40,right: 16, left: 16, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of days present (1-31)',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue[400]!,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _daysPresent = int.parse(value);
                  });
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Cost for food per meal (in rupees)',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue!,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _costPerMeal = double.parse(value);
                  });
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of times food eaten in a day',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue!,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _numberOfMealsPerDay = int.parse(value);
                  });
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (_daysPresent > 31) {
                    _showErrorDialog(
                        'You cannot calculate expenses for more than 31 days.');
                  } else {
                    _calculateTotalExpense();
                  }
                },
                child: Text('Calculate total expense'),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Total expense for the month: ₹${_totalExpense.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
