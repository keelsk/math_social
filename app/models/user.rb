class User < ActiveRecord::Base
  has_secure_password
  has_many :problems
  has_many :comments
  has_many :friends

  def get_friends
    friends = []
    self.friends.each do |friend|
      person = User.find_by(username: friend.username)
      friends << person
    end
    friends
  end

end
