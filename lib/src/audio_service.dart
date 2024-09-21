import 'package:logging/logging.dart';
import 'dart:typed_data';
import 'dart:async';

enum AudioSource { Asset, File }

sealed class AudioEncoding {
  final String name;
  final int? bitsPerSample;
  final int? sampleRate;

  const AudioEncoding({
    required this.name,
    this.bitsPerSample,
    this.sampleRate,
  });

  bool get isPCM => this is PCM16 || this is PCMF32;

  static AudioEncoding fromExtension(String extension, {int? sampleRate}) {
    switch (extension.toLowerCase()) {
      case 'ogg':
        return OGG(sampleRate: sampleRate);
      case 'opus':
        return OPUS(sampleRate: sampleRate);
      case 'mp3':
        return MP3(sampleRate: sampleRate);
      case 'wav':
        return WAV(sampleRate: sampleRate);
      case 'm4a':
        return M4A(sampleRate: sampleRate);
      default:
        throw ArgumentError('Unsupported file extension: $extension');
    }
  }

  AudioEncoding withSampleRate(int sampleRate);
}

class PCM16 extends AudioEncoding {
  const PCM16({int? sampleRate}) : super(name: 'PCM16', bitsPerSample: 16, sampleRate: sampleRate);

  @override
  PCM16 withSampleRate(int sampleRate) => PCM16(sampleRate: sampleRate);
}

class PCMF32 extends AudioEncoding {
  const PCMF32({int? sampleRate}) : super(name: 'PCMF32', bitsPerSample: 32, sampleRate: sampleRate);

  @override
  PCMF32 withSampleRate(int sampleRate) => PCMF32(sampleRate: sampleRate);
}

class OGG extends AudioEncoding {
  const OGG({int? sampleRate}) : super(name: 'OGG', sampleRate: sampleRate);

  @override
  OGG withSampleRate(int sampleRate) => OGG(sampleRate: sampleRate);
}

class OPUS extends AudioEncoding {
  const OPUS({int? sampleRate}) : super(name: 'OPUS', sampleRate: sampleRate);

  @override
  OPUS withSampleRate(int sampleRate) => OPUS(sampleRate: sampleRate);
}

class MP3 extends AudioEncoding {
  const MP3({int? sampleRate}) : super(name: 'MP3', sampleRate: sampleRate);

  @override
  MP3 withSampleRate(int sampleRate) => MP3(sampleRate: sampleRate);
}

class WAV extends AudioEncoding {
  const WAV({int? sampleRate}) : super(name: 'WAV', sampleRate: sampleRate);

  @override
  WAV withSampleRate(int sampleRate) => WAV(sampleRate: sampleRate);
}

class M4A extends AudioEncoding {
  const M4A({int? sampleRate}) : super(name: 'M4A', sampleRate: sampleRate);

  @override
  M4A withSampleRate(int sampleRate) => M4A(sampleRate: sampleRate);
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
      AudioEncoding encoding = const PCM16(sampleRate: 44100),
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
