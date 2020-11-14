class CreateContactships < ActiveRecord::Migration[6.0]
  def change
    create_table :contactships do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :contact, null: false

      t.timestamps
    end
  end
end
