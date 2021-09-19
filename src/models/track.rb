require_relative 'sound'
require 'byebug'

class Track < Sound
  attr_accessor :name
  attr_accessor :sequence
  attr_accessor :samples
  attr_accessor :octave_offset

  def initialize name:, sequence: nil, samples: nil, octave_offset: 0
    throw 'Track without sequence or samples' if !sequence && !samples

    @name = name
    @sequence = sequence
    @samples = samples
    @octave_offset = octave_offset
  end

  def samples
    @samples || sequence_in_chords_and_notes.map(&:samples).flatten
  end

  def sequence_in_chords_and_notes
    sequence.map do |encoded_note_or_chord|
      chord = encoded_note_or_chord[:chord] || nil
      note = encoded_note_or_chord[:note] || nil
      octave = encoded_note_or_chord[:octave] || 0
      duration = encoded_note_or_chord[:duration] || 1.0
      volume = encoded_note_or_chord[:volume] || 1.0
      times = encoded_note_or_chord[:times] || 1
      release_size = encoded_note_or_chord[:release_size] || nil

      if chord
        Chord.build_one(
          "#{ chord }.#{ octave + octave_offset.to_i }",
          duration: duration,
          volume: volume,
          times: times,
          release_size: release_size
        )
      else
        Note.build_one(
          "#{ note }.#{ octave + octave_offset.to_i }",
          duration: duration,
          volume: volume,
          times: times,
          release_size: release_size
        )
      end
    end
  end

  def self.build_from_encoded_tracks *encoded_tracks
    Track.build_from_tracks(
      *encoded_tracks.map do |encoded_track|
        Track.new(
          name: encoded_track[:track_name],
          octave_offset: encoded_track[:octave_offset].to_i,
          sequence: encoded_track[:sequence],
        )
      end
    )
  end

  def self.build_from_tracks *tracks
    Track.new(
      name: tracks.map { |track| track.name }.join(' - '),
      samples: mix_samples(*tracks.map(&:samples))
    )
  end

  def self.mix_samples *sets_of_samples
    greatest_volume = 0.0
    mixed_signal = sets_of_samples.map(&:size).max.times.map do |i|
      mixed_sample = sets_of_samples.map { |samples| samples[i].to_f }.sum
      greatest_volume = mixed_sample.abs if mixed_sample.abs > greatest_volume
      mixed_sample
    end

    if greatest_volume > 1.0
      mixed_signal.map { |mixed_sample| mixed_sample.to_f / greatest_volume }
    else
      mixed_signal
    end
  end
end
