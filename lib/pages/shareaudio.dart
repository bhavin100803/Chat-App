import 'dart:io';

import 'package:chatapp/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class Shareaudio extends StatefulWidget {
  const Shareaudio({super.key});

  @override
  State<Shareaudio> createState() => _ShareaudioState();
}

class _ShareaudioState extends State<Shareaudio> {

  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer  audioPlayer = AudioPlayer();

  String? recordingPath;
  bool isRecording = false, isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _recordingButton(),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (recordingPath != null)
            MaterialButton(
              onPressed: () async{
                if(audioPlayer.playing){
                  audioPlayer.stop();
                  setState(() {
                    isPlaying = false;
                  });
                }else{
                  await audioPlayer.setFilePath(recordingPath!);
                  audioPlayer.play();
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              color: color.secondcolor,
              child: Text(isPlaying ? "Stop Playing Recording" : "Start Playing Recording"),
            ),
          if (recordingPath == null) const Text("No Recording Found"),
        ],
      ),
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          String? filePath = await audioRecorder.stop();
          if (filePath != null) {
            setState(() {
              isRecording = false;
              recordingPath = filePath;
            });
          }
        } else {
          if (await audioRecorder.hasPermission()) {
            final Directory appDocumentsDir =
                await getApplicationDocumentsDirectory();
            final String filePath =
                p.join(appDocumentsDir.path, "recording.wav");
            await audioRecorder.start(const RecordConfig(), path: filePath);
            setState(() {
              isRecording = true;
              recordingPath = null;
            });
          }
        }
      },
      child: Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }
}
