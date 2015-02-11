class AddSprintAndProductBacklogToIssues < ActiveRecord::Migration  

  def self.up

    change_table :issues do |i|

      i.references :scrumable, :polymorphic => true
      add_index :issues, [:scrumable_id], :name => "scrumable_id"

    end
  end

  def self.down
    remove_column :issues, :scrumable_id
    remove_column :issues, :scrumable_type
  end

end
