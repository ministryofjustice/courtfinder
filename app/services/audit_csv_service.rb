module AuditCsvService

  def self.generate
    versions = PaperTrail::Version.order("created_at DESC")
    CSV.generate do |csv|
      begin
        csv << ["datetime", "user_email","ip_address","court_name", "field_name", "action", "value_before", "value_after"]
        versions.each do |version|
          author_email = User.find(version.whodunnit).email if version.whodunnit
          value_before, value_after = [], []
          if version.item_type == "Court"
            court = Court.find version.item_id
            version.changeset.each do |key, value|
              csv << [version.created_at,
                      author_email,
                      version.ip,
                      court.name,
                      key,
                      version.event,
                      value[0],
                      value[1]
                      ]
            end
          else
            if version.event == "destroy"
              value_before = version.previous.try(:object)
              value_after = ""
              if court_id = get_court_id_from_previous_version(version)
                if court = Court.find(court_id)
                  csv << [version.created_at,
                          author_email,
                          version.ip,
                          court.name,
                          version.item_type,
                          version.event,
                          value_before,
                          value_after
                          ]
                end
              end
            else
              if item = version.item_type.constantize.find_by_id(version.item_id)
                if court = item.court
                  version.changeset.each do |key, value|
                    value_before << "#{key}: #{value[0]}" unless version.event == "create"
                    value_after << "#{key}: #{value[1]}"
                  end
                  csv << [version.created_at,
                          author_email,
                          version.ip,
                          court.name,
                          version.item_type,
                          version.event,
                          value_before,
                          value_after
                          ]
                end
              end
            end
          end
        end
      rescue Exception => e
        logger.info e.message
      end
    end
  end

  def self.get_court_id_from_previous_version(version)
    version.previous.try(:object).try(:split, "\n").try(:grep, /court_id/).try(:first).try(:gsub,"court_id: ","").try(:to_i)
  end

end