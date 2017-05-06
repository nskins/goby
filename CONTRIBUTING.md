# Contributing

Thank you for your interest in contributing! Contributors of all skill levels are welcome. We do our best to identify issues that are suitable for open-source newcomers and veterans alike. Please see the [Issues](https://github.com/nskins/goby/issues) tab or tackle a completely unknown problem or feature! Also, please feel free to reach out to the owner ([nskins@umich.edu](mailto:nskins@umich.edu)) for any questions, comments, etc.

Please follow these guidelines to ease the process of merging your contribution.

## Code Style

Blank lines should contain no spaces. Use standard functions in Ruby to the best of your knowledge (don't reinvent the wheel). Write [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) code. Indeed, make your implementation both readable and succinct.

## Testing

Writing test cases is very important and should be done first. All features/bugs must include test(s) verifying their correctness. Aim to cover as many lines of your implementation as possible. There are examples showing how to [provide input](https://github.com/nskins/goby/blob/master/spec/goby/util_spec.rb) and [expect output](https://github.com/nskins/goby/blob/master/spec/goby/event/event_spec.rb). Organize the tests in the same way as the many existing tests:

```ruby
Rspec.describe Class do

  context "function" do
    it "should do this" do
      ...
    end

    ...

    it "should do that" do
      ...
    end
  end

end
```

## Documentation

Keep the documentation up-to-date. Use the style present throughout the codebase. For functions, write a description, parameters (if any), and the return value (if non-void). Use your best judgment when writing comments.

## Pull Requests

Ensure that all of your code includes the commits from the `master` branch. Run the `rspec` command in the top-level directory to verify that all tests are passing. You will make your pull request to the branch specified in the issue tracker. If no branch has been mentioned, please write a comment on the appropriate issue, and we will follow up shortly.
