shared_context 'weekly_setting' do
end

shared_context 'weekly_schedule_utc' do
  let(:sun_time1) { Time.parse('2017-03-04 15:00:00 +00:00') }
  let(:sun_time2) { Time.parse('2017-03-04 16:00:00 +00:00') }
  let(:sun_time3) { Time.parse('2017-03-04 16:00:00 +00:00') }

  let(:mon_time1) { Time.parse('2017-03-06 13:00:00 +00:00') }
  let(:mon_time2) { Time.parse('2017-03-06 14:00:00 +00:00') }
  let(:mon_time3) { Time.parse('2017-03-06 15:00:00 +00:00') }

  let(:tue_time1) { Time.parse('2017-03-07 12:00:00 +00:00') }
  let(:tue_time2) { Time.parse('2017-03-07 13:00:00 +00:00') }
  let(:tue_time3) { Time.parse('2017-03-07 14:00:00 +00:00') }

  let(:wed_time1) { Time.parse('2017-07-08 03:00:00 +00:00') }
  let(:wed_time2) { Time.parse('2017-07-08 04:00:00 +00:00') }

  let(:thu_time1) { Time.parse('2017-07-09 13:00:00 +00:00') }
  let(:thu_time2) { Time.parse('2017-07-09 14:00:00 +00:00') }

  let(:fri_time1) { Time.parse('2017-07-09 15:00 +00:00') }
  # no schedule for saturday
  let(:sample_weekly_schedule) do
    ::Teki::Config::WeeklySchedule.create(
      sunday: { sun_time1 => 2, sun_time2 => 4, sun_time3 => 4 },
      monday: { mon_time1 => 1, mon_time2 => 1, mon_time3 => 1 },
      tuesday: { tue_time1 => 3, tue_time2 => 4, tue_time3 => 3 },
      wednesday: { wed_time1 => 1, wed_time2 => 4 },
      thursday: { thu_time1 => 2, thu_time2 => 2 },
      friday: { fri_time1 => 3 },
      saturday: nil,
    )
  end
end
