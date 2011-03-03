class SignInData
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::Naming

  attr_accessor :email, :provider

  validates :provider, :presence => true
  validates :email, :presence => true

  def initialize(params = {})
    params ||= {}
    self.email = params[:email]
    self.provider = params[:provider]
  end

  def persisted?
    false
  end
end
