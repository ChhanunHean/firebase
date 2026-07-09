import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ==========================================
// 1. THE MODEL
// ==========================================
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

// ==========================================
// 2. THE REPOSITORY
// ==========================================
class ButtonRepository {
  final String _baseUrl =
      "https://fir-2c4d8-default-rtdb.asia-southeast1.firebasedatabase.app/.json";

  Future<ButtonStatus> getButtonStatus() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode != 200) throw Exception("Error fetching data");
    return ButtonStatus.fromJson(jsonDecode(response.body));
  }
}

// Helper class to manage the 3 states of our asynchronous operation
class AsyncData<T> {
  final T? value;
  final String? error;
  final bool isLoading;

  AsyncData.loading() : value = null, error = null, isLoading = true;
  AsyncData.success(this.value) : error = null, isLoading = false;
  AsyncData.error(this.error) : value = null, isLoading = false;
}

// ==========================================
// 3. THE UI & FLUTTER APPLICATION
// ==========================================
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
  // Start with a loading state [cite: 34]
  AsyncData<ButtonStatus> data = AsyncData.loading();
  final ButtonRepository _repository = ButtonRepository();

  // Overwrite the initState method to fetch button data from firebase 
  @override
  void initState() {
    super.initState();
    _fetchButtonData(); 
  }

  // Implement the fetchButtonData and handle the 3 states 
  void _fetchButtonData() async {
    setState(() => data = AsyncData.loading()); 
    try {
      final result = await _repository.getButtonStatus();
      setState(() => data = AsyncData.success(result)); 
    } catch (e) {
      setState(() => data = AsyncData.error(e.toString())); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: data.isLoading
            ? const CircularProgressIndicator() // State 1: Loading
            : data.error != null
            ? Text("Error: ${data.error}") // State 2: Error 
            : SizedBox(
                width: 250,
                height: 60,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // Dynamic background color depending on selection 
                    backgroundColor: data.value!.selected
                        ? Colors.lightBlue.shade300
                        : Colors.transparent,
                    side: const BorderSide(color: Colors.grey),
                    shape: const StadiumBorder(), // Makes it rounded 
                  ),
                  onPressed: () {
                    // Optional: You can trigger _fetchButtonData() here to refresh manually
                  },
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
