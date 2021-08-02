class CreateRelationValues < ActiveRecord::Migration[6.1]
  def change
    create_table :relation_values do |t|
      t.boolean :has_value, null: false, default: false
      t.timestamps
    end
  end
end
