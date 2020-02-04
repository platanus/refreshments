class SlackService
  def initialize
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end
  end

  def get_slack_users
    all_members = []
    # TODO: Use pagination instead of getting all users in one go
    # Otherwise we might run into rate limiting by Slack or simply slow responses
    client.users_list(presence: true, limit: 50) do |response|
      all_members.concat(response.members)
    end
    all_members
  end

  def  notify_user(user_name, user_id, message)
    client.chat_postMessage(
      channel: user_id,
      as_user: true,
      text: message
    )
  end

  private

  def client
    @client ||= Slack::Web::Client.new(open_timeout: 1, timeout: 1)
  end
end
