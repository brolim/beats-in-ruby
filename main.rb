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

  def play music_key
    print 'generating music wave file... '
    binary_wave = MUSICS[music_key].map do |encoded_note|
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
    puts 'OK'

    puts 'playing on ffplay... '
    system 'ffplay -showmode 1 -f f32le -ar 48000 output.bin'
    puts 'done'
  end

  def generate_sound encoded_note:, duration:, sample_rate: 48000, volume: 1
    samples_to_generate = (duration * sample_rate).to_i
    return samples_to_generate.times.map { 0 } if (encoded_note == '_')

    step = frequency_for_note(encoded_note) * 2 * Math::PI / sample_rate
    (0 .. samples_to_generate).map do |i|
      sample = encoded_note == '_' ? 0.0 : volume * Math.sin(i * step)
      [sample].pack('e')
    end
  end

  def frequency_for_note encoded_note
    letter, octave = encoded_note.split('.')
    semitone_number = SEMITONES_BY_LETTER[letter] + 12 * octave.to_i
    440 * (2 ** (1.0 / 12.0)) ** semitone_number
  end
end

beats = Beats.new
beats.play(:brilha_brilha_estrelinha)
