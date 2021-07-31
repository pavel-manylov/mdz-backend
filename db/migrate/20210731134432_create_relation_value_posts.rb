class CreateRelationValuePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :relation_value_posts do |t|
      t.belongs_to :relation_value
      t.belongs_to :post

      t.timestamps
    end
  end
end
