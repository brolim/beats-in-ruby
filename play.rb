require_relative 'beats'
beats = Beats.new


# -------
# You can use Beats::MUSICS constant to play any note sequence. There is one there as an example:
#
# beats.play(:brilha_brilha_estrelinha)


# -------
# You can also play major or minor scales in any note positioned in any octave:
#
# beats.play('C', :major)
# beats.play('G#.-3', :major)
# beats.play('C', :minor)
# beats.play('G#', :major)


# -------
# Play 7 C-major scales, each one in a different octave. All of them are human hearable.
#
# beats.play([
#   beats.scale('C.-2', :major),
#   beats.scale('C.-1', :major),
#   beats.scale('C.0', :major),
#   beats.scale('C.1', :major),
#   beats.scale('C.2', :major),
#   beats.scale('C.3', :major),
#   beats.scale('C.4', :major),
# ])


# -------
# You can mix different sound waves and play them together, mixing signals
#
signal = [
  beats.generate_signal(encoded_note: 'C.-2', duration: 9, volume: 0.2),
  beats.generate_signal(encoded_note: 'E.-2', duration: 8, volume: 0.2),
  beats.generate_signal(encoded_note: 'G.-2', duration: 7, volume: 0.2),
  beats.generate_signal(encoded_note: 'C.-1', duration: 6, volume: 0.2),
  beats.generate_signal(encoded_note: 'E.-1', duration: 5, volume: 0.2),
  beats.generate_signal(encoded_note: 'G.-1', duration: 4, volume: 0.2),
  beats.generate_signal(encoded_note: 'C.0', duration: 3, volume: 0.2),
  beats.generate_signal(encoded_note: 'E.0', duration: 2, volume: 0.2),
  beats.generate_signal(encoded_note: 'G.0', duration: 1, volume: 0.2)
]
beats.play(beats.mix(*signal))

