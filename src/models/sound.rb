require 'wavefile'
include WaveFile

class Sound
  attr_accessor :samples

  OUTPUTS_FOLDER = 'outputs'

  def initialize samples:, output_name: 'output'
    @samples = samples
    @output_name = output_name
  end

  def play
    file_name = "#{ OUTPUTS_FOLDER }/#{ @output_name }.pcm32le.bin"
    File.open(file_name, 'wb') do |file|
      @samples.each do |sample|
        file.write([sample].pack('e')) # write float32bitsLE into file
      end
    end
    system "ffplay -showmode 1 -f f32le -ar #{ Note::SAMPLE_RATE } #{ file_name }"
  end

  def save!
    Writer.new("#{ OUTPUTS_FOLDER }/#{@output_name}.wav", Format.new(:mono, :pcm_32, Note::SAMPLE_RATE)) do |writer|
      writer.write(
        Buffer.new(
          @samples,
          Format.new(:mono, :float, Note::SAMPLE_RATE)
        )
      )
    end
  end

  def self.build_parallel *parallel_sounds
    sets_of_samples = parallel_sounds.map do |serial_sounds|
      serial_sounds.map(&:samples).flatten
    end
    Sound.new(samples: Mixer.samples_from(*sets_of_samples))
  end

  def self.build_from_tracks *parallel_tracks
    sets_of_samples = parallel_tracks.map do |serial_track|
      serial_track
        .map { |note_or_chord| puts note_or_chord; samples_for(note_or_chord) }
        .flatten
    end
    Sound.new(samples: Mixer.samples_from(*sets_of_samples))
  end

  def self.samples_for note_or_chord_hash
    chord = note_or_chord_hash[:chord] || nil
    note = note_or_chord_hash[:note] || nil
    octave = note_or_chord_hash[:octave] || 0
    duration = note_or_chord_hash[:duration] || 1.0
    volume = note_or_chord_hash[:volume] || 1.0
    release_size = note_or_chord_hash[:release_size] || nil

    chord_or_note =
      if chord
        chord_type = chord.index('m') == nil ? :major : :minor
        chord_note = chord.gsub(/[^A^B^C^D^E^F^G^#^b]/, '')
        Chord.build_one(
          "#{ chord_note }.#{ octave }.#{ chord_type }",
          duration: duration,
          volume: volume,
        )
      else
        Note.build_one(
          "#{ note }.#{ octave }",
          duration: duration,
          volume: volume,
          release_size: release_size
        )
      end
    chord_or_note.samples
  end
end
