class RdbScrumban < RdbDashboard

  def init
    # Init filters
    self.add_filter RdbAssigneeFilter.new
    self.add_filter RdbVersionFilter.new if versions.any?
    self.add_filter RdbTrackerFilter.new
    self.add_filter RdbCategoryFilter.new if issue_categories.any?
  end

  def setup(params)
    super

    if ['tracker', 'priority', 'assignee', 'category', 'version', 'parent', 'none', 'project'].include? params[:group]
      options[:group] = params[:group].to_sym
    end

    if params[:hide_done]
      options[:hide_done] = (params[:hide_done] == 'true')
    end

    if params[:change_assignee]
      options[:change_assignee] = (params[:change_assignee] == 'true')
    end

    if id = params[:column]
      options[:hide_columns] ||= []
      options[:hide_columns].include?(id) ? options[:hide_columns].delete(id) : (options[:hide_columns] << id)
    end
  end

  def build
    # Init columns
    options[:hide_columns] ||= []
    
    product_backlog = @project.product_backlog
    self.add_column RdbScrumColumn.new("product_backlog_#{product_backlog.id}", product_backlog.id, 'ProductBacklog', product_backlog.name,
      :hide => options[:hide_columns].include?("s#{product_backlog.id}"))

    @project.sprints.select do |sprint|
      self.add_column RdbScrumColumn.new("sprint_#{sprint.id}", sprint.id, 'Sprint', sprint.name,
        :hide => options[:hide_columns].include?("s#{sprint.id}"))
    end
    # Init groups
    case options[:group]
    when :tracker
      trackers.each do |tracker|
        self.add_group RdbGroup.new("tracker-#{tracker.id}", tracker.name, :accept => Proc.new {|issue| issue.tracker == tracker })
      end
    when :priority
      IssuePriority.find(:all).reverse.each do |p|
        self.add_group RdbGroup.new("priority-#{p.position}", p.name, :accept => Proc.new {|issue| issue.priority_id == p.id })
      end
    when :assignee
      self.add_group RdbGroup.new(:assigne_me, :rdb_filter_assignee_me, :accept => Proc.new {|issue| issue.assigned_to_id == User.current.id })
      self.add_group RdbGroup.new(:assigne_none, :rdb_filter_assignee_none, :accept => Proc.new {|issue| issue.assigned_to_id.nil? })
      assignees.sort_by(&:name).each do |principal|
        next if principal.id == User.current.id
        self.add_group RdbGroup.new("assignee-#{id}", principal.name, :accept => Proc.new {|issue| !issue.assigned_to_id.nil? and issue.assigned_to_id == principal.id })
      end
    when :category
      issue_categories.each do |category|
        self.add_group RdbGroup.new("category-#{category.id}", category.name, :accept => Proc.new {|issue| issue.category_id == category.id })
      end
      self.add_group RdbGroup.new(:category_none, :rdb_unassigned, :accept => Proc.new {|issue| issue.category.nil? })
    when :version
      versions.each do |version|
        self.add_group RdbGroup.new("version-#{version.id}", version.name, :accept => Proc.new {|issue| issue.fixed_version_id == version.id })
      end
      self.add_group RdbGroup.new(:version_none, :rdb_unassigned, :accept => Proc.new {|issue| issue.fixed_version.nil? })
    when :project
      projects.each do |project|
        self.add_group RdbGroup.new("project-#{project.id}", project.name, :accept => Proc.new {|issue| issue.project_id == project.id })
      end
    when :parent
      issues.joins(:children).uniq.all.each do |issue|
        self.add_group RdbGroup.new("issue-#{issue.id}", issue.subject, :accept => Proc.new { |sub_issue| sub_issue.parent_id == issue.id })
      end
      self.add_group RdbGroup.new("issue-others", :rdb_no_parent, :accept => Proc.new { |issue| issue.parent.nil? and issue.children.empty? })
    end

    self.add_group RdbGroup.new(:all, :rdb_all_issues) if groups.empty?
  end


  # -------------------------------------------------------
  # Helpers

  def issues_for(column)
    filter column.scope(issues)
  end

  def columns; @columns ||= HashWithIndifferentAccess.new end
  def column_list; @colum_list ||= [] end
  def add_column(column)
    column.board = self
    column_list << column
    columns[column.id.to_s] = column
  end

  def visible_columns; column_list.select{|c| c.visible?} end

  def drop_on(issue)
    #if User.current.admin?
    #  return column_list.reject{|c| c.statuses.include? issue.status}.map(&:id).join(' ')
    #end
    #byebug
    #sprints = issue.new_statuses_allowed_to(User.current)
    column_list.select{|c| c.id}.reject{|c| c.scrumable_id.equal?(issue.scrumable_id) && c.scrumable_type.to_s.eql?(issue.scrumable_type.to_s)}.map(&:id).uniq.join(' ')
  end
end
