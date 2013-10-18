class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :name
      t.string :user
      t.boolean :is_public
      t.string :plugin
      t.text :options
    end
  end
end
