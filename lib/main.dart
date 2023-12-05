import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_study/widgets/text_field_widget.dart';

part 'widgets/edit_data_sheet_widget.dart';
part 'widgets/data_sheet_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseFirestore db;

  String name = '';
  int id = -1;
  String classC = '';

  String nameField = '';
  int num = -1;
  bool boolC = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    db = FirebaseFirestore.instance;
    final firstDoc = db.collection('first_collection').doc('first_document');
    firstDoc.get().then((value) {
      if (value.data() != null) {
        setState(() {
          name = value.data()!['name'];
          id = value.data()!['id'];
          classC = value.data()!['class'];
        });
      }
    });

    final secondDoc = db
        .collection('first_collection')
        .doc('second_document')
        .collection('collection_inside_doc')
        .doc('Doc A');
    secondDoc.get().then((value) {
      if (value.data() != null) {
        setState(() {
          nameField = value.data()!['Name'];
          num = value.data()!['test_num'];
          boolC = value.data()!['test_bool'];

          // timestamp = value.data()!['test_timestamp'];
          // timestampC = DateFormat('dd MMMM yyyy, HH:mm').format(
          //     DateTime.fromMillisecondsSinceEpoch(
          //         timestamp.millisecondsSinceEpoch));

          // array = value.data()!['test_array'].cast<String>();
          // arrayC = '';
          // for (var i = 0; i < array.length; i++) {
          //   arrayC = '${array[i]}, $arrayC';
          // }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Firestore App'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      id.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      classC,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  width: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final firstDoc = db
                          .collection('first_collection')
                          .doc('first_document');
                      firstDoc.delete().then((value) => _init());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    )),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: _EditSheet(
                                name: name,
                                id: id.toString(),
                                classC: classC,
                              ),
                            );
                          }).then((value) {
                        _init();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Center(
                        child: Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'I have these data on my firestore database',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            _DataWidget(
              title: 'Field name: ',
              body: nameField,
            ),
            _DataWidget(
              title: 'Field bool :',
              body: boolC.toString(),
            ),
            _DataWidget(
              title: 'Field num: ',
              body: num.toString(),
            ),
            // _DataWidget(
            //   title: 'Field timestamp: ',
            //   body: timestampC,
            // ),
            // _DataWidget(
            //   title: 'Field array: ',
            //   body: arrayC,
            // ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    useSafeArea: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: _EditDataSheet(
                          name: nameField,
                          boolC: boolC,
                          num: num,
                        ),
                      );
                    }).then((value) {
                  _init();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      50), // Choose any value based on your needs
                ),
              ),
              child: const Center(
                  child: Text(
                'Edit data',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              )),
            ),
            const Expanded(child: SizedBox()),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _DataWidget extends StatelessWidget {
  const _DataWidget({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Text(
          body,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Divider(),
      ],
    );
  }
}
