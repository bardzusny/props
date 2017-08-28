class DownloadUsersJob < ActiveJob::Base
  queue_as :default

  def perform(organisation:)
    Users::DownloadUsers.new(organisation: organisation).call
  end
end
