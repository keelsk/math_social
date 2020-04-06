class User < ActiveRecord::Base
  has_secure_password
  has_many :problems
  has_many :comments 
end
