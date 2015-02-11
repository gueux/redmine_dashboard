class RdbScrumColumn
  attr_accessor :board
  attr_reader :id, :name, :options, :scrumable_id, :board, :scrumable_type

  def initialize(id, scrumable_id, scrumable_type, name, options = {})
    @id = id.to_s
    @scrumable_id = scrumable_id.to_i
    @scrumable_type = scrumable_type
    @name = name
    @options  = options
  end

  def scope(issue_scope)
    issue_scope.where :scrumable_id => @scrumable_id, :scrumable_type => @scrumable_type
  end

  def issues
    @issues ||= board.issues_for(self)
  end

  def sprint
    Sprint.find(scrumable_id) if scrumable_type == 'Sprint'
  end

  def percentage
    all_issue_count = board.issues.select {|i| i.children.empty?}.count
    all_issue_count > 0 ? ((issues.count.to_f / all_issue_count) * 100).round(4) : 0
  end

  def title
    name.is_a?(Symbol) ? I18n.translate(name) : name.to_s
  end

  def compact?
    !!options[:compact]
  end

  def visible?
    !options[:hide]
  end

  def is_sprint?
    scrumable_type.eql?('Sprint')
  end
end
