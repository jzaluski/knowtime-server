class ApplicationController < ActionController::Base

  protected

  def render_error status, message = nil
    status = convert_status status
    message = default_message status if message.nil?
    render text: "{\"status\":\"#{status}\",\"error\":\"#{message.to_s}\"}", status: status
  end

  def time_from_params
    begin
      Time.zone.parse( params[:time] || params[:date] ).tap do |time|
        logger.info "Using user-provided '#{time}' instead of current time"
      end
    rescue
      nil
    end or Time.zone.now
  end

  private

  def convert_status status
    case status
      when 404, :not_found
        '404'
      else
        '599'
    end
  end

  def default_message status
    case status
      when 404, :not_found
        'not found'
      else
        'could not complete request'
    end
  end

  def correct_admin_uuid?
    params[:admin_uuid] == SECRETS['knowtime']['admin_uuid']
  end
end
