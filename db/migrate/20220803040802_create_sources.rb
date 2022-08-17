class CreateSources < ActiveRecord::Migration[6.1]
  def change
    create_table :sources, id: :uuid do |t|
      t.string :url
      t.references :album, null: false, foreign_key: true, type: :uuid
      t.references :service, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
