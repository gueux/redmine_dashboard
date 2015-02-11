require 'redmine'
require 'haml'
require 'byebug'

Rails.configuration.to_prepare do
  require 'rdb/rails/i18n'

  Project.send(:include, Scrum::ProjectPatch)
  Issue.send(:include, Scrum::IssuePatch)
end

#require_dependency 'scrum/issue_patch'
require_dependency 'scrum/issues_hook_listener'

Redmine::Plugin.register :redmine_dashboard do
  name 'Redmine Dashboard plugin'
  author 'Jan Graichen'
  description 'Add a task board and a planning board to Redmine'
  version '2.4.0'
  url 'https://github.com/jgraichen/redmine_dashboard'
  author_url 'mailto:jg@altimos.de'

  requires_redmine :version_or_higher => '2.1'

  project_module :scrumban do
    permission :view_dashboards, {
      :rdb_dashboard => [:index ],
      :rdb_taskboard => [:index, :filter, :move, :update ], 
      :rdb_scrumban  => [:index, :filter, :move, :update ] }
    permission :configure_dashboards, { :rdb_dashboard => [:configure] }
  end
  menu :project_menu, :scrumban, { :controller => 'rdb_taskboard', :action => 'index' },
    :caption => :menu_label_scrumban, :after => :new_issue

end
