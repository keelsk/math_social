class Commenter < ActiveRecord::Base
  belongs_to :solution
  has_many :comments
end
