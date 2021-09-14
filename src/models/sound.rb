class Sound
  attr_accessor :samples

  def initialize samples:
    @samples = samples
  end

  def play
    File.open('output.bin', 'wb') do |file|
      @samples.each do |sample|
        file.write([sample].pack('e')) # write float32bitsLE into file
      end
    end
    system 'ffplay -showmode 1 -f f32le -ar 48000 output.bin'
  end
end
