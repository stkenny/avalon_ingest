class CreateTableMediaObjects < ActiveRecord::Migration
  def change
    create_table :media_objects do |t|
      t.string :collection
      t.timestamps null: false
    end
  end
end
