class CreateRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :recommendations, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :album, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
