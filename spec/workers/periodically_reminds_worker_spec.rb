require 'rails_helper'

RSpec.describe PeriodicallyRemindsWorker, type: :worker do
  include_context 'make_slack_client_mock_available'

  let(:user01) { create(:user_with_authentication) }
  let(:user02) { create(:user_with_authentication) }

  before do
    allow(user01).to receive(:slack_client).and_return(slack_client_mock)
    allow(user01).to receive(:time_zone).and_return('UTC')
    Time.use_zone(user01.time_zone) do
      @reminder_at_2300_utc = create(:reminder, monday_enabled: true, scheduled_time: '23:00', user: user02)
      @reminder_at_0000_utc = create(:reminder, monday_enabled: true, scheduled_time: '00:00', user: user02)
      @reminder_at_0100_utc = create(:reminder, monday_enabled: true, scheduled_time: '01:00', user: user02)
    end

    allow(user02).to receive(:slack_client).and_return(slack_client_mock)
    allow(user02).to receive(:time_zone).and_return('Asia/Tokyo')
    Time.use_zone(user02.time_zone) do
      @reminder_at_0800_jp = create(:reminder, monday_enabled: true, scheduled_time: '08:00', user: user01)
      @reminder_at_0900_jp = create(:reminder, monday_enabled: true, scheduled_time: '09:00', user: user01)
      @reminder_at_1000_jp = create(:reminder, monday_enabled: true, scheduled_time: '10:00', user: user01)
    end
  end

  context '異なるタイムゾーンで日付が異なる場合' do
    context 'UTCの月曜日の23:00(= 日本時間の火曜日の08:00)に実行すると' do
      before do
        # time freeze
      end

      it '@reminder_at_2300_utc がリマインドされること' do
        skip 'Not implemented'
      end
    end

    context 'UTCの日曜日の23:00(= 日本時間の月曜日の08:00)に実行すると' do
      before do
        # time freeze
      end

      it '@reminder_at_0800_jp がリマインドされること' do
        skip 'Not implemented'
      end
    end
  end

  context '異なるタイムゾーンで日付の境目の場合' do
    context 'UTCの月曜日の00:00(= 日本時間の月曜日の09:00)に実行すると' do
      before do
        # time freeze
      end

      it '@reminder_at_2400_utc, @reminder_at_0900_jp がリマインドされること' do
        skip 'Not implemented'
      end
    end

    context 'UTCの火曜日の00:00(= 日本時間の火曜日の09:00)に実行すると' do
      before do
        # time freeze
      end

      it 'リマインドされないこと' do
        skip 'Not implemented'
      end
    end
  end

  context '異なるタイムゾーンで日付が同じの場合' do
    context 'UTCの月曜日の01:00(= 日本時間の月曜日の10:00)に実行すると' do
      before do
        # time freeze
      end

      it '@reminder_at_0100_utc, @reminder_at_1000_jp がリマインドされること' do
        skip 'Not implemented'
      end
    end

    context 'UTCの火曜日の01:00(= 日本時間の火曜日の10:00)に実行すると' do
      before do
        # time freeze
      end

      it 'リマインドされないこと' do
        skip 'Not implemented'
      end
    end
  end
end
