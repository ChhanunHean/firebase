import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ButtonStatus {
  final String name;
  final bool selected;
  ButtonStatus({required this.name, required this.selected});

  factory ButtonStatus.fromJson(Map<String, dynamic> json) {
    return ButtonStatus(
      name: json['name'] as String,
      selected: json['selected'] as bool,
    );
  }
}
// -------------------
// the repository
// -------------------
class ButtonRepository {
  final String _baseUrl =
      "https://fir-2c4d8-default-rtdb.asia-southeast1.firebasedatabase.app/.json";

  Future<ButtonStatus> getButtonStatus() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode != 200) throw Exception("Error fetching data");
    return ButtonStatus.fromJson(jsonDecode(response.body));
  }

  Future<void> updateButtonStatus(bool newSelected) async {
    final response = await http.patch(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "selected": newSelected,
      }),
    );
    if (response.statusCode != 200) throw Exception("Error updating data");
  }

}

class AsyncData<T> {
  final T? value;
  final String? error;
  final bool isLoading;

  AsyncData.loading() : value = null, error = null, isLoading = true;
  AsyncData.success(this.value) : error = null, isLoading = false;
  AsyncData.error(this.error) : value = null, isLoading = false;
}

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: ButtonScreen()),
  );
}

class ButtonScreen extends StatefulWidget {
  const ButtonScreen({super.key});
  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {
  //----------
  // loading
  //----------
  AsyncData<ButtonStatus> data = AsyncData.loading();
  final ButtonRepository _repository = ButtonRepository();
  //-----------------------------------
  //method to fetch data from firebase
  //-----------------------------------
  @override
  void initState() {
    super.initState();
    _fetchButtonData();
  }

  //------------------------------------------------------
  // Implement the fetchButtonData and handle the 3 state
  //------------------------------------------------------
  void _fetchButtonData() async {
    setState(() => data = AsyncData.loading());
    try {
      final result = await _repository.getButtonStatus();
      setState(() => data = AsyncData.success(result));
    } catch (e) {
      setState(() => data = AsyncData.error(e.toString()));
    }
  }

void _toggleButton() async {
    if (data.value == null) return;
    final currentName = data.value!.name;
    final newSelected = !data.value!.selected;

    setState(() => data = AsyncData.loading());
    try {
      await _repository.updateButtonStatus(newSelected); 
      setState(
        () => data = AsyncData.success(
          ButtonStatus(name: currentName, selected: newSelected),
        ),
      );
    } catch (e) {
      setState(() => data = AsyncData.error(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: data.isLoading
            ? const CircularProgressIndicator()
            : data.error != null
            ? Text("Error: ${data.error}")
            : SizedBox(
                width: 250,
                height: 60,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: data.value!.selected
                        ? Colors.lightBlue.shade300
                        : Colors.transparent,
                    side: const BorderSide(color: Colors.grey),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: _toggleButton,
                  child: Text(
                    data.value!.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
