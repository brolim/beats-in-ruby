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
# You can mix different sound waves and play them together, mixing signals on time domain
#
beats.play_parallel(
  MusicalNote.build_many_for_scale('C', :major, octave: -1),
  MusicalNote.build_many_for_scale('E', :major, octave: -1),
  MusicalNote.build_many_for_scale('G', :major, octave: -1),
  [
    MusicalNote.new(letter: 'G', duration: 1),
    MusicalNote.new(letter: 'E', duration: 1),
    MusicalNote.new(letter: 'C', duration: 1)
  ]
)
