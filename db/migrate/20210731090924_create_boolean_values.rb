class CreateBooleanValues < ActiveRecord::Migration[6.1]
  def change
    create_table :boolean_values do |t|
      t.boolean :value, null: false, default: false
      t.boolean :draft_value, null: true
      t.timestamps
    end
  end
end
