class RankingsController < ApplicationController
  def index
    @fee_balance = GetFeeBalance.for
    @users = GetRankedUsers.for(rankable_users: valid_users)
  end

  private

  def valid_users
    User.all_except(ENV.fetch("BUSINESS_USER_ID"))
  end
end
