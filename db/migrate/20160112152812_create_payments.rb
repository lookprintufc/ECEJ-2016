class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :method
      t.integer :portions
      t.integer :portion_paid
      t.float :price
      t.string :link_1
      t.string :link_2
      t.string :link_3
      t.string :link_4

      t.timestamps null: false
    end
  end
end
