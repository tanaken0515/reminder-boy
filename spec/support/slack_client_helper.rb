shared_context 'make_slack_client_mock_available' do
  let(:slack_client_mock) do
    double('Slack Client',
           conversations_list: conversations_list_response,
           chat_postMessage: chat_postMessage_response,
           chat_getPermalink: chat_getPermalink_response)
  end

  let(:conversations_list_response) do
    channels = [
      Slack::Messages::Message.new(id: 'C*****1', name: 'ch1', is_archived: false),
      Slack::Messages::Message.new(id: 'C*****2', name: 'ch2', is_archived: false),
      Slack::Messages::Message.new(id: 'C*****3', name: 'ch3', is_archived: true),
      Slack::Messages::Message.new(id: 'C*****4', name: 'ch4', is_archived: false),
    ]

    Slack::Messages::Message.new(ok: true, channels: channels)
  end

  let(:chat_postMessage_response) do
    icons = Slack::Messages::Message.new(emoji: ':simple_smile:')
    message = Slack::Messages::Message.new(icons: icons)

    Slack::Messages::Message.new(ok: true, ts: '1234567890.001000', message: message)
  end

  let(:chat_getPermalink_response) do
    Slack::Messages::Message.new(ok: true, permalink: 'https://*****.slack.com/archives/C*****/p*****')
  end
end
