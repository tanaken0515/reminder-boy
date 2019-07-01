module Account::SettingsHelper
  def time_zone_options
    grouped_time_zones = ActiveSupport::TimeZone.all.group_by{|time_zone| time_zone.tzinfo.name}

    grouped_time_zones.map do |tzinfo_name, time_zones|
      display_text = "(UTC#{time_zones.first.formatted_offset}) #{time_zones.map(&:name).join(', ')}"
      [display_text, tzinfo_name]
    end
  end
end
