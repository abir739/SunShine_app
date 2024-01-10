import 'package:flutter/material.dart';
import 'package:SunShine/modele/tasks/taskModel.dart';
import 'package:SunShine/services/constent.dart';

class TaskView extends StatelessWidget {
  final Tasks task;

  TaskView({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 50.0),
            Text('Détails de la tâche'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 554,
              height: 314,
              margin: EdgeInsets.fromLTRB(9, 0, 7, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://i.pinimg.com/564x/b4/76/8a/b4768a46b886b9935d85895c69f8ce90.jpg",
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(18),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Créé à:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF725E),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    task.createdAt ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 1, 1),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Date à faire :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF725E),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${task.todoDate ?? ''}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 1, 1),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Remarque sur la tâche :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 1, 1),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    task.description ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 70),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit_calendar,
                            size: 35,
                            color: Color(0xFF3A3557),
                          ),
                          onPressed: () {
                            // Implement edit functionality here
                          },
                        ),
                      ),
                      SizedBox(width: 40),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            size: 35,
                            color: Color(0xFF3A3557),
                          ),
                          onPressed: () {
                            // Implement edit functionality here
                          },
                        ),
                      ),
                      SizedBox(width: 40),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.add_task,
                            size: 35,
                            color: Color(0xFF3A3557),
                          ),
                          onPressed: () {
                            // Implement edit functionality here
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageList(List<String>? images) {
    if (images == null || images.isEmpty) {
      return Text('No images available.');
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("${baseUrls}${images[index]}"),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
