class AddProductBacklogToProject < ActiveRecord::Migration
  
  class ProductBacklog < ActiveRecord::Base
    belongs_to :project
  end

  class Project < ActiveRecord::Base
    has_one :product_backlog, :class_name => "ProductBacklog"
  end

  def self.up

    Project.all.each do |project|
      product_backlog = project.create_product_backlog( name: 'Product Backlog',
                                                          updated_on: Date.today )
    end

  end

  def self.down
    ProductBacklog.delete_all
  end
end
