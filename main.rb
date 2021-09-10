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

  def generate_sound encoded_note:, duration:, sample_rate: 48000, volume: 1
    samples_to_generate = (duration * sample_rate).to_i

    if (encoded_note == '_')
      puts '---'
      return samples_to_generate.times.map { |_| 0 }
    end

    puts encoded_note

    semitone_number = SEMITONES_BY_LETTER[encoded_note[0]]
    semitone_number += SEMITONES_BY_LETTER.size * encoded_note[1].to_i
    frequency = 440 * (2 ** (1.0 / 12.0)) ** semitone_number
    step = frequency * 2 * Math::PI / sample_rate

    samples_to_generate
      .times
      .map do |i|
        sample = encoded_note == '_' ? 0 : volume * Math.sin(i * step)
        [sample].pack('e')
      end
  end

  def play
    music =  'C0 C0 G0 G0 A1 A1 G0 _ '
    music +=  'F0 F0 E0 E0 D0 D0 C0 _ '

    music +=  'G0 G0 F0 F0 E0 E0 D0 _ '
    music +=  'G0 G0 F0 F0 E0 E0 D0 _ '

    music +=  'C0 C0 G0 G0 A1 A1 G0 _ '
    music +=  'F0 F0 E0 E0 D0 D0 C0 _ '

    binary_wave = music.split(' ').map do |encoded_note|
      generate_sound(
        encoded_note: encoded_note,
        duration: 0.5,
        volume: 0.20
      )
    end

    File.open('output.bin', 'wb') do |file|
      binary_wave
        .flatten
        .each { |packed_sample| file.write(packed_sample) }
    end
    system 'ffplay -showmode 1 -f f32le -ar 48000 output.bin'
  end
end

beats = Beats.new
beats.play
