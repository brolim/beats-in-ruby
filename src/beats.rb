require_relative 'models/chord'
require_relative 'models/note'
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
    Scale.new(
      note: note,
      scale_type: scale_type,
      octave: octave,
      number_of_notes: number_of_notes,
      note_duration: note_duration,
      volume: volume,
    ).play
  end

  def play_chord encoded_chord, duration: 1.0, volume: 0.5, times: 1
    Chord.build_one(
      encoded_chord,
      duration: duration,
      volume: volume,
      times: times,
    ).play
  end

  def play_chords encoded_chords, chord_duration: 1.0, volume: 0.5, octave_offset: 0
    Track.build_from_encoded_tracks(
      track_name: 'chords',
      octave_offset: octave_offset,
      sequence: encoded_chords.map do |encoded_chord|
        chord = Chord.build_one(
          encoded_chord,
          duration: chord_duration,
          volume: volume,
        )
        chord.to_hash(octave_offset)
      end
    ).play
  end

  def play_tracks *encoded_tracks
    Track.build_from_encoded_tracks(*encoded_tracks).play
  end
end
