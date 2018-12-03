[![CircleCI](https://circleci.com/gh/estudar/edools.svg?style=svg)](https://circleci.com/gh/estudar/edools)
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

### LessonProgress example

Using `enrollment_id` as a parameter to search for LessonProgress:
```ruby
Edools::LessonProgress.find_paginated_from_enrollments(enrollment_id: 2075731)
```

Using `student_id` as a parameter to search for LessonProgress:
```ruby
Edools::LessonProgress.find_paginated_from_students(student_id: 6558938)
```

Using `school_product_id` as a parameter to search for LessonProgress:
```ruby
Edools::LessonProgress.find_paginated_from_school_products(school_product_id: 73636)
```

Remember that the response of the endpoint can be paginated, see an example:
```ruby
result = Edools::LessonProgress.find_paginated_from_school_products(school_product_id: 73636)

result.paginate
# => #<OpenStruct current_page=1, per_page=50, total_pages=1526, total_count=76254>

result.paginate.total_count
# => 76254
```

Other parameters that can be passed to the endpoint:
```ruby
result = Edools::LessonProgress.find_paginated_from_school_products(school_product_id: 73636, page: 2, per_page: 30)

result.paginate
# => #<OpenStruct current_page=2, per_page=30, total_pages=2, total_count=60>
```

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
