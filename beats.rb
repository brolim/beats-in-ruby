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

  SAMPLE_RATE = 48000

  def play music_key_or_encoded_notes
    print 'generating music wave file... '
    encoded_notes = MUSICS[music_key_or_encoded_notes] || music_key_or_encoded_notes
    generate_wave_file(encoded_notes: encoded_notes)
    puts 'OK'
    system 'ffplay -showmode 1 -f f32le -ar 48000 output.bin'
  end

  def generate_wave_file encoded_notes:, volume: 0.2, output: 'output.bin'
    binary_wave = encoded_notes.map do |encoded_note|
      generate_binary_sound(
        encoded_note: encoded_note,
        duration: 0.3,
        volume: volume
      )
    end

    File.open(output, 'wb') do |file|
      binary_wave.flatten.each { |bin_sample| file.write(bin_sample) }
    end
  end

  def generate_binary_sound encoded_note:, duration:, volume: 1
    samples_to_generate = (duration * SAMPLE_RATE).ceil
    samples = (0 .. samples_to_generate - 1).to_a

    return samples.fill(0) if (encoded_note == '_')

    step = frequency_for_note(encoded_note) * 2 * Math::PI / SAMPLE_RATE
    samples.fill do |i|
      sample =
        if encoded_note == '_'
          0.0
        else
          volume * attack(i, duration) * release(i, duration) * Math.sin(i * step)
        end
      [sample].pack('e') # float32bitsLE
    end
  end

  def frequency_for_note encoded_note
    letter, octave = encoded_note.split('.')
    semitone_number = SEMITONES_BY_LETTER[letter] + 12 * octave.to_i
    440 * (2 ** (1.0 / 12.0)) ** semitone_number
  end

  def attack i, total_duration
    n_samples_attack = 0.05 * SAMPLE_RATE * total_duration
    attack_step = 1.0 / n_samples_attack
    [1.0, i * attack_step].min
  end

  def release i, total_duration
    n_samples = SAMPLE_RATE * total_duration
    n_samples_release = 0.05 * n_samples
    release_step = 1.0 / n_samples_release
    [1.0, release_step * (n_samples - i)].min
  end
end
