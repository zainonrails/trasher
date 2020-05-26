class User < ActiveRecord::Base
  include Trasher
  lets_trash
  has_many :posts
end