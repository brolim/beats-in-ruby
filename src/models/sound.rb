require 'wavefile'
include WaveFile

class Sound
  attr_accessor :samples

  OUTPUTS_FOLDER = 'outputs'

  def initialize samples:, output_name: 'output2'
    @samples = samples
    @output_name = output_name
  end

  def play
    file_name = "#{ OUTPUTS_FOLDER }/#{ @output_name }.pcm32le.bin"
    File.open(file_name, 'wb') do |file|
      samples.each do |sample|
        file.write([sample].pack('e')) # write float32bitsLE into file
      end
    end
    system "ffplay -autoexit -showmode 1 -f f32le -ar #{ Note::SAMPLE_RATE } #{ file_name }"
  end

  def save!
    puts 'aaaa'
    sss = samples
    Writer.new("#{ OUTPUTS_FOLDER }/#{@output_name}-wave-file.wav", Format.new(:mono, :pcm_32, Note::SAMPLE_RATE)) do |writer|
      writer.write(
        Buffer.new(
          samples,
          Format.new(:mono, :float, Note::SAMPLE_RATE)
        )
      )
    end
    puts sss.size
    puts @output_name
    puts 'bbbb'
  end
end
