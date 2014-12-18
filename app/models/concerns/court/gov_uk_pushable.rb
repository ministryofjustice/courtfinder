module Concerns
  module Court
    module GovUkPushable

      extend ActiveSupport::Concern

      included do
        before_update :register_gov_uk_push_update
      end


      def register_gov_uk_push_update
        unless self.court_id.nil?
          GovUkPushWorker.perform_async(action: :update, court_id: self.court_id)
        end
      end
    end
  end
end
