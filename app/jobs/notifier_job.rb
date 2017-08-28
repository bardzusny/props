class NotifierJob < ActiveJob::Base
  queue_as :default

  def perform(prop_id)
    notify prop(prop_id)
  rescue ActiveRecord::RecordNotFound
    Sidekiq.logger.info "Prop ##{prop_id} has already been posted or doesn't exist!"
  end

  private

  def prop(prop_id)
    Prop.not_notified.find(prop_id)
  end

  def notify(prop)
    notification = NewPropNotification.new prop
    Notifier.new(notification).call
  end
end
