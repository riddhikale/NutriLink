import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<String?> recordAudio() async {
    try {
      if (await _recorder.hasPermission()) {

        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/voice.wav';

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 16000,
            numChannels: 1,
            bitRate: 128000,
          ),
          path: path,
        );

        print("Recording started...");

        await Future.delayed(const Duration(seconds: 5));

        final recordedPath = await _recorder.stop();

        print("Recording saved at: $recordedPath");

        return recordedPath;
      }
    } catch (e) {
      print("Recording error: $e");
    }

    return null;
  }
}