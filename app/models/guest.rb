class Guest < ApplicationRecord
  has_many :reservations, :dependent => :destroy

  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true
end