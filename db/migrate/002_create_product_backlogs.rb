class CreateProductBacklogs < ActiveRecord::Migration
  
  def self.up
    create_table :product_backlogs, :force => true do |t|
      t.column :name,             :string,                            :null => false
      t.column :project_id,       :integer,                           :null => false
      t.column :updated_on,       :datetime
    end
    
    add_index :product_backlogs, [:project_id], :name => "product_backlog_project"
  end

  def self.down
    drop_table :product_backlogs
  end

end
