namespace :disbursements do
  desc "TODO"
  task calculate: :environment do
    logger = Logger.new(STDOUT)
    logger.info "Starting disbursements calculation"

    orders = Order.pending_disbursement_calculation
    orders_group_by_day = orders.group_by { |order| order.created_at.beginning_of_day}
    days = orders_group_by_day.keys.sort

    # Add additional days so that all pending orders from weekly freq merchants can be handled. e.g. if we have orders belonging to 
    # [Sat, Sun, Mon, Tue, Wed, Thu] then orders belonging to merchant live on Monday which were placed on Tue, Wed, Thu will not be
    # disburse until there is another Monday.

    6.times do
      break if days.last == Date.today - 1.day
      days << days.last + 1.day
    end

    no_of_days = days.count
    curr_day = 0
    days.each do |day|
      logger.info "Starting disbursements calculation for day #{day}"
      merchants = Merchant.with_daily_disbursement + Merchant.got_live_on_weekday(day.strftime('%w').to_i).with_weekly_disbursement
      Disbursement.calculate(merchants, day)
      curr_day += 1

      logger.info "Finished disbursements calculation for day #{day}"
      logger.info "<======== #{curr_day}/#{no_of_days} days completed ========>"
    end

    logger.info "Finished disbursements calculation"
  end

end
