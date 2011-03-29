ActiveRecord::Schema.define :version => 0 do
  create_table :sortables, :force => true do |t|
    t.column :user_id, :integer
    t.column :title, :string
  end
  
  create_table :users, :force => true do |t|
    t.column :name, :string
  end
  
  create_table :unsortables, :force => true do |t|
    t.column :title, :string
  end
end