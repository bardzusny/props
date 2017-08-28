class User < ActiveRecord::Base
  validates :name, presence: true
  validates :uid, uniqueness: { scope: :provider }
  has_many :props, through: :prop_receivers
  has_many :prop_receivers
  has_many :memberships
  has_many :organisations, through: :memberships

  def to_s
    name
  end

  def self.create_with_omniauth(auth)
    Users::CreateFromOmniauth.new(auth: auth).call
  end

  def self.create_from_slack(member)
    create! slack_attrs(member)
  end

  def self.slack_attrs(member)
    # TODO: check this OUT! It may be obsolete code.
    {
      provider: 'slack',
      uid: member['id'],
      name: member['profile']['real_name'] || '',
      email: member['profile']['email'] || '',
    }
  end
end
