# BestBuy

The BestBuy gem lets you request information from the BestBuy API in your Ruby applications. The API requires you to have an API key before you can make any requests, so make sure you obtain one [here](https://remix.mashery.com/member/register) first.

**Disclaimer**: I am not affiliated with Best Buy in any way. I built this because it was useful to me and I'm releasing it in the hopes that it will be useful to others.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'best_buy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bestbuy

## Usage

First, require the BestBuy gem where you want to make requests to the API using:

```
require 'bestbuy'
```

Next, you will need to instantiate a `BestBuy::Client` with your API key:

```
bby = BestBuy::Client(api_key: '1234567890')
```

Once you've created a client, you can access the various endpoints of the BestBuy API as methods off of the BestBuy client. Most options are passed as hash parameters to these methods.

```
bby.products(upc: '004815162342')

#=> [#<BestBuy::Product:0xDEADBEEF>, ...]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/timraymond/bestbuy.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

