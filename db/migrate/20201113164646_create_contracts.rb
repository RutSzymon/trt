class CreateContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.belongs_to :client, null: false, foreign_key: true
      t.belongs_to :agent, null: false
      t.belongs_to :insurance, null: false, foreign_key: true

      t.timestamps
    end
  end
end
