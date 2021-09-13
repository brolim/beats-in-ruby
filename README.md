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
beats.play_scale('C', :minor)
```

## Examples

See `play.rb` file to run the examples.

You may want to run the default example. To do that, use the following command:
```bash
cd path-to/beats-in-ruby
ruby play.rb
```
