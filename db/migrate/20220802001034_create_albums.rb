class CreateAlbums < ActiveRecord::Migration[6.1]
  def change
    create_table :albums, id: :uuid do |t|
      t.string :name, null: false
      t.references :artist, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
