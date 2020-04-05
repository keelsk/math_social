class Comment < ActiveRecord::Base
  belongs_to :commenter
end
