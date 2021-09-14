class Mixer
  def self.samples_from *sets_of_samples
    greatest_volume = 0.0

    mixed_signal = sets_of_samples.map(&:size).max.times.map do |i|
      mixed_sample = sets_of_samples.map { |samples| samples[i].to_f }.sum
      greatest_volume = mixed_sample.abs if mixed_sample.abs > greatest_volume
      mixed_sample
    end

    if greatest_volume > 1.0
      mixed_signal.map { |mixed_sample| mixed_sample.to_f / greatest_volume }
    else
      mixed_signal
    end
  end
end
