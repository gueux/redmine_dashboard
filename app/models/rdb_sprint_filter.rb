class RdbSprintFilter < RdbFilter

  def initialize
    super :sprint
  end

  #def scope(scope)
  #  return scope if all?
  #  byebug
  #  scope.where :sprint_id => values
  #end

  def scope(issues)
    case value
    when :all then issues
    when :product_backlog then issues.where :scrumable_type => 'ProductBacklog'
    else issues.where :scrumable_id => value, :scrumable_type => 'Sprint'
    end
  end

  def all?
    values.count >= board.sprints.count or board.sprints.empty?
  end

  def default_values
    [:all]
  end

  def valid_value?(value)
    return true if value == :all or value == :product_backlog or value.nil?
    return false unless value.respond_to?(:to_i)
    board.sprints.where(:id => value.to_i).any?
  end

  def update(params)
    return unless (sprint = params[:sprint])
    if sprint == 'all'
      self.value = :all
    elsif sprint == 'product_backlog'
      self.value = :product_backlog
    else
      self.value = sprint.to_i
    end
  end
 
  def title
    if value == :all
      I18n.t(:rdb_filter_sprint_all)
    elsif value == :product_backlog
      I18n.t(:rdb_filter_sprint_product_backlog)
    else
      values.map {|id| board.sprints.find(id) }.map(&:name).join(', ')
    end
  end
  
  def enabled?(id)
    return true if value == :all
    values.include? id
  end

end
