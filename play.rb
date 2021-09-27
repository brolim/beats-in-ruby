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


def build_chord_with_rythm chord, time_unit
  chords = chord.split('|')
  chords_to_use =
    if chords.size == 1
      Array.new(6) { chords[0]  }
    elsif chords.size == 2
      Array.new(6) { |i| i < 3 ? chords[0] : chords[1]  }
    end

  result = [
    { chord: chords_to_use[0],  octave:  0, duration: time_unit * 1.0, volume: 1.0, release_size: 0.92, times: 1 },
    { chord: chords_to_use[1],  octave:  0, duration: time_unit * 0.5, volume: 1.0, release_size: 0.92, times: 1 },
  ]

  if chords.size == 1
    result << { chord: chords_to_use[2],  octave:  0, duration: time_unit * 1.0, volume: 1.0, release_size: 0.92, times: 1 }
    result << { chord: chords_to_use[3],  octave:  0, duration: time_unit * 0.5, volume: 1.0, release_size: 0.92, times: 1 }
  elsif chords.size == 2
    result << { chord: chords_to_use[2],  octave:  0, duration: time_unit * 0.5, volume: 1.0, release_size: 0.92, times: 1 }
    result << { chord: chords_to_use[3],  octave:  0, duration: time_unit * 1.0, volume: 1.0, release_size: 0.92, times: 1 }
  end

  result += [
    { chord: chords_to_use[4],  octave:  0, duration: time_unit * 0.5, volume: 1.0, release_size: 0.92, times: 1 },
    { chord: chords_to_use[5],  octave:  0, duration: time_unit * 0.5, volume: 1.0, release_size: 0.92, times: 1 },
  ]
end

time_unit = 0.42
chord_time = time_unit * 4

verse = [
 # G
  '_   _   _   B',

 # G       G
  'D D D D E D B G.-1',

 # B m     Bm
  'B D D D E D B G.-1',

 # G       Em
  'D D D D E D C B',

 # D       D
  'D _ _ _ _ _ _ A',

 # C       D
  'C C C C B A A G.-1',

 # G       Em
  'B B B B A G.-1 G.-1 G.-1',

 # C       D
  'C C C B A A G.-1 F#.-1',

 # G
  'G.-1 _  _  _',
]

chorus = [
 # G          C
  '_ G.-1 A B C C B A',

 # D                  G
  'F#.-1 F#.-1 E.-1 D.-1 B D.-1 B G.-1',

 # Em                  C
  'E.-1 E.-1 E.-1 D.-1 C _ _ B',

 # D                  G
  'F#.-1 F#.-1 E.-1 D.-1 B _ _ _',
]

voice_for_cowboy_fora_da_lei = [
  '_ _ _ _',
  '_ _ _ _',
  '_ _ _ _',
  '_ _ _ _',
  '_ _ _ _',
  '_ _ _ _',
  '_ _ _ _',
] + verse + verse + [
  '_ _ _ _',
] + chorus + chorus

voice_for_cowboy_fora_da_lei =
  voice_for_cowboy_fora_da_lei
    .flatten
    .join(' ')
    .split(' ')

beats.play_tracks(
  {
    track_name: 'base',
    octave_offset: -1,
    sequence: %w[
      C  D  G  Em
      C  D  G  G

      G  G  Bm Bm
      G  Em D  D
      C  D  G  Em
      C  D  G  G

      G  G  Bm Bm
      G  Em D  D
      C  D  G  Em
      C  D  G  G

      G  C  D  G
      Em C  D  G

      G  C  D  G
      Em C  D  G

      C  D  G  G
    ].map { |chord| build_chord_with_rythm(chord, time_unit) }.flatten + [
      { chord: 'G',  octave:  0, duration: 1.00 * time_unit, volume: 0.8, release_size: 0.92, times: 1 },
    ]
  },
  {
    track_name: 'voice1',
    sequence: voice_for_cowboy_fora_da_lei.map do |encoded_note|
      note, octave = encoded_note.split('.')
      {
        note: note,
        octave:  octave.to_i,
        duration: 1.00 * time_unit,
        volume: 0.4,
        release_size: 0.92,
        times: 1
      }
    end
  },
)


