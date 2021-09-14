require 'byebug'

class Chord
  attr_accessor :letter
  attr_accessor :chord_type
  attr_accessor :octave
  attr_accessor :duration
  attr_accessor :volume

  NOTES_BY_CHORD_TYPE = {
    major: [0, 4, 7],
    minor: [0, 3, 7],
    dominant_seventh: [0, 4, 7, -2],
  }

  def initialize(
    letter = 'A',
    chord_type = :major,
    octave: 0,
    duration: 1.0,
    volume: 0.5
  )
    @letter = letter
    @chord_type = chord_type
    @octave = octave
    @duration = duration
    @volume = volume
  end

  def samples
    initial_semitone = MusicalNote::SEMITONE_BY_LETTER[@letter]
    semitones = NOTES_BY_CHORD_TYPE[@chord_type].map do |base_semitone|
      base_semitone + initial_semitone.to_i
    end

    print "Chord #{@letter}#{formatted_chord_type} (#{@octave}): "
    sets_of_samples = semitones.map do |semitone|
      letter = initial_semitone ? MusicalNote::LETTER_BY_SEMITONE[semitone % 12] : '_'
      print "#{letter} "
      note = MusicalNote.new(
        letter: letter,
        octave: @octave,
        duration: @duration,
        volume: @volume,
      )
      note.samples
    end
    puts ''
    SoundWave.mix(*sets_of_samples)
  end

  def formatted_chord_type
    case @chord_type
      when :major then return ''
      when :minor then return 'm'
      else return "wrong ct: #{@chord_type}"
    end
  end

  def self.build_many(
    encoded_chords,
    chord_duration: 0.5,
    volume: 0.5,
    octave_offset: 0
  )
    encoded_chords.flatten.map do |encoded_chord|
      build_one(
        encoded_chord,
        duration: chord_duration,
        volume: volume,
        octave_offset: octave_offset
      )
    end
  end

  def self.build_one(
    encoded_chord,
    duration: 0.5,
    volume: 0.5,
    octave_offset: 0
  )
    letter, octave, chord_type = encoded_chord.split('.')
    Chord.new(
      letter,
      :"#{chord_type || 'major'}",
      octave: octave.to_i + octave_offset,
      duration: duration,
      volume: volume
    )
  end
end
