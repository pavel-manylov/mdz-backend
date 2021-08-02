class CreateCustomFields < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_fields do |t|
      t.belongs_to :component
      t.string :name, null: false
      t.string :value, null: false
      t.timestamps
    end
  end
end
