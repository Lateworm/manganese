class CreatePlays < ActiveRecord::Migration[6.1]
  def change
    create_table :plays, id: :uuid do |t|
      t.references :album, null: false, foreign_key: true, type: :uuid
      t.references :event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
