module Datmachine


  class Subscription
    include Datmachine::Resource

    def cancel
      self.status = "canceled"
      self.save
    end


  end
end