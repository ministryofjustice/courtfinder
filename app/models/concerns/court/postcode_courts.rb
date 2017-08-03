module Concerns
  module Court
    module PostcodeCourts
      extend ActiveSupport::Concern

      # Using a reverse id lookup instead of just
      # postcode_court.court as a workaround for the distance calculator
      included do
        def self.postcode_court_lookup(postcode, area_of_law)
          postcode_court = postcode_court_matcher(postcode)
          return [] unless postcode_court

          if area_of_law
            by_area_of_law(area_of_law).where(id: postcode_court.court_id).limit(1)
          else
            where(id: postcode_court.court_id).limit(1)
          end
        end

        def self.postcode_court_matcher(postcode)
          PostcodeCourt.where("court_id IS NOT NULL AND ? like postcode || '%'",
            postcode).
            order('-length(postcode)').first
        end
      end

      private

      def ingest_new_postcode_courts(postcodes)
        postcodes.split(",").map do |postcode|
          postcode = postcode.gsub(/[^0-9a-z ]/i, "").downcase
          postcode_court = existing_postcode_court(postcode)
          if postcode_court
            add_pc_court(postcode_court, postcode)
          else
            @new_postcode_courts << PostcodeCourt.new(postcode: postcode)
          end
        end
      end

      def add_pc_court(postcode_court, postcode)
        if postcode_court.court && postcode_court.court == self
          @new_postcode_courts << postcode_court
        elsif postcode_court.court && postcode_court.court != self
          @postcode_errors << "Post code \"#{postcode}\" is already assigned to #{pc.court.name}.
            Please remove it from this court before assigning it to #{name}."
        end
      end
    end
  end
end
