# Goby [![Build Status](https://travis-ci.org/nskins/goby.png)](https://travis-ci.org/nskins/goby) [![Coverage Status](https://coveralls.io/repos/github/nskins/goby/badge.svg?branch=master)](https://coveralls.io/github/nskins/goby?branch=master)

Goby is a Ruby framework for creating [CLI-based](https://en.wikipedia.org/wiki/Command-line_interface) [role-playing games](https://en.wikipedia.org/wiki/Role-playing_video_game). Goby comes with out-of-the-box support for 2D map development, background music, monster battles, customizable items & map events, stats, equipment, and so much more. With thorough testing and documentation, it's even easy to expand upon the framework for special, unique features. If you are looking to create the next classic command-line RPG, then look no further!

Goby will always be free and open source software. If you have any questions, please contact nskins@umich.edu.

## Getting Started

In order to start using Goby in your application, follow these instructions:

Add this line to your application's Gemfile:

```ruby
gem 'goby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install goby

## Contributing

Thank you for your interest in contributing! Please read our [guidelines](https://github.com/nskins/goby/blob/master/CONTRIBUTING.md) before sending a pull request.

## Documentation

We use [YARD](https://github.com/lsegal/yard) for documentation. In order to generate the documentation (which will be stored in the doc/ directory), run the following command in the project's root directory:

    $ yardoc
