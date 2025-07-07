import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stealth Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const FirebaseDemoPage(),
    );
  }
}

class FirebaseDemoPage extends StatefulWidget {
  const FirebaseDemoPage({super.key});

  @override
  State<FirebaseDemoPage> createState() => _FirebaseDemoPageState();
}

class _FirebaseDemoPageState extends State<FirebaseDemoPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("test_data");
  final TextEditingController _controller = TextEditingController();
  String _fetchedValue = "";

  void _writeToFirebase() async {
    final value = _controller.text.trim();
    if (value.isNotEmpty) {
      await _dbRef.set({"message": value});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data written: $value")),
      );
    }
  }

  void _readFromFirebase() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      setState(() {
        _fetchedValue = snapshot.child("message").value.toString();
      });
    } else {
      setState(() {
        _fetchedValue = "No data found.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Realtime DB Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter message",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _writeToFirebase,
              child: const Text("Write to Firebase"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _readFromFirebase,
              child: const Text("Read from Firebase"),
            ),
            const SizedBox(height: 24),
            Text(
              "Fetched from Firebase: $_fetchedValue",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}