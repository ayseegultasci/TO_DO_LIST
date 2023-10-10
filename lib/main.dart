import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskList(),
      child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color.fromARGB(197, 96, 206, 233)),
          ),
          debugShowCheckedModeBanner: false,
          title: 'To-Do List App',
          home: TaskItemsUIWidget()),
    );
  }
}

class TaskItemsUIWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskListObject = Provider.of<TaskList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('TO-DO LIST APP'),
      ),
      body: ListView.builder(
        itemCount: taskListObject.tasks.length,
        itemBuilder: (context, index) {
          var mission = taskListObject.tasks[index];
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Color.fromARGB(255, 228, 114, 22),
              child: Icon(Icons.delete),
              alignment: Alignment.centerRight,
            ),
            onDismissed: (direction) {
              var taskListObject =
                  Provider.of<TaskList>(context, listen: false);
              taskListObject.removeTask(mission);
            },
            child: ListWidget(
              mission: mission,
              onRemove: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RemoveTask(mission)));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListWidget extends StatefulWidget {
  Task mission;
  final VoidCallback? onRemove;
  bool isChecked;
  ListWidget({required this.mission, this.onRemove, this.isChecked = false});

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: widget.mission.isChecked,        
          onChanged: (value) {
           setState(() {
             widget.mission.isChecked = value ?? false;
           });
          },
        ),
        title: Text(widget.mission.name),
        subtitle: Text(widget.mission.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.mission.start_date + '-' + widget.mission.end_date),
            if (widget.mission.isChecked)
              Icon(
                Icons.check,
                color: Colors.green,
              ),
          ],
        ),
        onLongPress: () {
          if (widget.onRemove != null) {
            widget.onRemove!();
          }
        },
      ),
    );
  }
}

class Task {
  String name;
  String description;
  String start_date;
  String end_date;
  bool isChecked;

  Task(this.name, this.description, this.start_date, this.end_date,
      this.isChecked);
}

class TaskList with ChangeNotifier {
  List<Task> tasks = [
    Task('Task 1', 'Do your To-Do List App', '07.10.2023', '13.10.2023', false),
    Task('Task 2', 'Read documentation about Flutter', '02.10.2023',
        '21.10.2023', false),
    Task('Task 3', 'Finish your project', '01.10.2023', '18.10.2023', false),
    Task('Task 4', 'Complete the course', '14.10.2023', '18.11.2023', false),
  ];

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }
}

class RemoveTask extends StatefulWidget {
  final Task task;
  RemoveTask(this.task);

  @override
  State<RemoveTask> createState() => _RemoveTaskState();
}

class _RemoveTaskState extends State<RemoveTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remove Task',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            var taskListObject = Provider.of<TaskList>(context, listen: false);
            taskListObject.removeTask(widget.task);
            Navigator.pop(context);
          },
          child: Text('Remove Task'),
        ),
      ),
    );
  }
}

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var taskListObject = Provider.of<TaskList>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Task"),
        ),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Name your task',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                ),
                TextField(
                  controller: startController,
                  decoration: InputDecoration(
                    hintText: 'Starting Date',
                  ),
                ),
                TextField(
                  controller: endController,
                  decoration: InputDecoration(
                    hintText: 'Ending Date',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    var newTask = Task(
                      nameController.text,
                      descriptionController.text,
                      startController.text,
                      endController.text,
                      true,
                    );
                    taskListObject.addTask(newTask);
                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                )
              ],
            )));
  }
}
