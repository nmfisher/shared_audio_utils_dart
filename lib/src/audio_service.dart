import 'package:logging/logging.dart';
import 'dart:typed_data';
import 'dart:async';

import 'audio_encoding.dart';

enum AudioSource { Asset, File }

typedef CancelPlayback = Future Function();

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
  Future<CancelPlayback> play(
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
  Future<CancelPlayback> playBuffer(Uint8List data,
      {void Function()? onBegin,
      void Function()? onComplete,
      AudioEncoding encoding = const PCM16(sampleRate: 44100),
      int? sampleRate,
      bool? stereo,
      double? start});

  ///
  /// Plays the 16 bit PCM audio contained in [data].
  ///
  Future<CancelPlayback> playStream(Stream<Uint8List> data, int frequency, bool stereo,
      {void Function()? onComplete});

  ///
  /// Decodes the provided audio based on the specified file extension.
  ///
  Future<Uint8List> decode(Uint8List encoded, {String extension = "opus"});
}
