module Scrum
  class IssuesHookListener < Redmine::Hook::ViewListener
    
    render_on(:view_issues_form_details_bottom,      :partial => "issues_hooks/form")
    render_on(:view_issues_show_details_bottom,      :partial => "issues_hooks/show")
    #Rails.logger.info "Im in the issue hook listener"
  end
end
