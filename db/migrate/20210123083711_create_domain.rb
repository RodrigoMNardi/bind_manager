class CreateDomain < ActiveRecord::Migration[5.2]
  def change
    create_table :domains do |t|
      t.string :zone,              null: false
      t.string :mode,              null: false
      t.string :file,              null: false
      t.string :allow_transfer,    null: false

      t.timestamps                 null: false
    end
  end
end
