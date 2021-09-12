require 'fftw3'
require 'byebug'

class Beats
  SEMITONE_BY_LETTER = {
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

  LETTER_BY_SEMITONE = SEMITONE_BY_LETTER.invert

  SCALES = {
    major: [0, 2, 4, 5, 7, 9, 11, 12],
    minor: [0, 2, 3, 5, 7, 8, 10, 12]
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

  def mix *signals
    greatest_volume = 0.0
    mixed_signal = signals.map(&:size).max.times.map do |i|
      mixed_sample = signals.map { |signal| signal[i].to_f }.sum
      greatest_volume = mixed_sample.abs if mixed_sample.abs > greatest_volume
      mixed_sample
    end

    if greatest_volume > 1.0
      mixed_signal.map { |mixed_sample| mixed_sample.to_f / greatest_volume }
    else
      mixed_signal
    end
  end

  def play key_or_encoded_notes, scale_key = nil
    print 'generating music wave file... '
    encoded_notes = MUSICS[key_or_encoded_notes] || scale(key_or_encoded_notes, scale_key) || key_or_encoded_notes.flatten
    generate_wave_file(encoded_notes: encoded_notes)
    puts 'OK'
    system 'ffplay -showmode 1 -f f32le -ar 48000 output.bin'
  end

  def scale encoded_note, scale_key
    return if !encoded_note.is_a?(String)

    letter, octave = encoded_note.split('.')
    return if !SEMITONE_BY_LETTER[letter] || !SCALES[scale_key]

    initial_semitone = SEMITONE_BY_LETTER[letter]
    semitones = SCALES[scale_key].map do |scale_semitone|
      initial_semitone + scale_semitone + 12 * octave.to_i
    end

    semitones.map do |semitone|
      octave = (semitone.to_f / 12).floor
      letter =  LETTER_BY_SEMITONE[semitone % 12]
      "#{letter}.#{octave}"
    end
  end

  def generate_wave_file encoded_notes:, volume: 1, output: 'output.bin'
    signal = encoded_notes.map do |encoded_note|
      if encoded_note.is_a?(String)
        generate_signal(
          encoded_note: encoded_note,
          duration: 0.8,
          volume: volume
        )
      else
        encoded_note
      end
    end

    File.open(output, 'wb') do |file|
      signal.flatten.each do |sample|
        bin_sample = [sample].pack('e') # float32bitsLE
        file.write(bin_sample)
      end
    end
  end

  def generate_signal encoded_note:, duration:, volume: 1
    samples_to_generate = (duration * SAMPLE_RATE).ceil
    samples = (0 .. samples_to_generate - 1).to_a

    return samples.fill(0) if (encoded_note == '_')

    step = frequency_for_note(encoded_note) * 2 * Math::PI / SAMPLE_RATE
    samples.fill do |i|
      if encoded_note == '_'
        0.0
      else
        volume * attack(i, duration) * release(i, duration) * Math.sin(i * step)
      end
    end
  end

  def frequency_for_note encoded_note
    letter, octave = encoded_note.split('.')
    semitone_number = SEMITONE_BY_LETTER[letter] + 12 * octave.to_i
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
