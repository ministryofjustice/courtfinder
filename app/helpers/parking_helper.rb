module ParkingHelper
  def parking_text_for(onsite, offsite, blue_badge)
    return [t('parking_none')] if onsite == 'parking_onsite_none' && offsite == 'parking_offsite_none' && blue_badge == 'parking_blue_badge_none'
    return [t(onsite)] if offsite == 'parking_offsite_none'
    return [t(offsite)] if onsite == 'parking_onsite_none'
    [t(onsite),t(offsite),t(blue_badge)]
  end
end
