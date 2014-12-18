module Concerns
  module Court
    module GovUkPushable

      extend ActiveSupport::Concern

      included do
        after_update  :register_gov_uk_push_update
        after_create  :register_gov_uk_push_create
        after_destroy :register_gov_uk_push_destroy
      end


      def register_gov_uk_push_update
        register_gov_uk_push_job(:update)
      end

      def register_gov_uk_push_create
        this_object_is_court_class? ? register_gov_uk_push_job(:create) : register_gov_uk_push_job(:update)
      end

      def register_gov_uk_push_destroy
        this_object_is_court_class? ? register_gov_uk_push_job(:destroy) : register_gov_uk_push_job(:update)
      end

      # For some reason, inside a concern self.is_a?(Court) returns false even when self.class returns Court
      def this_object_is_court_class?
        (respond_to? :is_court_class?) && (self.is_court_class?)
      end


      def register_gov_uk_push_job(action)
        GovUkPushWorker.perform_async(action: action, court_id: self.court_id) unless self.court_id.nil?
      end

    end
  end
end
