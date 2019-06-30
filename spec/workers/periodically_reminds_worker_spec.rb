require 'rails_helper'

RSpec.describe PeriodicallyRemindsWorker, type: :worker do
  include_context 'make_slack_client_mock_available'

  let(:user01) { create(:user_with_authentication, time_zone: 'UTC') }
  let(:user02) { create(:user_with_authentication, time_zone: 'Asia/Tokyo') }

  before do
    allow(user01).to receive(:slack_client).and_return(slack_client_mock)
    Time.use_zone(user01.time_zone) do
      @reminder_at_2300_utc = create(:reminder, monday_enabled: true, scheduled_time: '23:00', user: user02)
      @reminder_at_0000_utc = create(:reminder, monday_enabled: true, scheduled_time: '00:00', user: user02)
      @reminder_at_0100_utc = create(:reminder, monday_enabled: true, scheduled_time: '01:00', user: user02)
    end

    allow(user02).to receive(:slack_client).and_return(slack_client_mock)
    Time.use_zone(user02.time_zone) do
      @reminder_at_0800_jp = create(:reminder, monday_enabled: true, scheduled_time: '08:00', user: user01)
      @reminder_at_0900_jp = create(:reminder, monday_enabled: true, scheduled_time: '09:00', user: user01)
      @reminder_at_1000_jp = create(:reminder, monday_enabled: true, scheduled_time: '10:00', user: user01)
    end
  end

  subject do
    Timecop.freeze(Time.zone.parse(execution_time)) do
      PeriodicallyRemindsWorker.new.perform
    end
  end

  context '異なるタイムゾーンで日付が異なる場合' do
    context 'UTCの月曜日の23:00(= 日本時間の火曜日の08:00)に実行すると' do
      let(:execution_time){ '2019-06-24 23:00:00' }

      it '@reminder_at_2300_utc がリマインドされ、 @reminder_at_0800_jp がリマインドされないこと' do
        subject
        expect(RemindWorker).to have_enqueued_sidekiq_job(@reminder_at_2300_utc.id)
        expect(RemindWorker).not_to have_enqueued_sidekiq_job(@reminder_at_0800_jp.id)
      end
    end

    context 'UTCの日曜日の23:00(= 日本時間の月曜日の08:00)に実行すると' do
      let(:execution_time){ '2019-06-23 23:00:00' }

      it '@reminder_at_2300_utc がリマインドされず、 @reminder_at_0800_jp がリマインドされること' do
        subject
        expect(RemindWorker).not_to have_enqueued_sidekiq_job(@reminder_at_2300_utc.id)
        expect(RemindWorker).to have_enqueued_sidekiq_job(@reminder_at_0800_jp.id)
      end
    end
  end

  context '異なるタイムゾーンで日付の境目の場合' do
    context 'UTCの月曜日の00:00(= 日本時間の月曜日の09:00)に実行すると' do
      let(:execution_time){ '2019-06-24 00:00:00' }

      it '@reminder_at_0000_utc, @reminder_at_0900_jp がリマインドされること' do
        subject
        expect(RemindWorker).to have_enqueued_sidekiq_job(@reminder_at_0000_utc.id)
        expect(RemindWorker).to have_enqueued_sidekiq_job(@reminder_at_0900_jp.id)
      end
    end

    context 'UTCの火曜日の00:00(= 日本時間の火曜日の09:00)に実行すると' do
      let(:execution_time){ '2019-06-25 00:00:00' }

      it '@reminder_at_0000_utc, @reminder_at_0900_jp がリマインドされないこと' do
        subject
        expect(RemindWorker).not_to have_enqueued_sidekiq_job(@reminder_at_0000_utc.id)
        expect(RemindWorker).not_to have_enqueued_sidekiq_job(@reminder_at_0900_jp.id)
      end
    end
  end

  context '異なるタイムゾーンで日付が同じの場合' do
    context 'UTCの月曜日の01:00(= 日本時間の月曜日の10:00)に実行すると' do
      let(:execution_time){ '2019-06-24 01:00:00' }

      it '@reminder_at_0100_utc, @reminder_at_1000_jp がリマインドされること' do
        subject
        expect(RemindWorker).to have_enqueued_sidekiq_job(@reminder_at_0100_utc.id)
        expect(RemindWorker).to have_enqueued_sidekiq_job(@reminder_at_1000_jp.id)
      end
    end

    context 'UTCの火曜日の01:00(= 日本時間の火曜日の10:00)に実行すると' do
      let(:execution_time){ '2019-06-25 01:00:00' }

      it '@reminder_at_0100_utc, @reminder_at_1000_jp がリマインドされないこと' do
        subject
        expect(RemindWorker).not_to have_enqueued_sidekiq_job(@reminder_at_0100_utc.id)
        expect(RemindWorker).not_to have_enqueued_sidekiq_job(@reminder_at_1000_jp.id)
      end
    end
  end
end
