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
# beats.play_chords(%w[
#   C.-1 Am.-1 F.-1 G.-1 F.-1 Dm.-1 Am.-1
#   C.-1 Am.-1 F.-1 G.-1 F.-1 Dm.-1 Am.-1
# ])


# -------
# You can mix different tracks and play them together, mixing signals on time domain
#
# i_will_survive = {
#   chords: [
#     { chord: 'A',  octave:  0, duration: 1.0, volume: 0.6, times: 4 },
#     { chord: 'Dm', octave:  0, duration: 1.0, volume: 0.6, times: 4 },
#     { chord: 'G',  octave: -1, duration: 1.0, volume: 0.6, times: 4 },
#     { chord: 'Cm', octave:  0, duration: 1.0, volume: 0.6, times: 4 },
#     { chord: 'F',  octave: -1, duration: 1.0, volume: 0.6, times: 4 },
#     { chord: 'Bm', octave:  0, duration: 1.0, volume: 0.6, times: 4 },
#     { chord: 'E',  octave: -1, duration: 1.0, volume: 0.6, times: 8 },
#   ],
#   solo: [
#     { note: 'A', octave:  0, duration: 0.25, release_size: 0.8, volume: 0.9, times: 16 },
#     { note: 'D', octave:  0, duration: 0.25, release_size: 0.8, volume: 0.9, times: 16 },
#     { note: 'G', octave: -1, duration: 0.25, release_size: 0.8, volume: 0.9, times: 16 },
#     { note: 'C', octave:  0, duration: 0.25, release_size: 0.8, volume: 0.9, times: 16 },
#     { note: 'F', octave: -1, duration: 0.25, release_size: 0.8, volume: 0.9, times: 16 },
#     { note: 'B', octave:  0, duration: 0.25, release_size: 0.8, volume: 0.9, times: 16 },
#     { note: 'E', octave: -1, duration: 0.25, release_size: 0.8, volume: 0.9, times: 32 },
#   ]
# }

# beats.play_tracks(
#   {
#     track_name: 'base1',
#     octave_offset: -1,
#     sequence: i_will_survive[:chords]
#   },
#   {
#     track_name: 'base2',
#     octave_offset: 0,
#     sequence: i_will_survive[:chords]
#   },
#   {
#     track_name: 'bass1',
#     octave_offset: -2,
#     sequence: i_will_survive[:solo]
#   }
# )

time_unit = 0.8
beats.play_tracks(
  {
    track_name: 'test',
    octave_offset: 0,
    sequence: %w[A Bm D A A Bm D A A Bm D A].map do |chord|
      [
        { chord: chord,  octave:  0, duration: time_unit * 1.0, volume: 0.6, release_size: 0.9, times: 1 },
        { chord: chord,  octave:  0, duration: time_unit * 0.5, volume: 0.6, release_size: 0.9, times: 1 },
        { chord: chord,  octave:  0, duration: time_unit * 1.0, volume: 0.6, release_size: 0.9, times: 1 },
        { chord: chord,  octave:  0, duration: time_unit * 0.5, volume: 0.6, release_size: 0.9, times: 1 },
        { chord: chord,  octave:  0, duration: time_unit * 0.5, volume: 0.6, release_size: 0.9, times: 1 },
        { chord: chord,  octave:  0, duration: time_unit * 0.5, volume: 0.6, release_size: 0.9, times: 1 },
      ]
    end.flatten
  },
)
