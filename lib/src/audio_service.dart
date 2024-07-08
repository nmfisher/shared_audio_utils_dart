import 'dart:io';
import 'package:logging/logging.dart';
import 'dart:typed_data';
import 'dart:async';

enum AudioSource { Asset, File }

enum AudioEncoding { PCM16, OGG, OPUS, MP3 }

abstract class AudioService {
  Logger get log => Logger(this.runtimeType.toString());

  Future initialize();

  void dispose();

  ///
  /// Loads (but does not decode) the audio located at the specified [path] (interpreted as either a file or asset path, depending on [source])
  ///
  Future<Uint8List> load(String path,
      {AudioSource source = AudioSource.File,
      String? package,
      Function? onBegin,
      int sampleRate = 16000});

  ///
  /// Plays the audio located at the specified [path] (interpreted as either a file or asset path, depending on [source])
  ///
  Future play(
    String path, {
    AudioSource source = AudioSource.File,
    String? package,
    Function? onBegin,
    Function? onComplete,
    int sampleRate = 16000,
    double speed = 1.0,
  });

  ///
  /// Plays the audio contained in [data] encoded with [encoding].
  ///
  Future<void Function()> playBuffer(Uint8List data, int frequency, bool stereo,
      {void Function()? onComplete, AudioEncoding encoding = AudioEncoding.PCM16});

  ///
  /// Plays the 16 bit PCM audio contained in [data].
  ///
  Future playStream(
      Stream<Uint8List> data, int frequency, bool stereo, 
      {void Function()? onComplete});

  ///
  /// Decodes the provided audio based on the specified file extension.
  ///
  Future<Uint8List> decode(Uint8List encoded, {String extension = "opus"});
}
