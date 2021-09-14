require_relative 'models/chord'
require_relative 'models/note'
require_relative 'models/sound'

class Beats
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

  def play_music music_key, volume: 0.5, octave_offset: 0, note_duration: 0.5
    return unless MUSICS[music_key]

    play(
      Note.build_many(
        MUSICS[music_key],
        volume: volume,
        octave_offset: octave_offset,
        note_duration: note_duration
      )
    )
  end

  def play_scale letter, scale_key, volume: 0.5, octave: 0, note_duration: 0.5, number_of_notes: 8
    play(
      Note.build_many_for_scale(
        letter,
        scale_key,
        octave: octave,
        volume: volume,
        note_duration: note_duration,
        number_of_notes: number_of_notes
      )
    )
  end

  def play_chord encoded_chord, duration: 1.0, volume: 0.5
    play_chords(
      [encoded_chord],
      chord_duration: duration,
      volume: volume
    )
  end

  def play_chords(encoded_chords, chord_duration: 1.0, volume: 0.5, octave_offset: 0)
    play(
      Chord.build_many(
        encoded_chords,
        volume: volume,
        octave_offset: octave_offset,
        chord_duration: chord_duration,
      )
    )
  end

  def play sounds_with_samples
    Sound
      .new(samples: sounds_with_samples.map(&:samples).flatten)
      .play
  end

  def play_parallel *parallel_sounds
    sets_of_samples = parallel_sounds.map do |serial_sounds|
      serial_sounds.map(&:samples).flatten
    end

    Sound
      .new(samples: Mixer.samples_from(*sets_of_samples))
      .play
  end
end
