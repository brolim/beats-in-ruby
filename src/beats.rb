require_relative 'models/chord'
require_relative 'models/note'
require_relative 'models/sound'
require_relative 'models/track'
require_relative 'models/scale'

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

  def play_scale note, scale_type, octave: 0, number_of_notes: 8, note_duration: 0.5, volume: 0.5
    track = Track.build_from_encoded_tracks(
      {
        track_name: "scale for #{ note } #{ scale_type }",
        octave_offset: octave,
        sequence: Scale.new(
          note: note,
          scale_type: scale_type,
          octave: octave,
          number_of_notes: number_of_notes,
          note_duration: note_duration,
          volume: volume,
        ).track_sequence
      }
    )
    Sound.new(samples: track.samples).play

    # play(
    #   Note.build_many_for_scale(
    #     note,
    #     scale_type,
    #     octave: octave,
    #     volume: volume,
    #     note_duration: note_duration,
    #     number_of_notes: number_of_notes
    #   )
    # )
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
    Sound.build_parallel(*parallel_sounds).play
  end

  def save_parallel *parallel_sounds
    Sound.build_parallel(*parallel_sounds).save!
  end
end
