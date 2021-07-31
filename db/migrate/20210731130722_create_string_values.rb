class CreateStringValues < ActiveRecord::Migration[6.1]
  def change
    create_table :string_values do |t|
      t.text :value, null: false, default: false
      t.text :draft_value, null: true
      t.timestamps
    end
  end
end
