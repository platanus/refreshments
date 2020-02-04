class Api::V1::SlackController < Api::V1::BaseController
  def get_users
    result = slack.get_slack_users
    members = result.select do |member|
      !member.deleted && !non_human_names.include?(member.profile.display_name_normalized)
    end
    user_names = members.map do |m|
      { "display_name_normalized": m.profile.display_name_normalized, "id": m.id }
    end

    render json: sort_by_username(user_names)
  end

  def notify_user
    slack.notify_user(params[:user_name], params[:user_id], params[:message])
  end

  private

  def sort_by_username(user_names)
    user_names.sort do |a, b|
      a[:display_name_normalized].downcase <=> b[:display_name_normalized].downcase
    end
  end

  def non_human_names
    ['', 'Slackbot', 'apiai_bot', 'paperbot', 'todobot', 'trello']
  end

  def notify_params
    params.permit(:user_name, :user_id, :message)
  end

  def slack
    @slack ||= SlackService.new
  end
end
