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

  describe 'scopes' do
    let(:user) { create(:user_with_authentication) }
    before do
      allow(user).to receive(:slack_client).and_return(slack_client_mock)
    end

    describe 'from_latest' do
      before do
        create(:reminder, message: 'a', user: user)
        create(:reminder, message: 'b', user: user)
        create(:reminder, message: 'c', user: user)
        create(:reminder, message: 'd', user: user)
        create(:reminder, message: 'e', user: user)
      end

      it '新しい順になっていること' do
        expect(Reminder.from_latest.pluck(:message)).to eq %w(e d c b a)
      end
    end

    describe 'holiday_included' do
      before do
        create(:reminder, message: 'a', holiday_included: false, user: user)
        create(:reminder, message: 'b', holiday_included: true, user: user)
        create(:reminder, message: 'c', holiday_included: true, user: user)
      end

      it '祝日通知ONのデータだけ取得されること' do
        expect(Reminder.holiday_included.pluck(:message)).to match_array %w(b c)
      end
    end

    describe 'enabled_on_day_of_week' do
      before do
        create(:reminder, message: 'a', sunday_enabled: true, monday_enabled: true, user: user)
        create(:reminder, message: 'b', sunday_enabled: false, monday_enabled: true, user: user)
        create(:reminder, message: 'c', sunday_enabled: true, monday_enabled: false, user: user)
        create(:reminder, message: 'd', sunday_enabled: false, monday_enabled: true, user: user)
        create(:reminder, message: 'e', sunday_enabled: true, monday_enabled: false, user: user)
      end

      it '日曜(wday=0)のデータだけ取得されること' do
        expect(Reminder.enabled_on_day_of_week(0).pluck(:message)).to match_array %w(a c e)
      end

      it '月曜(wday=1)のデータだけ取得されること' do
        expect(Reminder.enabled_on_day_of_week(1).pluck(:message)).to match_array %w(a b d)
      end

      context '想定外の引数(0..6以外)が渡された場合' do
        it 'データが取得されないこと' do
          expect(Reminder.enabled_on_day_of_week(7)).to be_empty
        end
      end
    end

    describe 'active_on_date' do
      before do
        create(:reminder, message: 'a', monday_enabled: true, holiday_included: true, user: user)
        create(:reminder, message: 'b', monday_enabled: true, holiday_included: false, user: user)
        create(:reminder, message: 'c', monday_enabled: false, holiday_included: true, user: user)
        create(:reminder, message: 'd', monday_enabled: true, holiday_included: true, user: user)
        create(:reminder, message: 'e', monday_enabled: false, holiday_included: false, user: user)
      end

      context '祝日でない月曜日(2019/7/8)の場合' do
        it '月曜のデータが取得されること' do
          expect(Reminder.active_on_date(Date.new(2019, 7, 8)).pluck(:message)).to match_array %w(a b d)
        end
      end

      context '祝日の月曜日(2019/7/15)の場合' do
        it '月曜かつ祝日ONのデータが取得されること' do
          expect(Reminder.active_on_date(Date.new(2019, 7, 15)).pluck(:message)).to match_array %w(a d)
        end
      end
    end

    describe 'scheduled_between' do
      before do
        create(:reminder, message: 'a', scheduled_time: '07:00', user: user)
        create(:reminder, message: 'b', scheduled_time: '15:00', user: user)
        create(:reminder, message: 'c', scheduled_time: '23:00', user: user)
      end
      let(:reminders) { Reminder.scheduled_between(from, to) }

      let(:from) { Time.zone.parse('2019-07-01 07:00:00') }
      let(:to) { Time.zone.parse('2019-07-01 15:00:00') }
      it '範囲内のデータが取得されること' do
        expect(reminders.pluck(:message)).to match_array %w(a b)
      end

      context '範囲が日付を跨いでいるために、時刻だけみると大小関係が逆転している場合' do
        let(:from) { Time.zone.parse('2019-07-01 23:00:00') }
        let(:to) { Time.zone.parse('2019-07-02 07:00:00') }
        it '正しく取得されること' do
          expect(reminders.pluck(:message)).to match_array %w(a c)
        end
      end

      context '引数の大小関係が逆転している場合' do
        let(:from) { Time.zone.parse('2019-07-02 23:00:00') }
        let(:to) { Time.zone.parse('2019-07-01 07:00:00') }
        it 'データが取得されないこと' do
          expect(reminders).to be_empty
        end
      end
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
