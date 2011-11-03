class ContactForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :message

  validates :message, :presence => true

  def initialize(attributes = {})
    self.message = attributes[:message]
  end

  def persisted?
    false
  end

end
