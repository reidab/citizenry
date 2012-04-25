class Updatelinkedinpersons < ActiveRecord::Migration
  def up
    execute "UPDATE `people` SET imported_from_provider='linkedin' where imported_from_provider='linked_in'"
    execute "UPDATE `authentications` SET provider='linkedin' where provider='linked_in'"    
  end

  def down
    execute "UPDATE `people` SET imported_from_provider='linked_in' where imported_from_provider='linkedin'"
    execute "UPDATE `authentications` SET provider='linked_in' where provider='linkedin'"

  end
end
