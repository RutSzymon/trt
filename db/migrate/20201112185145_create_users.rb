class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :type, index: true
      t.integer :contacts_count, default: 0, index: true

      t.timestamps
    end
  end
end
