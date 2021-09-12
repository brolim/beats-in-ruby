# Beats-in-Ruby

Made on Ruby 3.0.2

## Instalation
```
sudo apt-get install ffplay libfftw3-dev libfftw3-doc
rvm install "ruby-3.0.2"
git clone git@github.com:brolim/beats-in-ruby.git
cd beats-in-ruby
bundle install
```

## Usage
```
beats = Beats.new
beats.play('C', :minor)
```

## Examples

See `play.rb` file to easily run the examples listed below.

You may want to run the default example. To do that, use the following command:
```bash
cd path-to/beats-in-ruby
ruby play.rb
```

# Example 1
You can use `Beats::MUSICS` constant to add a new key and play any note sequence. There is one available called `brilha_brilha_estrelinha`:
```ruby
beats = Beats.new
beats.play(:brilha_brilha_estrelinha)
```


# Example 2
You can also play major or minor scales in any note positioned in any octave:
```ruby
beats = Beats.new
beats.play('C', :major)
beats.play('G#.-3', :major)
beats.play('C', :minor)
beats.play('G#', :major)
```


# Example 3
You can play builded major scales, each one in a different octave. All of them in this example are human hearable.
```ruby
beats.play([
  beats.scale('C.-2', :major),
  beats.scale('C.-1', :major),
  beats.scale('C.0', :major),
  beats.scale('C.1', :major),
  beats.scale('C.2', :major),
  beats.scale('C.3', :major),
  beats.scale('C.4', :major),
])
```


# Example 4
You can mix different sound waves and play them together, mixing signals
```ruby
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
```


