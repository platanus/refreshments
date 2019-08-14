class GetRankedUsers < PowerTypes::Command.new(:rankable_users)
  def perform
    ranked_users
  end

  private

  def ranked_users
    @rankable_users.shuffle.sort_by { |user| -user.collected_fee }
  end
end
