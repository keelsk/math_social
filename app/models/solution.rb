class Solution < ActiveRecord::Base
  belongs_to :problem
  has_many :commenters
  has_many :comments, through: :commenters
end
