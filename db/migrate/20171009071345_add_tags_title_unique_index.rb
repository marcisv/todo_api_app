class AddTagsTitleUniqueIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :tags, :title, unique: true
  end
end
