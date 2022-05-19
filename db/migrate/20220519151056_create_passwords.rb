class CreatePasswords < ActiveRecord::Migration[5.2]
  def change
    create_table :passwords do |t|

      t.timestamps
    end
  end
end
