class User < ActiveRecord::Base
  attr_protected :admin

  has_paper_trail :ignore => [:remember_token, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_ip, :last_sign_in_ip, :updated_at]

  has_one :person
  has_many :authentications, :dependent => :destroy do
    def info_get(key)
      info_with_key = self.map(&:info).compact.detect{|info| info[key].present? }
      return info_with_key[key] if info_with_key.present?
    end
  end

  devise :rememberable, :trackable

  def avatar_url
    self.person.try(:photo).try(:url, :thumb) || self.authentications.info_get(:image)
  end

  def name
    self.person.try(:name) || self.authentications.info_get(:name) || "User #{self.id}"
  end

  def label_for_admin
    "#{self.id}: #{self.name} #{self.person.present? ? '*' : ''}"
  end

  def default_authentication
    self.authentications.first
  end

  def has_auth_from?(provider)
    self.authentications.via(provider).present?
  end

  SAMPLE_USER = {
    :email => "sample@sample.org",
    :admin => true,
  }

  def self.find_sample
    return self.where(:email => User::SAMPLE_USER[:email]).first
  end

  def self.find_or_create_sample(create_backreference=true)
    user = self.find_sample
    unless user
      user = self.create!(SAMPLE_USER)
    end
    if create_backreference && ! user.person
      person = Person.find_or_create_sample(false)
      user.person = person
      user.save!
    end
    return user
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
#  email               :string(255)
#

