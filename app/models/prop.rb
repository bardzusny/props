class Prop < ActiveRecord::Base
  USER_LIMIT = 15
  private_constant :USER_LIMIT

  has_many :users, through: :prop_receivers
  has_many :prop_receivers
  has_many :upvotes
  belongs_to :propser, class_name: 'User'
  belongs_to :organisation

  validates :organisation, presence: true
  validates :propser, presence: true
  validate :prop_receivers?, :valid_prop_receivers?, :selfpropsing, :receivers_limit
  validates :body,
            presence: true,
            format: /\A(?!.*( |\W|\A)(@here|@channel|@everyone)( |\W|\z)).*\z/m

  scope :with_includes, -> { includes(:users, :propser) }
  scope :ordered, -> { order('props.created_at DESC') }
  scope :not_notified, -> { where(slack_ts: nil) }
  scope :oldest_first, -> { order(:created_at) }

  def rating
    upvotes_count
  end

  private

  def prop_receivers?
    return if prop_receivers.any?
    errors.add(:user_ids, I18n.t('props.errors.no_users'))
  end

  def valid_prop_receivers?
    prop_receivers.flat_map(&:errors).each do |error|
      errors[:user_ids].push(error[:user_id]) if error[:user_id].present?
    end
  end

  def selfpropsing
    return if prop_receivers.none? { |r| r.user_id == propser_id }
    errors.add(:user_ids, I18n.t('props.errors.selfpropsing'))
  end

  def receivers_limit
    return if prop_receivers.length <= USER_LIMIT
    errors.add(:user_ids, I18n.t('props.errors.user_limit'))
  end
end
