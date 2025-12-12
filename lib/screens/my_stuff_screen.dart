import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MyStuffScreen extends StatefulWidget {
  const MyStuffScreen({Key? key}) : super(key: key);

  @override
  State<MyStuffScreen> createState() => _MyStuffScreenState();
}

class _MyStuffScreenState extends State<MyStuffScreen> {
  List<PlatformFile> pickedFiles = [];

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        pickedFiles = result.files;
      });
    }
  }

  Future<void> openFile(PlatformFile file) async {
    final path = file.path;
    if (path == null) return;

    // handle only mobile
    final f = File(path);
    if (await f.exists()) {
      // You can open with external apps later using `open_file` package
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File ready: ${file.name}")),
      );
    }
  }

  Widget _buildFileTile(PlatformFile f) {
    return ListTile(
      leading: const Icon(Icons.insert_drive_file, color: Colors.white),
      title: Text(f.name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        "${(f.size / 1024).toStringAsFixed(1)} KB",
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      onTap: () => openFile(f),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F1A),
        elevation: 0,
        title: const Text("My Stuff"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFiles,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: pickedFiles.isEmpty
          ? Center(
              child: Text(
                "No files added yet",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: pickedFiles.length,
              itemBuilder: (context, index) {
                return _buildFileTile(pickedFiles[index]);
              },
            ),
    );
  }
}
