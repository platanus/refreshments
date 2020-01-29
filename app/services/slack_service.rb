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

  private

  def client
    @client ||= Slack::Web::Client.new
  end
end
