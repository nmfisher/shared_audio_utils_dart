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
