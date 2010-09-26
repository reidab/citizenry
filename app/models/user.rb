class User < ActiveRecord::Base
  has_one :person
end
