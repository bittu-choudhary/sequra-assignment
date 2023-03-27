require 'rails_helper'

RSpec.describe DisbursementCalculatorJob, type: :job do
  it "should enqueue a job" do
    ActiveJob::Base.queue_adapter = :test
    expect do
      DisbursementCalculatorJob.perform_later
    end.to have_enqueued_job
  end
end
