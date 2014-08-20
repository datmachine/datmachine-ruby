module Datmachine
  # A customer represents a business or person within your Marketplace. A
  # customer can have many funding instruments such as cards and bank accounts
  # associated to them.
  #
  class Customer

    include Datmachine::Resource

    def create_subscription(options = {})
      options[:href] =  self.subscriptions.href
      subscription = Datmachine::Subscription.new(options)
      subscription.save
    end
    
    def update(options = {})
      options.each do |key, value|
        attributes[key] = value
      end
      save 
    end
    
    def all_subscriptions 
      subscriptions.to_a
    end
    
    def last_subscription
      all_subscriptions.last
    end
    
    def self.find_by_id(id)
       Datmachine::Customer.fetch("/customers/#{id}")
    end
    
  end
end