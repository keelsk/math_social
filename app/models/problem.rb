class Problem < ActiveRecord::Base
  belongs_to :user
  has_one :solution
end
