# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


ExternalLink.create(text: 'GOV.UK', url: 'https://www.gov.uk', always_visible: true)
ExternalLink.create(text: 'Forms', url: 'http://hmctsformfinder.justice.gov.uk/HMCTS/FormFinder.do', always_visible: true)
ExternalLink.create(text: 'Fees', url: 'http://www.justice.gov.uk/courts/fees', always_visible: true)

CourtType.find_by_name('Family court').external_links.create(text: 'Family Mediation', url: 'http://www.familymediationcouncil.org.uk/', always_visible: false)
CourtType.find_by_name('County Court').external_links.create(text: 'Civil Mediation', url: 'http://www.civilmediation.org/', always_visible: false)

AreaOfLaw.find_by_name('Money claims').external_links.create(text: 'Money claims', url: 'https://www.gov.uk/make-court-claim-for-money')
AreaOfLaw.find_by_name('Housing possession').external_links.create(text 'Repossessions (land or property)':  , url: "https://www.gov.uk/repossession")
AreaOfLaw.find_by_name('Repossessions').external_links.create(text: 'Repossessions', url: "https://www.gov.uk/possession-claim-online-recover-property")
AreaOfLaw.find_by_name('Divorce').external_links.create(text: 'Divorce', url: "https://www.gov.uk/divorce")
AreaOfLaw.find_by_name('Adoption').external_links.create(text: 'Child adoption' , url: "https://www.gov.uk/child-adoption")
AreaOfLaw.find_by_name('Probate').external_links.create(text: 'Wills, probate and inheritance' , url: "https://www.gov.uk/wills-probate-inheritance/applying-for-a-grant-of-representation" )
