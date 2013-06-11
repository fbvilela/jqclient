class AddLoginHistory < ActiveRecord::Migration
  def change
    create_table :login_histories do |t|
      
      t.column :employee_id, :integer
      t.column :login, :string
      t.column :name, :string
      t.timestamps
      
    end
  end
end
