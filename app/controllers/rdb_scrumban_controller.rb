class RdbScrumbanController < RdbDashboardController
  menu_item :dashboard

  def board_type; RdbScrumban end
  #def board_type; RdbTaskboard end

  def move
    return flash_error(:rdb_flash_invalid_request) unless column = @board.columns[params[:column].to_s]
    # Ignore workflow if user is admin
    #if User.current.admin?
    #  @statuses = column.statuses
    #else
    #  # Get all status the user is allowed to assign and that are in the target column
    #  @statuses = @issue.new_statuses_allowed_to(User.current) & column.statuses
    #end

    #if @statuses.empty?
    #  return flash_error :rdb_flash_illegal_workflow_action,
    #    :issue => @issue.subject, :source => @issue.status.name, :target => column.title
    #end

    # Show dialog if more than one status are available
    #return render 'rdb_dashboard/scrumban/column_dialog' if @statuses.count > 1

    params[:scrumable_id] = column.scrumable_id
    params[:scrumable_type] = column.scrumable_type
    update
  end

  def update
    @issue.init_journal(User.current, params[:notes] || nil)

    @issue.done_ratio = params[:done_ratio].to_i if params[:done_ratio]
    @issue.assigned_to_id = nil if params[:unassigne_me] && @issue.assigned_to_id == User.current.id
    @issue.assigned_to_id = User.current.id if params[:assigne_me]

    @issue.scrumable_id = params[:scrumable_id].to_i if params[:scrumable_id]
    @issue.scrumable_type = params[:scrumable_type].to_s if params[:scrumable_type]

    if params[:status]
      status = IssueStatus.find params[:status].to_i
      if @issue.new_statuses_allowed_to(User.current).include?(status) or User.current.admin?
        @issue.status         = status
        @issue.assigned_to_id = User.current.id if @board.options[:change_assignee]
      else
        return flash_error :rdb_flash_illegal_workflow_action,
          :issue => @issue.subject, :source => @issue.status.name, :target => @status.name
      end
    end

    @issue.save

    render 'index'
  end
end
