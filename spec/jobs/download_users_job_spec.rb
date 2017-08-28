require 'rails_helper'

RSpec.describe DownloadUsersJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_later(organisation: organisation) }
  let(:organisation) { create(:organisation) }
  let(:downloader) { instance_double('Users::DownloadUsers', call: nil) }

  before do
    allow(Users::DownloadUsers).to receive(:new) { downloader }
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'adds job to queue' do
    expect { subject }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by 1
  end

  it 'calls DownloadUsers service' do
    expect(downloader).to receive(:call)
    perform_enqueued_jobs { subject }
  end
end
