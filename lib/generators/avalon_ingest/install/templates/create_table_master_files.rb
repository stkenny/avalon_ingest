class CreateTableMasterFiles < ActiveRecord::Migration
  def change
    create_table :master_files do |t|
      t.references :media_object, index: true, foreign_key: true
      t.string :status_code
      t.string :file_size
      t.string :file_location
      t.timestamps null: false
    end
  end
end
