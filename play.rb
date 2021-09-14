require_relative 'src/beats'
beats = Beats.new


# -------
# You can use Beats::MUSICS constant to play any note sequence. There is one there as an example:
#
# beats.play_music(:brilha_brilha_estrelinha, volume: 0.8, octave_offset: -1)


# -------
# You can play specific scales setting mode and octave for each one:
#
# beats.play_scale('C', :minor)
# beats.play_scale('G#', :major, octave: -1)
# beats.play_scale('A', :major, octave: -1, number_of_notes: 49)
# beats.play_scale('G#', :major, octave: 2)


# -------
# You can play a single chord or a sequence of them using encoded chords string:
#
# beats.play_chord('C.-1.minor', duration: 5)
beats.play_chords(%w[
  C.-1 A.-1.minor F.-1 G.-1 F.-1 D.-1.minor A.-1.minor
  C.-1 A.-1.minor F.-1 G.-1 F.-1 D.-1.minor A.-1.minor
])


# -------
# You can mix different sound waves and play them together, mixing signals on time domain
#
# beats.play_parallel(
#   Note.build_many_for_scale('C', :major, octave: -1),
#   Note.build_many_for_scale('E', :major, octave: -1),
#   Note.build_many_for_scale('G', :major, octave: -1),
#   [
#     Note.new(letter: 'G', duration: 1),
#     Note.new(letter: 'E', duration: 1),
#     Note.new(letter: 'C', duration: 1)
#   ]
# )
#
# beats.play_parallel(
#   Chord.build_many(%w[C.-3 A.-3.minor F.-3 G.-3 F.-3 D.-3.minor A.-3.minor]),
#   Chord.build_many(%w[C.-2 A.-2.minor F.-2 G.-2 F.-2 D.-2.minor A.-2.minor]),
#   Chord.build_many(%w[C.-1 A.-1.minor F.-1 G.-1 F.-1 D.-1.minor A.-1.minor]),
#   Chord.build_many(%w[C.0 A.0.minor F.0 G.0 F.0 D.0.minor A.0.minor]),
# )
