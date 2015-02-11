# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'projects/:id/rdb/taskboard'        => 'rdb_taskboard#index',  :as => :rdb_taskboard,        via: [:get, :post]
match 'projects/:id/rdb/taskboard/move'   => 'rdb_taskboard#move',   :as => :rdb_taskboard_move,   via: [:get, :post]
match 'projects/:id/rdb/taskboard/update' => 'rdb_taskboard#update', :as => :rdb_taskboard_update, via: [:get, :post]
match 'projects/:id/rdb/taskboard/filter' => 'rdb_taskboard#filter', :as => :rdb_taskboard_filter, via: [:get, :post]

#match 'projects/:id/dashboard(/:board)'   => 'rdb_dashboard#index', :as => :rdb, via: [:get, :post]
match 'projects/:id/dashboard'            => 'rdb_dashboard#index', via: [:get, :post]

# Additional Scrumban functionality
match 'projects/:id/rdb/scrumban'        => 'rdb_scrumban#index',  :as => :rdb_scrumban,        via: [:get, :post]
match 'projects/:id/rdb/scrumban/move'   => 'rdb_scrumban#move',   :as => :rdb_scrumban_move,   via: [:get, :post]
match 'projects/:id/rdb/scrumban/update' => 'rdb_scrumban#update', :as => :rdb_scrumban_update, via: [:get, :post]
match 'projects/:id/rdb/scrumban/filter' => 'rdb_scrumban#filter', :as => :rdb_scrumban_filter, via: [:get, :post]

match 'projects/:project_id/rdb/sprint/new'      => 'rdb_sprints#new',      :as => :rdb_sprint_new,      via: [:get, :post]
match 'projects/:project_id/rdb/sprint/create'   => 'rdb_sprints#create',   :as => :rdb_sprint_create,   via: [:get, :post]
match 'projects/:project_id/rdb/sprint/:id/edit'     => 'rdb_sprints#edit',     :as => :rdb_sprint_edit,     via: [:get, :post]
match 'projects/:project_id/rdb/sprint/:id/update'   => 'rdb_sprints#update',   :as => :rdb_sprint_update,   via: [:put]
match 'projects/:project_id/rdb/sprint/:id/delete'   => 'rdb_sprints#delete',   :as => :rdb_sprint_delete,   via: [:delete]
