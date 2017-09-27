# Edools

This is a basic gem to interact with the [Edools API](http://docs.edools.com/api/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'edools'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install edools

## Configuration

In order to work properly the gem needs an API Token, you could either set it manually:

```ruby
Edools.api_token = 'YOUR_API_TOKEN'
```

or let the gem automatically load it from the environment. Just make sure you've set the variable correctly:

```ruby
ENV['EDOOLS_API_TOKEN'] = 'YOUR_API_TOKEN'
```

## Usage

### School example

```ruby
Edools::School.create(name: 'My School', email: 'my@school.com', password: '********')

Edools::School.update(id: 1, name: 'Other School')
```

### Course example

```ruby
Edools::Course.create(name: 'My Course')

Edools::Course.all
```

### SchoolProduct example

```ruby
Edools::SchoolProduct.create(name: 'My Product')

Edools::SchoolProduct.all
```

## Contributing

Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

