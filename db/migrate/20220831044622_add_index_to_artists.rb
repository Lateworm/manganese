class AddIndexToArtists < ActiveRecord::Migration[6.1]
  def change
    add_index :artists, :name, unique: true
  end
end
