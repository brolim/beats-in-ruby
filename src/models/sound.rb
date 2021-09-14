class Sound
  attr_accessor :samples

  def initialize samples:
    @samples = samples
  end

  def write_to_file output:
    return false unless @samples

    File.open(output, 'wb') do |file|
      @samples.each do |sample|
        file.write([sample].pack('e')) # write float32bitsLE into file
      end
    end

    return true
  end

  def play
    write_to_file(output: 'output.bin')
    system 'ffplay -showmode 1 -f f32le -ar 48000 output.bin'
  end
end
