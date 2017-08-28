class Organisation < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :props

  validates :name, uniqueness: true

  def add_user(user)
    users << user unless users.include?(user)
  end
end
