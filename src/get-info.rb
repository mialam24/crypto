require 'httparty'
require 'csv'
require 'json'
require 'tzinfo'

info_json = JSON.parse(HTTParty.get('https://api.coinmarketcap.com/v1/ticker/?limit=0').body)

info_csv = CSV.generate do |csv|
  csv << info_json[0].keys

  info_json.each do |hash|
    crypto_id = hash.values[0]
    puts hash.values[3] + ' ' + crypto_id

    raw_html = HTTParty.get("https://coinmarketcap.com/currencies/#{crypto_id}/").body
    File.write('temp.txt', raw_html)
    proc_html = `grep '/exchanges' temp.txt | sed -e 's/<td>[^>]*>//g' -e 's/<.*//' | sort -f | uniq -u`

    exchanges = ('"' + proc_html.gsub(/\s{2,}/, ',') + '"').sub(/,/, '').sub(/,"/, '"')

    csv << hash.values.push(exchanges)
  end

  `rm temp.txt`
end

tz = TZInfo::Timezone.get('US/Pacific')
time = Time.now.
            getlocal(tz.current_period.offset.utc_total_offset).
            to_s.
            gsub(' -0800', '').
            gsub(' ', '-')
File.write('all-crypto-' + time + '.csv', info_csv)
