class ProductBacklog < ActiveRecord::Base

  belongs_to :project
  has_many :issues, as: :scrumable
  
end
