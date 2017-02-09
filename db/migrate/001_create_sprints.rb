class CreateSprints < ActiveRecord::Migration
  def self.up
    create_table :sprints, :force => true do |t|
      t.column :name,             :string,                            :null => false
      t.column :description,      :text
      t.column :project_id,       :integer,                           :null => false
      t.column :start_date,       :date,                              :null => false
      t.column :end_date,         :date,                              :null => false
      t.column :updated_on,       :datetime
      t.column :closed,           :boolean
    end

    add_index :sprints, [:name], :name => "sprints_name"
    add_index :sprints, [:project_id], :name => "sprints_project"
  end

  def self.down
    drop_table :sprints
  end
end