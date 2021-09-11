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
# You can mix two sound waves in the same time frame to compound more complex sounds
#
# c_signal = beats.generate_signal(encoded_note: 'C.0', duration: 0.8, volume: 0.2)
# b_signal = beats.generate_signal(encoded_note: 'C.0', duration: 0.8, volume: 0.2)
# signal = beats.mix(c_signal, b_signal)
# beats.play(signal)

