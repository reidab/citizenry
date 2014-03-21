class UpdateLinkedinAuthentications < ActiveRecord::Migration
  def up
    execute "UPDATE people SET imported_from_provider='linkedin' WHERE imported_from_provider='linked_in'"
    execute "UPDATE authentications SET provider='linkedin' WHERE provider='linked_in'"
  end

  def down
    execute "UPDATE people SET imported_from_provider='linked_in' WHERE imported_from_provider='linkedin'"
    execute "UPDATE authentications SET provider='linked_in' WHERE provider='linkedin'"
  end
end
