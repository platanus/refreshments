class Api::V1::SlackController < Api::V1::BaseController
  def get_users
    result = slack.get_slack_users
    members = result.select do |member|
      !member.deleted &&
        member.profile.display_name_normalized != "" &&
        member.profile.display_name_normalized != "Slackbot" &&
        member.profile.display_name_normalized != "apiai_bot" &&
        member.profile.display_name_normalized != "paperbot" &&
        member.profile.display_name_normalized != "todobot" &&
        member.profile.display_name_normalized != "trello"
    end
    user_names = members.map { |m| m.profile.display_name_normalized }
    user_names

    render json: user_names
  end

  private

  def slack
    @slack ||= SlackService.new
  end
end
