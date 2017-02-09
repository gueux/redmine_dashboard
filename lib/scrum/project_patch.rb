require_dependency 'project'

module Scrum
  module ProjectPatch
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do

        has_one :product_backlog, class_name: 'ProductBacklog'
        has_many :sprints, -> { order(start_date: :asc, name: :asc) }, class_name: 'Sprint', dependent: :delete_all

        #def last_sprint
        #  sprints.sort{|a, b| a.end_date <=> b.end_date}.last
        #end
      end

    end

    module ClassMethods
    end

    module InstanceMethods
    end

  end
end

