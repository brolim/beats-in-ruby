require_relative 'sound'
require 'byebug'

class Chord < Sound
  attr_accessor :note
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
    note:,
    chord_type: :major,
    octave: 0,
    duration: 1.0,
    volume: 0.5,
    times: 1
  )
    @note = note
    @chord_type = chord_type
    @octave = octave
    @duration = duration
    @volume = volume
    @times = times
  end

  def samples
    initial_semitone = Note::SEMITONE_BY_LETTER[@note]
    semitones = NOTES_BY_CHORD_TYPE[@chord_type].map do |base_semitone|
      base_semitone + initial_semitone.to_i
    end

    print "#{ @times }x #{formatted_chord} (#{@octave}): "
    sets_of_samples = semitones.map do |semitone|
      note = initial_semitone ? Note::LETTER_BY_SEMITONE[semitone % 12] : '_'
      print "#{note} "
      note = Note.new(
        note: note,
        octave: @octave,
        duration: @duration,
        volume: @volume,
      )
      note.samples
    end
    puts ''

    samples = Track.mix_samples(*sets_of_samples)
    samples = @times.times.map { samples }.flatten if (@times > 1)
    samples
  end

  def formatted_chord
    chord_type = case @chord_type
      when :major then ''
      when :minor then 'm'
      else "wrong ct: #{@chord_type}"
    end
    "#{@note}#{chord_type}"
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
    times: 1,
    octave_offset: 0
  )
    chord_attrs = decode(encoded_chord, octave_offset.to_i).merge(
      duration: duration,
      volume: volume,
      times: times,
    )
    Chord.new(**chord_attrs)
  end

  def encode decoded_chord, octave_offset: 0
    # decoded_chord example: { note: 'A', octave: 1, chord_type: 'minor' }
    note, octave, chord_type = decoded_chord.values_at(:note, :octave, :chord_type)
    "#{ note }.#{ octave + octave_offset }.#{ chord_type }"
  end

  def self.decode encoded_chord, octave_offset = 0
    # encoded_chord examples: 'Am.0.minor' || 'C.1' || 'D' || 'G#m.1' || ...]
    chord, octave = encoded_chord.split('.')
    {
      note: chord.gsub(/[^A^B^C^D^E^F^G^#^b]/, ''),
      chord_type: chord.include?('m') ? :minor : :major,
      octave: octave.to_i + octave_offset
    }
  end
end
