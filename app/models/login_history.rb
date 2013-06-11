class LoginHistory < ActiveRecord::Base
  validates :login, presence: true
  validates :employee_id, presence: true
  belongs_to :employee
end