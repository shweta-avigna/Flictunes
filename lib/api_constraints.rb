class ApiConstraints

  ACCEPT_HEADER_PREFIX = "application/com.flictunes.v"

  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    accept_header = req.headers['Accept']
    if (accept_header.present? && accept_header.include?("#{ACCEPT_HEADER_PREFIX}#{@version}"))
      return true
    elsif accept_header.blank? || accept_header.include?("*/*")
      return @default
    else
      return false
    end
  end
end