require_relative 'sound'

class Note < Sound
  attr_accessor :note
  attr_accessor :octave
  attr_accessor :duration
  attr_accessor :volume
  attr_accessor :times
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

  def initialize(
    note: 'A',
    octave: 0,
    duration: 1.0,
    volume: 0.5,
    times: 1,
    release_size: 0.10
  )
    @note = note
    @octave = octave
    @duration = duration
    @volume = volume
    @times = times
    @release_size = release_size || 0.10
  end

  def samples
    samples_to_generate = (@duration * SAMPLE_RATE).ceil
    samples = (0 .. samples_to_generate - 1).to_a

    return samples.fill(0) if (@note == '_')

    step = frequency * 2 * Math::PI / SAMPLE_RATE
    samples.fill do |i|
      @volume * attack(i) * release(i) * Math.sin(i * step)
    end

    samples = @times.times.map { samples }.flatten if (@times > 1)
    samples
  end

  def frequency
    semitone_number = SEMITONE_BY_LETTER[@note] + 12 * @octave
    440 * (2 ** (1.0 / 12.0)) ** semitone_number
  end

  def attack i
    n_samples_attack = 0.13 * SAMPLE_RATE * @duration
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
    times: 1,
    octave_offset: 0,
    release_size: nil
  )
    note_attrs = decode(encoded_note, octave_offset.to_i).merge(
      duration: duration,
      volume: volume,
      times: times,
      release_size: release_size
    )
    Note.new(**note_attrs)
  end

  def self.decode encoded_note, octave_offset = 0
    # encoded_note examples: 'A.0' || 'C.1' || 'D' || 'G#.1' || ...]
    note, octave = encoded_note.split('.')
    {
      note: note,
      octave: octave.to_i + octave_offset
    }
  end

  def encode octave_offset = 0
    "#{ note }.#{ octave + octave_offset }"
  end

  def to_hash octave_offset = 0
    {
      note: note,
      octave: octave.to_i + octave_offset,
      duration: duration,
      volume: volume,
      times: times,
      release_size: release_size
    }
  end
end
