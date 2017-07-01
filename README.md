## Vinber ##

 Enumeration with I18N solution for Rails, which without force output formatting and force method defining.

__NOTE__: vinber works fine with Rails 4.x or later.


### Installation ###
    # Manually from RubyGems.org
    $ gem install vinber

    # Or Gemfile if you are using Bundler
    $ gem vinber

### Usage ###
To use vinber is as simple as defining table attribute in its Model, and using Hash or Array are supported:

```ruby
# app/models/user.rb
# User(id: integer, name: string, :status: integer, language: string)
class User < ActiveRecord::Base

  vinber :status => {:registered => 1, :active => 2, :locked => 3}

end
```

This provides you with a couple of public methods for class  `User` and its instances:

```ruby
User.defined_vinbers             # => {'status' => {:registered => 1, :active => 2, :locked => 3}}
User.vinber_defined?             # => true
User.vinber_defined?(:status)    # => true
User.vinber_defined?(:language)  # => false
User.vinbers.status              # => {:registered => 1, :active => 2, :locked => 3}
User.vinber_list(:status)        # => [['Registered', 1], ['Active', 2], ['Locked', 3]]

# We assume there are a lot of records in User Table
User.first.status                # => 2
User.first.vinber_value(:status) # => 'Active'

# if the attribute not defined by vinber, vinber_value return the real value
User.vinber_defined?(:id)        # => false
User.first.vinber_value(:id)     # => 1
```

### i18n ###
You will be able to use i18n of vinber when you defines attribute with `Hash`, as default, vinber always try to find the translation from current local yaml file. if not found, vinber will fetch the attribute and return the right hash key string.

```ruby
User.first.status                # => 2
User.first.vinber_value(:status) # => 'Active'
User.vinber_list(:status)        # => [['Registered', 1], ['Active', 2], ['Locked', 3]]
```
Setting locale like below format:

```yaml
# config/locales/zh.yml or en.yml(any yml your want)
zh:
  vinber:
    User:
      status_registered: 已注册
      status_active: 已激活
      status_locked: 锁定中

```

If current locale is `zh`, you will see:

```ruby
User.first.vinber_value(:status) # => '已激活'
User.vinber_list(:status)        # => [['已注册', 1], ['已激活', 2], ['锁定中', 3]]
```

Alternative, if you don't want it to be translated, just use `:t => false`, this will be useful when you writing api program, you don't want different locals to change the result.

```ruby
User.first.vinber_value(:status, :t => false) # => 'active'
User.vinber_list(:status, :t => false)        # => [['registered', 1], ['active', 2], ['locked', 3]]
```

Sometimes, the array by  `vinber_list` is not what you expect, you could use block to customize:

```ruby
User.vinber_list(:status) do |key, value|
  "#{key}: #{value}"
end
# => ["已注册: 1", "已激活: 2", "锁定中: 3"]

User.vinber_list(:status, :t => false) do |key|
  key.upcase
end
# => ["REGISTERED", "ACTIVE", "LOCKED"]
```

### Validates ###

For database safety, vinber provides validates to check security of value when saving, but it's disabled by default, you can enable with option `:validates => true`.

```ruby
class User < ActiveRecord::Base

  vinber :status => {:registered => 1, :active => 2, :locked => 3}, :validates => true

end

user = User.new(
  :name => 'Charles',
  :status => 4    # status is 4, expected in [1, 2, 3]
)
user.save            # false
user.errors.messages # {:status => ["is not included in the list"]}
```

### TODO ###
- Improve compatibility
- Make it easy to ActiveRecord Query

### License ###
Released under the [MIT](http://opensource.org/licenses/MIT) license. See LICENSE file for details.
