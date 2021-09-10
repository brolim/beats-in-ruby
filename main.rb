def generate_sound frequency, duration
  sample_rate = 48000 # samples / second
  volume = 1

  step = frequency * 2 * Math::PI / sample_rate
  (duration * sample_rate)
    .times
    .map { |i| [volume * Math.sin(i * step)].pack('e') }
end


def note letter, duration
  semitone_number = case letter
    when 'A'  then 0
    when 'A#' then 1
    when 'B'  then 2
    when 'C'  then 3
    when 'C#' then 4
    when 'D'  then 5
    when 'D#' then 6
    when 'E'  then 7
    when 'F'  then 8
    when 'F#' then 9
    when 'G'  then 10
    when 'G#' then 11
  end

  frequency_for_semitone = 440 * (2 ** (1.0 / 12.0)) ** semitone_number
  generate_sound(frequency_for_semitone, duration)
end

binary_wave = [
  note('D', 1),
  note('D', 1),
  note('D', 1),
  note('D', 1),
]

File.open('output.bin', 'wb') do |file|
  binary_wave
    .concat(binary_wave)
    .flatten
    .each { |packed_sample| file.write(packed_sample) }
end
system 'ffplay -showmode 1 -f f32le -ar 48000 output.bin'
