import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Teacher/Profile_Teacher.dart';

class listteachers extends StatefulWidget {
  const listteachers({super.key});
  static const screenroute = 'listteachers';

  @override
  State<listteachers> createState() => _ListTeachersState();
}

class _ListTeachersState extends State<listteachers> {
  String AcademicLevel = '0';
  String numClass = '1';

  void _removeUser(String userId) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .delete()
        .then((_) {
      // Handle success, maybe show a message or update UI
    }).catchError((error) {
      // Handle errors
      print("Error removing user: $error");
    });
  }

  void _showDeleteConfirmationDialog(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text('Are you sure you want to delete this user?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _removeUser(userId); // Call the method to remove the user
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8576FF),
        title: const Text('List teachers',
            style: TextStyle(color: Colors.white, fontSize: 30)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFF614BC3),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 25),
                    child: Text(
                      'First Name' '         Last Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5, left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: DropdownButton<String>(
                          value: AcademicLevel,
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 2, right: 1),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Color(0xFF614BC3), // Desired color for the icon
                                BlendMode.srcIn,
                              ),
                              child: Icon(
                                Icons.menu,
                                size: 15,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                              color: Color(0xFF614BC3), fontSize: 8),
                          underline: Container(
                            height: 2,
                            color: const Color(0xFF614BC3),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              AcademicLevel = newValue!;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: '0',
                              child: Text('Academic Level 0'),
                            ),
                            DropdownMenuItem(
                              value: '1',
                              child: Text('Academic Level 1'),
                            ),
                            DropdownMenuItem(
                              value: '2',
                              child: Text('Academic Level 2'),
                            ),
                            DropdownMenuItem(
                              value: '3',
                              child: Text('Academic Level 3'),
                            ),
                            DropdownMenuItem(
                              value: '4',
                              child: Text('Academic Level 4'),
                            ),
                            DropdownMenuItem(
                              value: '5',
                              child: Text('Academic Level 5'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Users').snapshots(),
              builder: (context, snapshot) {
                List<Widget> teacherWidgets = [];
                if (snapshot.hasData) {
                  final users = snapshot.data!.docs.toList();
                  for (var user in users) {
                    if (user['role'] == 'Teacher' &&
                        user['Academiclevel'] == AcademicLevel) {
                      final teacherWidget = Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                width: 250,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color(0xFF33BBC5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 25),
                                  child: Text(
                                    '${user['firstname']}                 ${user['lastname']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return ProfileTeacherPage(profileId: user.id);
                                }));
                              },
                              icon: const Icon(Icons.supervised_user_circle),
                              iconSize: 30, // Adjust icon size as needed
                            ),
                            SizedBox(
                              width: 30,
                              child: IconButton(
                                onPressed: () {
                                  _showDeleteConfirmationDialog(user.id);
                                },
                                icon: const Icon(Icons.delete_forever),
                                iconSize: 30, // Adjust icon size as needed
                              ),
                            ),
                          ],
                        ),
                      );
                      teacherWidgets.add(teacherWidget);
                    }
                  }
                }

                return Expanded(
                  child: ListView(
                    children: teacherWidgets,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}