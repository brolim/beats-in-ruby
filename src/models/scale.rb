require_relative 'sound'
require 'byebug'

class Scale < Sound
  attr_accessor :note
  attr_accessor :scale_type
  attr_accessor :number_of_notes
  attr_accessor :octave
  attr_accessor :note_duration
  attr_accessor :volume

  def initialize(
    note: 'A',
    scale_type: :major,
    number_of_notes: 8,
    octave: 0,
    note_duration: 1,
    volume: 1.0
  )
    @note = note
    @scale_type = scale_type
    @number_of_notes = number_of_notes
    @octave = octave
    @note_duration = note_duration
    @volume = volume
  end
  
  SCALES_BY_TYPE = {
    major: [0, 2, 4, 5, 7, 9, 11, 12],
    minor: [0, 2, 3, 5, 7, 8, 10, 12]
  }

  def samples
    build_notes.map(&:samples).flatten
  end

  def track_sequence
    build_notes.map { |note| note.to_hash(octave) }
  end

  def build_notes
    return if !Note::SEMITONE_BY_LETTER[note] || !SCALES_BY_TYPE[scale_type]
    
    # include 8 notes
    initial_semitone = Note::SEMITONE_BY_LETTER[note]
    semitones = SCALES_BY_TYPE[scale_type].map do |scale_semitone|
      initial_semitone + scale_semitone + 12 * octave
    end

    # include 8 more notes each time loop runs to reach asked `number_of_notes`
    positive_semitones = SCALES_BY_TYPE[scale_type][1..-1]
    while semitones.size < number_of_notes
      semitones += positive_semitones.map do |semitone_increment|
        semitones.last + semitone_increment
      end
    end

    # cut semitones to the asked `number_of_notes` 
    semitones[0..number_of_notes].map do |semitone|
      octave = (semitone.to_f / 12).ceil
      note =  Note::LETTER_BY_SEMITONE[semitone % 12]
      Note.new(
        note: note,
        octave: octave,
        duration: note_duration,
        volume: volume,
      )
    end
  end

  def self.build_sequence note, scale_type, number_of_notes: 8, octave: 0, note_duration: 0.5, volume: 0.5

  end
end
