import '../../models/todo.dart';

class TodoRepository {
  static final global = TodoRepository(); // unique instance

  final List<Todo> fakeTodos = [
    Todo(id: '1', title: 'Buy groceries', completed: false),
    Todo(id: '2', title: 'Finish Flutter homework', completed: true),
    Todo(id: '3', title: 'Call the dentist', completed: false),
    Todo(id: '4', title: 'Read 20 pages of a book', completed: true),
    Todo(id: '5', title: 'Go for a 30-minute walk', completed: false),
  ];

  Future<List<Todo>> getTodos() async {
    //  TODO
    //  Adapt the code to handle firebase data fetch
    //

    return Future.delayed(Duration(seconds: 1), () {
      return fakeTodos;

      //  TODO
      // Ensure the message is displayed on the UI if error occured
      //throw RepositoryException("No wifi !");
    });
  }

  Future<void> updateCompleted(String todoId, bool completed) async {
    //  TODO
    //  Adapt the code to handle firebase data fetch
    //
    int index = fakeTodos.indexWhere((e) => e.id == todoId);
    fakeTodos[index] = fakeTodos[index].copyWith(completed);

    return Future.delayed(Duration(microseconds: 1), () => true);
  }
}







// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../models/todo.dart';
// import '../dto/todo_dto.dart';
// import 'repository_exception.dart';

// class TodoRepository {
//   static final global = TodoRepository(); // unique instance

//   final List<Todo> fakeTodos = [
//     Todo(id: '1', title: 'Buy groceries', completed: false),
//     Todo(id: '2', title: 'Finish Flutter homework', completed: true),
//     Todo(id: '3', title: 'Call the dentist', completed: false),
//     Todo(id: '4', title: 'Read 20 pages of a book', completed: true),
//     Todo(id: '5', title: 'Go for a 30-minute walk', completed: false),
//   ];
//   //------------------------------------------------------------------------------------
//   //                                        Step 4
//   //                              fetch the real data from firebase
//   //------------------------------------------------------------------------------------
//   final String baseUrl =
//       "https://fir-2c4d8-default-rtdb.asia-southeast1.firebasedatabase.app";

//   Future<List<Todo>> getTodos() async {
    
//     try {
//       final response = await http.get(Uri.parse("$baseUrl/todos.json"));

//       if (response.statusCode != 200) {
//         throw RepositoryException(
//           "Failed to fetch tasks from server (${response.statusCode})",
//         );
//       }
//       //--------------------------------------------------
//       // Firebase returns null if the collection is empty
//       //--------------------------------------------------
//       if (response.body == 'null' || response.body.isEmpty) {
//         return [];
//       }

//       final Map<String, dynamic> data = jsonDecode(response.body);
//       print("STATUS: ${response.statusCode}"); // ADD THIS
//       print("BODY: ${response.body}");

//       return data.entries.map((entry) {
//         return TodoDto.fromJson(entry.key, entry.value as Map<String, dynamic>);
//       }).toList();
//     } catch (e) {
//       if (e is RepositoryException) rethrow;
//       print("REAL ERROR: $e");
//       throw RepositoryException("No wifi !");
//     }
//   }
//   //--------------------------------------------------------------------------

//   Future<void> updateCompleted(String todoId, bool completed) async {
//     //  TODO
//     //  Adapt the code to handle firebase data fetch
//     //
//     final response = await http.get(Uri.parse("$baseUrl/todos.json"));
//     int index = fakeTodos.indexWhere((e) => e.id == todoId);
//     fakeTodos[index] = fakeTodos[index].copyWith(completed);
//     return Future.delayed(Duration(microseconds: 1), () => true);
//   }
  
  
// }