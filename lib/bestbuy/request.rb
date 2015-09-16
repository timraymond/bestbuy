require 'multi_json'
require 'net/http'

module BestBuy
  # Represents an unfulfilled request to the BestBuy API. Fullfillment of the
  # request can be triggered by invoking Request#call. Request also provides
  # methods to inspect the request that will be made to the BestBuy API
  class Request
    # Endpoints that are supported by this API client
    VALID_ENDPOINTS = [
      'products',
    ]
    # @param api_key[String] The API key required by the BestBuy API
    # @param endpoint[String] The endpoint of the API that this request will be made against. Must be one of VALID_ENDPOINTS
    # @param filters[Array<String>] Filters that will be applied to the particular resource being requested.
    def initialize(api_key:, endpoint:, affiliate_tracking_id: nil, filters: [])
      unless VALID_ENDPOINTS.include? endpoint
        fail APIError, "The endpoint \"#{endpoint}\" is currently unsupported. Supported endpoints are: #{VALID_ENDPOINTS.join(", ")}"
      end
      @endpoint = endpoint
      @filters = filters
      @affiliate_tracking_id = affiliate_tracking_id
      @api_key = api_key
      @show_params = []
    end

    # @returns [String] The URL that will be used for this Request
    def to_s
      "https://api.bestbuy.com/v1/#{@endpoint}(#{@filters.join('|')})?#{query_string}"
    end

    # Converts the request into a cURL request for debugging purposes
    #
    # @returns [String] An eval-able string that will make a request using cURL to the BestBuy API
    def to_curl
      "curl #{to_s}"
    end

    # Sets the request to only return the specified fields from the API
    #
    # @example Pluck attributes
    #   bby = BestBuy::Client.new(api_key: '12345')
    #   bby.products(upc: '004815162342').pluck(:name).call
    #   #=> [{:name => "MegaProduct 5000"}]
    # @param requested_fields [Array<Symbol>] The requested fields that should be included in product results
    # @return BestBuy::Request The augmented request
    def pluck(*requested_fields)
      @show_params = requested_fields.map(&:to_s)
      self
    end

    # Synchronously executes a request to the BestBuy API. This will block until results are ready and have been parsed
    #
    # @return Array<Hash> The results returned from the API.
    def call
      resp = ::Net::HTTP.get URI(to_s)
      ::MultiJson.decode(resp)['products']
    end

    # Returns the query string that will be used for this request. Query string parameters are returned in alphabetical order.
    #
    # @return String The query string for this request
    def query_string
      [
        api_key_param,
        format_param,
        show_param,
        affiliate_param,
      ].compact.sort.join("&")
    end

    private

    # Inserts the query string parameter responsible for crediting affiliate links
    def affiliate_param
      if @affiliate_tracking_id
        "LID=#{@affiliate_tracking_id}"
      end
    end

    # Controls the apiKey query string parameter
    def api_key_param
      "apiKey=#{@api_key}"
    end

    # Changes the response format. The API accepts XML, but this gem requres JSON
    def format_param
      "format=json"
    end

    # Controls the fields returned for API response items. Corresponsds to the "show" query parameter
    def show_param
      if @show_params && @show_params.length > 0
        "show=#{@show_params.join(",")}"
      else
        nil
      end
    end
  end
end
