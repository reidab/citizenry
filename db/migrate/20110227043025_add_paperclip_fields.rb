class AddPaperclipFields < ActiveRecord::Migration
  def self.up
    add_column :people,     :photo_file_name,    :string
    add_column :people,     :photo_content_type, :string
    add_column :people,     :photo_file_size,    :integer
    add_column :people,     :photo_updated_at,   :datetime

    add_column :companies,  :logo_file_name,     :string
    add_column :companies,  :logo_content_type,  :string
    add_column :companies,  :logo_file_size,     :integer
    add_column :companies,  :logo_updated_at,    :datetime

    add_column :groups,     :logo_file_name,     :string
    add_column :groups,     :logo_content_type,  :string
    add_column :groups,     :logo_file_size,     :integer
    add_column :groups,     :logo_updated_at,    :datetime

    add_column :projects,   :logo_file_name,     :string
    add_column :projects,   :logo_content_type,  :string
    add_column :projects,   :logo_file_size,     :integer
    add_column :projects,   :logo_updated_at,    :datetime
  end

  def self.down
    remove_column :people,     :photo_file_name
    remove_column :people,     :photo_content_type
    remove_column :people,     :photo_file_size
    remove_column :people,     :photo_updated_at

    remove_column :companies,  :logo_file_name
    remove_column :companies,  :logo_content_type
    remove_column :companies,  :logo_file_size
    remove_column :companies,  :logo_updated_at

    remove_column :groups,     :logo_file_name
    remove_column :groups,     :logo_content_type
    remove_column :groups,     :logo_file_size
    remove_column :groups,     :logo_updated_at

    remove_column :projects,   :logo_file_name
    remove_column :projects,   :logo_content_type
    remove_column :projects,   :logo_file_size
    remove_column :projects,   :logo_updated_at
  end
end
