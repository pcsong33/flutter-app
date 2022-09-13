import 'package:flutter/material.dart';

// instantiate TODO class
class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

// Create TodoItem Widget
class TodoItem extends StatelessWidget {
  // pass a Todo to the TodoItem Widget
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  // check if todo is checked or not
  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      leading: CircleAvatar(
        child: Text(todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}

// Call a state an render the list of todos
class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => new _TodoListState();
}

// State of the list of todos: contains list logic for todo app
class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldController = TextEditingController();
  
  // initialize list of todos
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    // return a scaffold for the application, with an appBar that holds title
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo list'),
      ),
      // map all the todos in a state and return a 'TOODOItem' 
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  // display dialogue to add new todo
  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      // render a textfield widget
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

// TodoApp is a Stateless widget - leveraged basic material app for styling
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo list',
      home: new TodoList(),
    );
  }
}

void main() => runApp(new TodoApp());