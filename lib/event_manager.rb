# frozen_string_literal: true

require 'csv'

require 'google-apis-civicinfo_v2'

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
# <Google::Apis::CivicinfoV2::CivicInfoService:0x007faf2dd47108 ... >

civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
# => "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw

civic_info.representative_info_by_address(address: 80_202, levels: 'country',
                                          roles: %w[legislatorUpperBody legislatorLowerBody])
# <Google::Apis::CivicinfoV2::RepresentativeInfoResponse:0x007faf2d9088d0 @divisions={"ocd-division/country:us/state:co"=>#<Google::Apis::CivicinfoV2::GeographicDivision:0x007faf2e55ea80 @name="Colorado", @office_indices=[0]> } > ...continues...








def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0, 4]
end

# if the zipcode is exactly five digits, assume that it is ok
def legislator_by_zipcode(_zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  # <Google::Apis::CivicinfoV2::CivicInfoService:0x007faf2dd47108 ... >

  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  # => "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw

  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    )
    
    legislators = legislators.officials
    legislator_names = legislators.map(&:name)
    legislator_names.split(', ')

  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  '/event_attendees',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislator_by_zipcode(zipcode)

  puts "#{name} #{zipcode} #{legislators}"
end

# if the zipcode is exactly five digits, assume that it is ok
# if the zipcode is more than five digits, truncate it to the first five digits
# if the zipcode is less than 5 digits, assume the missing digits where first itent zeros, add zeros to the fornt
# if the zipcode is missing, replace zipcode as 00000 default
