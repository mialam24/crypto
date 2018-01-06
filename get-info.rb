require 'httparty'
require 'csv'
require 'json'
require 'tzinfo'

info_json = JSON.parse(HTTParty.get('https://api.coinmarketcap.com/v1/ticker/?limit=0').body)

info_csv = CSV.generate do |csv|
  csv << info_json[0].keys

  info_json.each do |hash|
    csv << hash.values
  end
end

tz = TZInfo::Timezone.get('US/Pacific')
time = Time.now.
            getlocal(tz.current_period.offset.utc_total_offset).
            to_s.
            gsub(' -0800', '').
            gsub(' ', '-')
File.write('all-crypto-' + time + '.csv', info_csv)
