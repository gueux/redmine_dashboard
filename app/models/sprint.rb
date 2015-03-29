class Sprint < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :project, class_name: 'Project'
  has_many :issues, as: :scrumable

  #validates_presence_of :name
  #validates_uniqueness_of :name, :scope => [:project_id]
  #validates_length_of :name, :maximum => 60

  #validates_presence_of :start_date
  #validates_presence_of :end_date
  
  before_destroy :move_sprint_issues_to_product_backlog

  safe_attributes 'name',
    'description',
    'start_date',
    'end_date',
    'closed'
  
  def move_sprint_issues_to_product_backlog
    product_backlog = self.project.product_backlog
    self.issues.each do |issue|
      issue.scrumable_id = product_backlog.id
      issue.scrumable_type = 'ProductBacklog'
      issue.save
    end
  end
  
  def has_open_issues?
    self.issues.each {|issue| return true unless issue.closed? }
  end

end
