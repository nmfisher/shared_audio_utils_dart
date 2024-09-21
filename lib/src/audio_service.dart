import 'dart:io';
import 'package:logging/logging.dart';
import 'dart:typed_data';
import 'dart:async';

enum AudioSource { Asset, File }

enum AudioEncoding {
  PCM16(name: 'PCM16', bitsPerSample: 16),
  PCMF32(name: 'PCMF32', bitsPerSample: 32),
  OGG(name: 'OGG'),
  OPUS(name: 'OPUS'),
  MP3(name: 'MP3'),
  WAV(name: 'WAV'),
  M4A(name: 'M4A');

  const AudioEncoding({
    required this.name,
    this.bitsPerSample,
    this.sampleRate,
  });

  final String name;
  final int? bitsPerSample;
  final int? sampleRate;

  bool get isPCM => this == AudioEncoding.PCM16 || this == AudioEncoding.PCMF32;

  static AudioEncoding fromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'ogg':
        return AudioEncoding.OGG;
      case 'opus':
        return AudioEncoding.OPUS;
      case 'mp3':
        return AudioEncoding.MP3;
      case 'wav':
        return AudioEncoding.WAV;
      case 'm4a':
        return AudioEncoding.M4A;
      default:
        throw ArgumentError('Unsupported file extension: $extension');
    }
  }

  AudioEncoding withSampleRate(int sampleRate) {
    return AudioEncoding.values.firstWhere(
      (e) => e.name == this.name,
      orElse: () => throw StateError('Invalid enum value'),
    );
  }
}


abstract class AudioService {
  Logger get log => Logger(this.runtimeType.toString());

  Future initialize();

  void dispose();

  ///
  ///
  ///
  Future<Duration> getDuration(Uint8List data, AudioEncoding encoding);

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
    void Function()? onBegin,
    void Function()? onComplete,
    int sampleRate = 16000,
    double speed = 1.0,
  });

  ///
  /// Plays the audio contained in [data] encoded with [encoding].
  /// [start] must be a double between 0.0 and 1.0, representing the fraction of the audio length at which to start playing.
  ///
  Future<void Function()> playBuffer(Uint8List data,
      {void Function()? onBegin,
      void Function()? onComplete,
      AudioEncoding encoding = AudioEncoding.PCM16,
      int? sampleRate,
      bool? stereo,
      double? start});

  ///
  /// Plays the 16 bit PCM audio contained in [data].
  ///
  Future playStream(Stream<Uint8List> data, int frequency, bool stereo,
      {void Function()? onComplete});

  ///
  /// Decodes the provided audio based on the specified file extension.
  ///
  Future<Uint8List> decode(Uint8List encoded, {String extension = "opus"});
}
