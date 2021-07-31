class CreateComponents < ActiveRecord::Migration[6.1]
  def change
    create_table :components do |t|
      t.belongs_to :post, null: false
      t.references :value, polymorphic: true

      t.boolean :public, default: true, null: false
      t.string :display_class, null: true
      t.integer :order, null: false, default: 0

      t.timestamps
    end
  end
end
