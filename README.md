## Vinber ##

Vinber works for Rails, provides other way enumeration style which without force format output and force method definations.

__NOTE__: Vinber current version *require* Ruby v1.9.0 or later and just tested on Rails 4.x for now .


### Installation ###
    # Installing as Ruby gem
    $ gem install vinber

    # Or in gemfile
    $ gem vinber

### Usage ###

#### vinber
You will be able to use `vinber` in any model which inherit `ActiveRecord::Base`.
```ruby
vinber attribute: {} # hash
vinber attribute: [] # array
```

### vinber_list
`vinber_list` return a nested Array, it besides the attribute I18n value and vinber key.
```ruby
vinber_list class_object, attribute
```

### vinber_value
`vinber_value` return the I18n value of specific attribute.

```ruby
vinber_value instance_object, attribute
```

### Examples ###
Step 1, you need define your vinbers in your model.

```ruby
# app/models/your_models.rb
class YourModel < ActiveRecord::Base
  ...

  vinber :status => {:submited => 1, :processing => 2, :completed => 3}

  ...
end
```

Step 2, set your locale for I18n.
```yaml
# config/locales/zh.yml or en.yml(any yml your want)
zh:
  vinber:
    YourModel:
      status_submited: 提交
      status_processing: 进行中
      status_completed: 完成

```

Step 3, invoking in view !! We assume you has YourModel and it contains records, the status of first record is `2`.

```haml
# app/views/your_modles/index.haml
- obj = YourModel.first
%p= vinber_value(obj, :status)

# => <p>进行中</p>

= form_tag({}) do
  = select_tag "status", options_for_select(vinber_list YourModel, :status)

# =>  <form accept-charset="UTF-8" method="post">
# =>    <select name="status" id="status">
# =>      <option value="1">提交</option>
# =>      <option value="2">进行中</option>
# =>      <option value="3">完成</option>
# =>    </select>
# =>  </form>
```

### TODO ###
- Write more clear document
- Add soft warning when error
- more functions

### License ###
Released under the [MIT](http://opensource.org/licenses/MIT) license. See LICENSE file for details.
