# Trasher

Soft Delete 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trasher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trasher

## Usage

```ruby
 # include this in any ActiveRecord based model that you want to soft delete. 
 class User < ActiveRecord::Base
   include Trasher

   # the rest of your model code...
 end
```

```ruby
class User < ActiveRecord::Base
   include Trasher
   # call this method if you want set a predefined default scope. 
   lets_trash default_scope: true

   # the rest of your model code...
 end
```

To work properly, the tables that back these models must have a deleted_at timestamp column and deleted_by_id integer columns.
A `MissingColumn` exception is raised if the model does not have required columns.
 
```ruby
class AddDeletedAtColumnToUsers < ActiveRecord::Migration

  def change
    add_column :users, :deleted_at, :datetime
    add_reference :users, :deleted_by, foreign_key: { to_table: :users }
  end

end
```
 
```ruby
 user1 = User.create(name: 'Name', email: 'name@whois.com')
 user2 = User.create(name: 'AnotherName', email: 'anothername@whois.com')

 # to trash/ soft delete some record. User/Post/Comment
 user1.trash!(user2)
 # this will update deleted_at and deleted_by_id attributes of user model to current timestamp and user id.

 # the trash! method raises an TrashedWithoutTrashedBy exception if a user object is not specified
 # this could be provided through current user method if using devise gem
 
 # to recover any trashed object, simply use
 user1.recover! 
 # this will update deleted_at and deleted_by_id attributes of user model to nil.
```
 
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Run `ruby spec/support/db_setup` to create the required database and tables.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xainbutt/trasher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Trasher project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/trasher/blob/master/CODE_OF_CONDUCT.md).
