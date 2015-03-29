module Scrum
  class IssuesHookListener < Redmine::Hook::ViewListener
    
    render_on(:view_issues_form_details_bottom,      :partial => "issues_hooks/form")
    render_on(:view_issues_show_details_bottom,      :partial => "issues_hooks/show")
    render_on(:view_issues_context_menu_start,       :partial => "issues_hooks/context_menu")
    #Rails.logger.info "Im in the issue hook listener"
  end
end
