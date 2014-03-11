class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :keyword
      t.index :keyword
      t.references :favorite, index: true
    end
  end
end
