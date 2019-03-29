[![CircleCI](https://circleci.com/gh/estudar/edools.svg?style=svg)](https://circleci.com/gh/estudar/edools)
# Edools

This is a basic gem to interact with the [Edools API](http://docs.edools.com/api/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'edools', github: 'estudar/edools'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ git clone https://github.com/estudar/edools.git
    $ cd edools
    $ bundle
    $ gem build edools.gemspec
    $ ls *.gem | xargs gem install

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
result = Edools::LessonProgress.find_paginated_by_enrollment(enrollment_id: 2222222)

result
# => #<OpenStruct id=11111111, progress=100.0, completed=true, grade=nil, enrollment_id=2222222, exam_answer_ids=[], time_spent=0, views=1, current_video_time=0, lesson=#<OpenStruct id=3333333, type="ContentLesson", title="Lesson Title">, progress_card=#<OpenStruct course_name="Course Name">, enrollment=#<OpenStruct id=4444444, student_first_name="Student First Name", student_last_name="Student Last Name", student_cover_image_url="https://cdn.edools.com/assets/images/users/default.jpeg">, created_at="2018-11-29T15:59:44.140Z", updated_at="2018-11-29T15:59:52.854Z">
...

result.paginate
#<OpenStruct current_page=1, per_page=50, total_pages=1, total_count=31>
```

Using `student_id` as a parameter to search for LessonProgress:
```ruby
Edools::LessonProgress.find_paginated_by_student(student_id: 6558938)
```

Using `school_product_id` as a parameter to search for LessonProgress:
```ruby
Edools::LessonProgress.find_paginated_by_school_product(school_product_id: 73636)
```

Remember that the response of the endpoint can be paginated, see an example:
```ruby
result = Edools::LessonProgress.find_paginated_by_school_product(school_product_id: 73636)

result.paginate
# => #<OpenStruct current_page=1, per_page=50, total_pages=1526, total_count=76254>

result.paginate.total_count
# => 76254
```

Other parameters that can be passed to the endpoint:
```ruby
result = Edools::LessonProgress.find_paginated_by_school_product(school_product_id: 73636, page: 2, per_page: 30)

result.paginate
# => #<OpenStruct current_page=2, per_page=30, total_pages=2, total_count=60>
```

Create a LessonProgress:
```ruby
data = {
  enrollment_id: 2119734,
  course_id: 22140,
  lesson_progress: {
    lesson_id: 1161016,
    completed: true,
    progress: 100.0
  }
}

Edools::LessonProgress.create(data)
# => #<OpenStruct id=15173869, progress=100.0, completed=true, grade=nil, enrollment_id=2119734, exam_answer_ids=nil, time_spent=0, views=1, current_video_time=0, lesson=nil, lesson_id=1159126, school_id=1111, progress_card=nil, progress_card_id=nil, enrollment=nil, external_id=nil, last_view_at="2018-12-06T14:05:45.580Z", created_at="2018-12-06T14:05:45.580Z", updated_at="2018-12-06T14:05:45.580Z">
```

### ExamAsnwer example

```ruby
result = Edools::ExamAnswer.show(id: 1196779)
=> #<Edools::ExamAnswer:0x0055cbc166d090 @exam_answer=#<OpenStruct id=1196779, lesson_progress_id=14286269, activity_id=30434, collaborator_id=nil, auto_corrected=false, score=0.0, comment=nil, s3_files=[], student=#<OpenStruct id=6513784, first_name="foobar", last_name="silva", cover_image_url="https://cdn.edools.com/assets/images/users/default.jpeg">, exam_question_answers=[#<OpenStruct id=10340521, exam_question=#<OpenStruct id=214233, order=1, point=1, type="DiscursiveExamQuestion", title="<p>Oi vamos por uma resposta</p>\n", library_resources=[], comment=nil>, score=0.0, correct=nil, multiple_choice_option_id=nil, text="<p>resposta da primeira questao</p>\r\n", comment=nil, associative_options=[]>, #<OpenStruct id=10340522, exam_question=#<OpenStruct id=215861, order=2, point=1, type="DiscursiveExamQuestion", title="<p>foobar</p>\n", library_resources=[], comment=nil>, score=0.0, correct=nil, multiple_choice_option_id=nil, text="<p>resposta da segunda questao</p>\r\n", comment=nil, associative_options=[]>], corrected_at=nil, created_at="2019-03-26T21:22:01.800Z", updated_at="2019-03-26T21:22:01.800Z">, @errors=nil>

result.exam_answer[:id]
=> 1196779
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
