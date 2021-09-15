class Note
  attr_accessor :letter
  attr_accessor :octave
  attr_accessor :duration
  attr_accessor :volume
  attr_accessor :release_size

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
    'G#' => 11,

    'Ab' => -1,
    'Bb' =>  1,
    'Cb' =>  2,
    'Db' =>  4,
    'Eb' =>  6,
    'Fb' =>  7,
    'Gb' =>  9,
  }
  LETTER_BY_SEMITONE = SEMITONE_BY_LETTER.invert.merge(-2 => 'G#')
  SAMPLE_RATE = 44100
  SCALES = {
    major: [0, 2, 4, 5, 7, 9, 11, 12],
    minor: [0, 2, 3, 5, 7, 8, 10, 12]
  }

  def initialize(letter: 'A', octave: 0, duration: 1.0, volume: 0.5, release_size: 0.10)
    @letter = letter
    @octave = octave
    @duration = duration
    @volume = volume
    @release_size = release_size || 0.10
  end

  def samples
    samples_to_generate = (@duration * SAMPLE_RATE).ceil
    samples = (0 .. samples_to_generate - 1).to_a

    return samples.fill(0) if (@letter == '_')

    step = frequency * 2 * Math::PI / SAMPLE_RATE
    samples.fill do |i|
      @volume * attack(i) * release(i) * Math.sin(i * step)
    end
  end

  def frequency
    semitone_number = SEMITONE_BY_LETTER[@letter] + 12 * @octave
    440 * (2 ** (1.0 / 12.0)) ** semitone_number
  end

  def attack i
    n_samples_attack = 0.05 * SAMPLE_RATE * @duration
    attack_step = 1.0 / n_samples_attack
    [1.0, i * attack_step].min
  end

  def release i
    n_samples = SAMPLE_RATE * @duration
    n_samples_release = @release_size * n_samples
    release_step = 1.0 / n_samples_release
    [1.0, release_step * (n_samples - i)].min
  end

  def self.build_many(
    encoded_notes,
    note_duration: 0.5,
    volume: 0.5,
    octave_offset: 0,
    release_size: nil
  )
    encoded_notes.flatten.map do |encoded_note|
      build_one(
        encoded_note,
        duration: note_duration,
        volume: volume,
        octave_offset: octave_offset,
        release_size: release_size
      )
    end
  end

  def self.build_one(
    encoded_note,
    duration: 0.5,
    volume: 0.5,
    octave_offset: 0,
    release_size: nil
  )
    letter, octave = encoded_note.split('.')
    Note.new(
      letter: letter,
      octave: octave.to_i + octave_offset,
      duration: duration,
      volume: volume,
      release_size: release_size
    )
  end

  def self.build_many_for_scale letter, scale_key, number_of_notes: 8, octave: 0, note_duration: 0.5, volume: 0.5
    return if !SEMITONE_BY_LETTER[letter] || !SCALES[scale_key]

    initial_semitone = SEMITONE_BY_LETTER[letter]
    semitones = SCALES[scale_key].map do |scale_semitone|
      initial_semitone + scale_semitone + 12 * octave
    end

    positive_semitones = SCALES[scale_key][1..-1]
    while semitones.size < number_of_notes
      semitones += positive_semitones.map { |semitone| semitones.last + semitone }
    end

    semitones[0..number_of_notes].map do |semitone|
      octave = (semitone.to_f / 12).floor
      letter =  LETTER_BY_SEMITONE[semitone % 12]
      Note.new(
        letter: letter,
        octave: octave + octave,
        duration: note_duration,
        volume: volume,
      )
    end
  end
end
