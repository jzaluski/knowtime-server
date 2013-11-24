class EstimationsController < ApplicationController
  def index_for_short_name
    now = DateTime.now
    now_minutes = now.hour * 60 + now.minute
    short_name = params[:short_name]

    stop_times = StopTime.for_short_name_and_calendars short_name, Calendar.for_date(now)
    next_stops = stop_times.select { |st| st.departure >= now_minutes }.sort! { |x, y| x.arrival <=> y.arrival }

    users = User.where short_name: short_name
    groups = UserGroup.create_groups users


    @estimations = map_estimates groups, next_stops
  end


  private


  def map_estimates groups, next_stops
    estimates = []
    options = next_stops.dup

    groups.each do |group|
      group_loc = group.average_location

      closest_index = 0
      closest_dist = Distanceable::EARTH_DIAMETER

      options.each_index do |i|
        stop_loc = options[i].stop.location
        dist = stop_loc.distance_from group_loc
        if dist < closest_dist
          closest_index = i
          closest_dist = dist
        end
      end

      opt = options.delete_at closest_index
      estimates << BusEstimation.new(opt.stop, opt.arrival, group_loc.lat, group_loc.lng)
    end

    options.each do |opt|
      estimates << BusEstimation.new(opt.stop, opt.arrival, 0, 0)
    end

    stop_numbers_seen = []
    estimates.each do |est|
      stop_number = est.next_stop.stop_number

      if stop_numbers_seen.include? stop_number
        estimates.delete est
      else
        stop_numbers_seen << stop_number
      end
    end

    estimates
  end
end