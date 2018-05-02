module AuditCsvService

  def self.generate
    versions = PaperTrail::Version.order("created_at DESC")
    CSV.generate do |csv|
      csv << csv_header
      versions.each do |version_line|
        @version = version_line
        csv_lines_generator.each { |line| csv << line }
      end
    end
  rescue StandardError => e
    Rails.logger.info e.message
  end

  def self.get_court_id_from_previous_version(version)
    version.previous.try(:object).
      try(:split, "\n").try(:grep, /court_id/).
      try(:first).try(:gsub, "court_id: ", "").try(:to_i)
  end

  class << self
    private

    attr_reader :version

    def csv_header
      [
        'datetime', 'user_email', 'ip_address', 'court_name', 'field_name',
        'action', 'value_before', 'value_after'
      ]
    end

    def author_email
      User.find(version.whodunnit).email if version.whodunnit
    end

    def csv_for_court_type
      csv = []
      court = Court.find(version.item_id)
      version.changeset.each do |key, value|
        csv << [version.created_at, author_email,
                version.ip, court.name, key,
                version.event, value[0], value[1]]
      end
      csv
    end

    def csv_for_destroy_event
      csv = []
      value_before = version.previous.try(:object)
      value_after = ""
      court_id = get_court_id_from_previous_version(version)
      court = Court.find_by(id: court_id)

      return csv if court_id.blank? || court.blank?

      csv << [version.created_at, author_email,
              version.ip, court.name, version.item_type,
              version.event, value_before, value_after]
    end

    def csv_for_other_types(court)
      csv = []
      value_before = []
      value_after = []
      version.changeset.each do |key, value|
        value_before << "#{key}: #{value[0]}" unless version.event == "create"
        value_after << "#{key}: #{value[1]}"
      end
      csv << [version.created_at, author_email,
              version.ip, court.name, version.item_type,
              version.event, value_before, value_after]
    end

    def csv_lines_generator
      if version.item_type == "Court"
        csv_for_court_type
      elsif version.event == "destroy"
        csv_for_destroy_event
      else
        other_types
      end
    end

    def other_types
      item = version.item_type.constantize.find_by(id: version.item_id)
      court = item.try(:court)
      if item && court
        csv = csv_for_other_types(court)
      end
      csv.blank? ? [] : csv
    end
  end
end
