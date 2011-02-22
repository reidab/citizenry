class User < ActiveRecord::Base
  has_one :person
  has_many :authentications

  devise :rememberable, :trackable

  def avatar_url
    self.person.try(:avatar_url) || self.authentications.first.info[:image]
  end

  def name
    self.person.try(:name) || self.authentications.first.info[:name]
  end

  def default_authentication
    self.authentications.first
  end
end





# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  remember_token      :string(255)
#  remember_created_at :datetime
#  sign_in_count       :integer(4)      default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  admin               :boolean(1)      default(FALSE)
#

