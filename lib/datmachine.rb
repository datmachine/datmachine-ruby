$:.unshift File.join(File.dirname(__FILE__), "datmachine", "resources")
$:.unshift File.join(File.dirname(__FILE__), "datmachine", "response")

require 'uri'
require 'datmachine/version' unless defined? Datmachine::VERSION
require 'datmachine/client'
require 'datmachine/utils'
require 'datmachine/error'

module Datmachine

  @client = nil
  @config = {
      :scheme => 'http',
      :host => 'api.datmachine.co',
      :port => 80,
      :version => '1.1'
  }

  @hypermedia_registry = {}

  class << self

    attr_accessor :client
    attr_accessor :config
    attr_accessor :hypermedia_registry

    def configure(api_key=nil, site_id=nil, options={})
      @config = @config.merge(options)
      @client = Datmachine::Client.new(api_key, site_id, @config)
    end

    def is_configured_with_api_key?
      !@client.api_key.nil?
    end

    def split_the_href(href)
      URI.parse(href).path.sub(/\/$/, '').split('/')
    end

    def from_hypermedia_registry(resource_name)
      cls = Datmachine.hypermedia_registry[resource_name]
      if cls.nil?
        raise 'OH SHIT'
      end
      cls
    end

    def from_href(href)
      split_uri = split_the_href(href)
      split_uri.reverse!.each do |resource|
        cls = Datmachine.hypermedia_registry[resource]
        return cls unless cls.nil?
      end
    end

    def is_collection(href)
      split_uri = split_the_href(href)
      split_uri.last.to_i == 0

    end

    def get(*args, &block)
      self.client.get *args
    end

    def post(*args, &block)
      self.client.post *args
    end

    def put(*args, &block)
      self.client.put *args
    end

    def unstore(*args, &block)
      self.client.unstore *args
    end
    alias_method :delete, :unstore
  end

  # configure on import so we don't have to configure for creating
  # an api key
  configure
end

require 'datmachine/resources'
