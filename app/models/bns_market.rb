require 'open-uri'

class BnsMarket
  class << self
    def item_price(itemName)
      Rails.cache.fetch(itemName, expires_in: 1.minutes) do
        puts "#{itemName}: not cached"
        doc = Nokogiri::HTML(open("http://m.bns.plaync.com/bs/market/search?ct=&level=&stepper=&exact=1&sort=&type=&grade=&prevq=&q=#{URI.encode(itemName)}"))
        list = doc.xpath('//*[@id="listMarket"]/tbody/tr[*]/th')
        result = list.map do |e|
          num = e.xpath('div[1]/span[2]')[0].children[0].to_s.gsub(/[$,\s]/,'').to_f
          num = 1 if num == 0

          gold = e.xpath('div[2]/div[1]').css('.gold').children[0].to_s.gsub(/[$,\s]/,'')
          silver = e.xpath('div[2]/div[1]').css('.silver').children[0].to_s.gsub(/[$,\s]/,'')
          bronze = e.xpath('div[2]/div[1]').css('.bronze').children[0].to_s.gsub(/[$,\s]/,'')
          price = "#{gold}.#{silver}#{bronze}"

          { num: num,
            gold: gold,
            silver: silver,
            bronze: bronze,
            price: price
          }
        end

        total_price = 0
        total_num = 0
        result.each do |e|
          total_price += e[:price].to_f * e[:num].to_i
          total_num += e[:num].to_i
        end

        total_price / total_num
        end
      end
  end

end