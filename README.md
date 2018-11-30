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
Edools::School.create(name: 'My School', email: 'my@school.com', password: '******')

Edools::School.update(id: 1, name: 'Other School')
```

### Enrollment example

The `all` method:

```ruby
Edools::Enrollment.all
Edools::Enrollment.all({}, true)
Edools::Enrollment.all({school_product:{id: 73636}, student_id: 6506727}, true)
```

The allowed filters for enrollments:
- `full_name`
- `student_id`
- `course_id`
- `course_class_id`
- `product_name`
- `school_product_id`
- `status`
- `free_enrollments_type`

```ruby
Edools::Enrollment.create(registration_id: 6479697, school_product_id: 73636, max_attendance_type: 'indeterminate')
```

In the `update`, the attributes can be updated are:
- `school_product_id`
- `max_attendance_type`
- `status`
- `available_until`
- `created_at`
- `activated_at`
- `unlimited`
- `course_class_ids`

The attribute Status can be:
- `pending`
- `active`
- `expired`
- `deactivated`
- `canceled`


```ruby
Edools::Enrollment.update(id: 1, status: "deactivated")

Edools::Enrollment.update(id: 1, school_product_id: 75506, status: "active")
Edools::Enrollment.all
```

### Lesson Progress example

Check the progress of the lessons, if it have completed lesson will return the result hash populate with data.
```ruby
Edools::Enrollment.lessons_progresses({id: 2022188})
```

If it is necessary to page:
```ruby
Edools::Enrollment.lessons_progresses({id: 2022188, per_page: 20, page: 2})
```

The allowed filters for lessons_progresses:
- `lesson_id`
- `updated_at`> or `updated_at`<
- `created_at`> or `created_at`<

### Course example

```ruby
Edools::Course.create(name: 'My Course')

Edools::Course.all
```

### SchoolProduct example

```ruby
Edools::SchoolProduct.create(school_id: 1, title: 'My Product')

Edools::SchoolProduct.all
```

### Invitation example

```ruby
Edools::Invitation.create(first_name: 'Student', email: 'email@student.com', password: '******', password_confirmation: '******')
```

### User example

```ruby
Edools::User.all(type: 'student')

Edools::User.all(type: 'student', school_product_id: 1)

Edools::User.create_from_csv(media.s3_file_content)
```

### Session example

```ruby
session = Edools::Session.create(email: 'email@user.com', password: '******')
session.set_as_global_environment # Sets the current_token to the session's credentials
```

## Media example

```ruby
media = Edools::Media.find(1)
media.s3_file_content # Fetches s3_file contents
```

## Contributing

Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
