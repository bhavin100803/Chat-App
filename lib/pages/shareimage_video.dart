
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndShareImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
    print("hiii");
      // Share the image
      Share.shareXFiles([image], text: 'Check out this image!');
    }
  }

  Future<void> _pickAndShareVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      // Share the video
      Share.shareXFiles([video], text: 'Check out this video!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Share video and photo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickAndShareImage,
              child: Text('Pick and Share Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAndShareVideo,
              child: Text('Pick and Share Video'),
            ),
          ],
        ),
      ),
    );
  }
}