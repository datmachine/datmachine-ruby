require 'logger'
require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'datmachine_exception_middleware'

module Datmachine
  class Client

    DEFAULTS = {
      :scheme => 'http',
      :host => 'api.datmachine.co/',
      :port => 80,
      :version => '1',
      :logging_level => 'WARN',
      :connection_timeout => 60,
      :read_timeout => 60,
      :logger => nil,
      :ssl_verify => false,
      :faraday_adapter => Faraday.default_adapter,
      :accept_type => 'application/json'
    }

    attr_reader :conn
    attr_accessor :api_key, :config

    def initialize(api_key, site_id, options={})
      @api_key = api_key.nil? ? api_key : api_key.strip
      @config = DEFAULTS.merge options
      @config[:site_id] = site_id 
      build_conn
    end

    def build_conn
      if config[:logger]
        logger = config[:logger]
      else
        logger = Logger.new(STDOUT)
        logger.level = Logger.const_get(config[:logging_level].to_s)
      end



      options = {
        :request => {
          :open_timeout => config[:connection_timeout],
          :timeout => config[:read_timeout]
        },
        :ssl => {
          :verify => @config[:ssl_verify] # Only set this to false for testing
        }
      }
      @conn = Faraday.new(url, options) do |cxn|
        cxn.request :json

        cxn.response :logger, logger
        cxn.response :json
        cxn.response :raise_error # raise exceptions on 40x, 50x responses
        cxn.adapter config[:faraday_adapter]
      end
      conn.path_prefix = '/'
      conn.headers['User-Agent'] = "datmachine-ruby/1"
      conn.headers['Content-Type'] = "application/json"
      conn.headers['Accept'] = "#{@config[:accept_type]}"
    end

    def url
      builder = (config[:scheme] == 'http') ? URI::HTTP : URI::HTTPS

      builder.build({:host => config[:host],
                     :port => config[:port],
                     :scheme => config[:scheme]})
    end

    def unstore(*args, &block)
      delete(*args, &block)
    end

    def method_missing(method, *args, &block)
      if is_http_method? method
        conn.token_auth(api_key) unless api_key.nil?
        args[0] = "/sites/#{config[:site_id]}/" + args[0]
        conn.send method, *args
      else
        super method, *args, &block
      end
    end

    private

    def is_http_method? method
      [:get, :post, :put, :delete].include? method
    end

    def respond_to?(method, include_private = false)
      if is_http_method? method
        true
      else
        super method, include_private
      end
    end
  end
end