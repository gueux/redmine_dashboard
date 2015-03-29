require_dependency 'issue'

module Scrum
  module IssuePatch
    def self.included(base)

      base.class_eval do
        
        belongs_to :scrumable, polymorphic: true # class_name: 'Sprint', polymorphic: true

        #acts_as_list :scope => :scrumable

        safe_attributes :scrumable_id #, :unless issue.scrumable_id.nil?
        safe_attributes :scrumable_type #, :unless issue.scrumable_type.nil?

        
        #before_save :move_issue_to_product_backlog, :unless => lambda {|issue| issue.is_in_product_backlog? }
        #before_save :move_issue_to_sprint, :unless => is_in_sprint?

        def is_in_product_backlog?
          issue.product_backlog?
        end
        
        def is_in_sprint?
          issue.sprint?
        end
        
        def last_updated_by (no_default = false)
          sqlStr = ""
          if ActiveRecord::Base.connection.adapter_name == "SQLite"
            sqlStr = "select (u.firstname || ' ' || u.lastname) as name"
          else #postgre and mysql
            sqlStr = "select CONCAT_WS(' ', u.firstname, u.lastname) as name"
          end
          _sql = sqlStr + ", u.id as id, u.login as login from #{Journal.table_name} as j1 inner join #{User.table_name} as u on u.id = j1.user_id where journalized_type  = 'Issue' and journalized_id = #{id} order by j1.id DESC limit 1"
          result = ActiveRecord::Base.connection.select_one _sql
          updated_by_name = ""
          updated_by_id = nil
          if !result.nil?
            updated_by_id = result["id"].to_i
            updated_by_name = result["name"]
            updated_by_login = result["login"]
          elsif !no_default
            updated_by_id = self.author.id
            updated_by_name = self.author.name
            updated_by_login = self.author.login
          end
          @last_updated_by ||= {:name => updated_by_name, :id => updated_by_id, :login => updated_by_login}
        end

        def last_updated_by_name
          @last_updated_by_name ||= self.last_updated_by(true)[:name]
        end

      private

        def move_issue_to_product_backlog
          self.product_backlog = issue.product_backlog
        end

        def move_issue_to_sprint
          self.sprint = issue.product_backlog
        end

        #def move_issue_to_the_begin_of_the_sprint
        #  min_position = nil
        #  sprint.pbis.each do |pbi|
        #    min_position = pbi.position if min_position.nil? or (pbi.position < min_position)
        #  end
        #  self.position = min_position.nil? ? 1 : (min_position - 1)
        #end

        #def move_issue_to_the_end_of_the_sprint
        #  max_position = nil
        #  sprint.pbis.each do |pbi|
        #    max_position = pbi.position if max_position.nil? or (pbi.position > max_position)
        #  end
        #  self.position = max_position.nil? ? 1 : (max_position + 1)
        #end

      end
    end
  end
end
