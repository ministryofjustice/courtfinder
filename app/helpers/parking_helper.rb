module ParkingHelper
  def parking_text_for(onsite, offsite, blue_badge)
    return [t('parking_none')] if onsite == 'parking_onsite_none' &&
                                  offsite == 'parking_offsite_none' &&
                                  blue_badge == 'parking_blue_badge_none'
    [onsite, offsite, blue_badge].select(&:present?).map { |key| t(key) }
  end
end
