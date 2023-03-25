class DisbursementCalculatorJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 5.seconds, attempts: 5, jitter: 0.30

  def perform(*args)
    
    day = Date.today
    merchants = Merchant.with_daily_disbursement + Merchant.got_live_on_weekday(day.strftime('%w').to_i).with_weekly_disbursement
    Disbursement.calculate(merchants, day)

  end
end
