require 'rails_helper'

RSpec.describe Reminder, type: :model do
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

  describe '#valid?' do
    let(:user) { create(:user_with_authentication) }
    let(:slack_channel_id) { 'C*****1' }
    let(:scheduled_time) { '09:00' }
    let(:reminder) { user.reminders.new(message: 'test', slack_channel_id: slack_channel_id, scheduled_time: scheduled_time) }

    before do
      allow(user).to receive(:slack_client).and_return(slack_client_mock)
    end

    describe 'slack_channel_id' do
      context 'チャンネルリストに含まれている場合' do
        it 'true' do
          expect(reminder.valid?).to be true
        end
      end

      context 'チャンネルリストに含まれていない場合' do
        let(:slack_channel_id) { 'C*****3' }

        it 'false' do
          expect(reminder.valid?).to be false
          expect(reminder.errors.messages[:slack_channel_id].include?('is not included in active channel list')).to be true
        end
      end
    end

    describe 'scheduled_time' do
      context '時刻リストに含まれている場合' do
        it 'true' do
          expect(reminder.valid?).to be true
        end
      end

      context '時刻リストに含まれていない場合' do
        let(:scheduled_time) { '09:01' }

        it 'false' do
          expect(reminder.valid?).to be false
          expect(reminder.errors.messages[:scheduled_time].include?('is not included in scheduled time list')).to be true
        end
      end
    end
  end

  xdescribe 'scopes' do
    before do
      'create some reminders'
    end

    describe 'from_latest' do

    end

    describe 'holiday_included' do

    end

    describe 'enabled_on_day_of_week' do

    end

    describe 'active_on_date' do

    end

    describe 'scheduled_between' do

    end
  end

  xdescribe '#enabled_day_of_weeks' do

  end

  xdescribe '#everyday?' do

  end

  xdescribe '#weekday?' do

  end

  xdescribe '#holiday?' do

  end

  xdescribe '#post' do

  end

  xdescribe '#remind!' do

  end
end
