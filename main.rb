class Beats
  SEMITONES_BY_LETTER = {
    'A'  =>  0,
    'A#' =>  1,
    'B'  =>  2,
    'C'  =>  3,
    'C#' =>  4,
    'D'  =>  5,
    'D#' =>  6,
    'E'  =>  7,
    'F'  =>  8,
    'F#' =>  9,
    'G'  => 10,
    'G#' => 11
  }

  MUSICS = {
    brilha_brilha_estrelinha: %w[
      C.0 C.0 G.0 G.0 A.1 A.1 G.0 _
      F.0 F.0 E.0 E.0 D.0 D.0 C.0 _
      G.0 G.0 F.0 F.0 E.0 E.0 D.0 _
      G.0 G.0 F.0 F.0 E.0 E.0 D.0 _
      C.0 C.0 G.0 G.0 A.1 A.1 G.0 _
      F.0 F.0 E.0 E.0 D.0 D.0 C.0 _
    ]
  }

  def play music_key_or_encoded_notes
    print 'generating music wave file... '
    encoded_notes = MUSICS[music_key_or_encoded_notes] || music_key_or_encoded_notes
    generate_wave_file(encoded_notes: encoded_notes)
    puts 'OK'
    system 'ffplay -showmode 1 -f f32le -ar 48000 output.bin'
  end

  def generate_wave_file encoded_notes:, volume: 0.2
    binary_wave = encoded_notes.map do |encoded_note|
      generate_binary_sound(
        encoded_note: encoded_note,
        duration: 0.5,
        volume: volume
      )
    end

    File.open('output.bin', 'wb') do |file|
      binary_wave.flatten.each do |packed_sample|
        file.write(packed_sample)
      end
    end
  end

  def generate_binary_sound encoded_note:, duration:, sample_rate: 48000, volume: 1
    samples_to_generate = (duration * sample_rate).to_i
    return samples_to_generate.times.map { 0 } if (encoded_note == '_')

    step = frequency_for_note(encoded_note) * 2 * Math::PI / sample_rate

    attack_step = 0.001
    attack_nsamples = (1.0 / attack_step).to_i
    attack = (0 .. attack_nsamples - 1).map { |i| i * attack_step }

    release = attack.reverse

    raw_samples = (0 .. samples_to_generate - 1).map do |i|
      if encoded_note == '_'
        0.0
      else
        vol =
          if i < attack.size
            volume * attack[i]
          elsif samples_to_generate - i < release.size
            volume * release[samples_to_generate - i]
          else
            volume
          end
        vol * Math.sin(i * step)
      end
    end

    raw_samples.map { |sample| [sample].pack('e') }
  end

  def frequency_for_note encoded_note
    letter, octave = encoded_note.split('.')
    semitone_number = SEMITONES_BY_LETTER[letter] + 12 * octave.to_i
    440 * (2 ** (1.0 / 12.0)) ** semitone_number
  end
end

beats = Beats.new
beats.play(:brilha_brilha_estrelinha)
