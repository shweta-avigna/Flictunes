module ApiDeviceHeaderGetters
  extend ActiveSupport::Concern

  included do
    
    # Get device header values
    before_action :get_device_density
    before_action :get_device_type
    before_action :get_device_dimensions
    
    # Pass device headers
    before_action :ensure_device_headers_are_passed
    
    def get_device_density
      @device_density = request.headers[::ApiConstants::APP_HEADER_DEVICE_DENSITY_KEY]
      @device_density
    end

    def get_device_type
      @device_type = request.headers[::ApiConstants::APP_HEADER_DEVICE_TYPE_KEY]
      @device_type
    end

    def get_device_dimensions
      @device_dimensions = request.headers[::ApiConstants::APP_HEADER_DEVICE_DIMENSIONS_KEY]
      @device_dimensions
    end
    
    private
    def ensure_device_headers_are_passed
      headers[::ApiConstants::APP_HEADER_DEVICE_DENSITY_KEY] = @device_density || ""
      headers[::ApiConstants::APP_HEADER_DEVICE_TYPE_KEY] = @device_type || ""
      headers[::ApiConstants::APP_HEADER_DEVICE_DIMENSIONS_KEY] = @device_dimensions || ""
    end

  end
end