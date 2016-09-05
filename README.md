# goby

Goby is a Ruby framework for developing [text](https://en.wikipedia.org/wiki/Text-based_game)-[RPGs](https://en.wikipedia.org/wiki/Role-playing_game). Popular examples of such games are [Zork](https://en.wikipedia.org/wiki/Zork) and [Colossal Cave Adventure](https://en.wikipedia.org/wiki/Colossal_Cave_Adventure). Our purpose is to provide the engine and underlying logic so the user can focus on the fun part: content creation!

## Preset Data

Play our (short) example game with the following command:

```ruby src/main.rb```

## Documentation

We use [YARD](https://github.com/lsegal/yard) for documentation. In order to see the doc files, first ensure that YARD is installed:

```gem install yard```

Then run the following command in our project's root directory:

```yardoc 'src/**/*.rb'```

The doc files will be available as HTML files in the doc/ directory.

## Contributing

Ensure that all tests are passing with the following command:

```rspec ```

If so, then submit a pull request. Thanks!

