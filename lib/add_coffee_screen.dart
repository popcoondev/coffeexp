import 'package:flutter/material.dart';

class AddCoffeeScreen extends StatefulWidget {
  @override
  _AddCoffeeScreenState createState() => _AddCoffeeScreenState();
}

class _AddCoffeeScreenState extends State<AddCoffeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _coffeeName;
  String? _origin;
  String? _variety;
  String? _process;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Coffee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Coffee Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the coffee name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _coffeeName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Origin'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the origin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _origin = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Variety'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the variety';
                  }
                  return null;
                },
                onSaved: (value) {
                  _variety = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Process'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the process';
                  }
                  return null;
                },
                onSaved: (value) {
                  _process = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    // 新規コーヒーのデータを保存する処理を実装予定
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Coffee added successfully')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
