# Beats in Ruby

Made on Ruby 3.0.2

## Requirements
- ffplay
- run `sudo apt-get install ffplay` to install it

## Instalation

Pull Beats code from github:
```
git clone git@github.com:brolim/beats-in-ruby.git
```

You will need only `Beats` class.

## Usage
```
beats = Beats.new
beats.play('C', :minor)
```

## Examples

See `play.rb` file and get some examples.

You may want to run the default example and hear a C minor scale running `play.rb`
```
cd path-to/beats-in-ruby
ruby play.rb
```

