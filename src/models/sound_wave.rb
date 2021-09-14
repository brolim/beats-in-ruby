class SoundWave
  attr_accessor :musical_notes
  attr_accessor :samples

  def initialize(musical_notes: nil, samples: nil)
    @musical_notes = musical_notes
    @samples = samples
  end

  def write_to_file output:
    samples = @samples || @musical_notes&.map(&:samples)&.flatten
    return false unless samples

    File.open(output, 'wb') do |file|
      samples.each do |sample|
        file.write([sample].pack('e')) # write float32bitsLE into file
      end
    end

    return true
  end


  def self.mix_and_build *sets_of_musical_notes
    sets_of_samples = sets_of_musical_notes.map do |musical_notes|
      musical_notes.map(&:samples).flatten
    end
    SoundWave.new(samples: mix(*sets_of_samples))
  end

  def self.mix *sets_of_samples
    greatest_volume = 0.0

    mixed_signal = sets_of_samples.map(&:size).max.times.map do |i|
      mixed_sample = sets_of_samples.map { |samples| samples[i].to_f }.sum
      greatest_volume = mixed_sample.abs if mixed_sample.abs > greatest_volume
      mixed_sample
    end

    if greatest_volume > 1.0
      mixed_signal.map! { |mixed_sample| mixed_sample.to_f / greatest_volume }
    else
      mixed_signal
    end
  end
end
