json.ignore_nil!

json.response do
  json.status do 
    if !@has_error
      if @status.present?
        json.code api_status[@status][:code] || api_status[:ok][:code]
      elsif @status.blank?
        json.code api_status[:ok][:code]
      end
    elsif @has_error
      json.code api_status[:api_error][:code]
    end
    json.timestamp Time.current
  end

  if @alert
    json.alert do
      json.message @alert[:msg]
      json.type @alert[:type]
    end
  else
    json.alert Hash.new
  end

  json.error do
    if @error_msg.present?
      json.message @error_msg[:msg]
      Rails.logger.debug @error_msg[:msg] unless Rails.env.production?
    elsif @error_msg.blank?
      # Don't show error message block
    end

    json.errors do
      json.array! @errors do |e|
        Rails.logger.debug e unless Rails.env.production?
        if e[:status].present?
          json.code api_error[e[:status]][:code]
          json.message api_error[e[:status]][:msg]
        elsif e[:status].blank?
          json.code e[:code] || api_error[:unknown_error][:code]
          json.message e[:msg] || api_error[:unknown_error][:msg]
        end
      end
    end
  end

  if @data
    json.data @data
  else
    json.data JSON.parse(yield)
  end
end