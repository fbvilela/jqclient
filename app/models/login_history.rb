class LoginHistory < ActiveRecord::Base
  attr_accessible :employee_id, :name, :login
  validates :login, presence: true
  validates :employee_id, presence: true
  belongs_to :employee
end