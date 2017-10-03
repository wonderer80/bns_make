class BnsMarketController < ApplicationController
  def main

    made_item_infos = [
        {
            made_item_name: '진화석',
            made_item_num: 35,
            made_price: 180,
            materials: [{ name: '월석', num: 60 },
                        { name: '영석', num: 230 },
                        { name: '영단', num: 230 },
                        { name: '선단', num: 60 }]
        },
        {
            made_item_name: '삼성 금강석 주머니',
            made_item_num: 2,
            made_price: 900,
            materials: [{ name: '월석', num: 370 },
                        { name: '영석', num: 850 },
                        { name: '영단', num: 850 },
                        { name: '선단', num: 370 }]
        },
        {
            made_item_name: '팔각 금강석 주머니',
            made_item_num: 3,
            made_price: 900,
            materials: [{ name: '월석', num: 370 },
                        { name: '영석', num: 850 },
                        { name: '영단', num: 850 },
                        { name: '선단', num: 370 }]
        }
    ]
    @result = []
    made_item_infos.each do |info|
      @result << item_cost(info)
    end

  end

  def item_cost(made_item_info)
    materials = made_item_info[:materials]

    result = {}
    result[:made_item_name] = made_item_info[:made_item_name]
    result[:made_item_num] = made_item_info[:made_item_num]
    result[:price] = materials.inject(0) do |sum, item|
      sum += (BnsMarket.item_price(item[:name]) * item[:num])
      puts "#{item[:name]}: #{BnsMarket.item_price(item[:name])}"
      sum
    end

    result[:production_cost] = made_item_info[:made_price]
    result[:total_cost] = result[:price] + result[:production_cost]
    # 가격 * 생산수 - 수수료(0.7%)
    result[:item_price] = BnsMarket.item_price(made_item_info[:made_item_name]) * made_item_info[:made_item_num] * 0.93
    result[:earning_price] = result[:item_price] - result[:total_cost]

    result
  end

  def main2
# http://m.bns.plaync.com/bs/market/search?ct=&level=&stepper=&exact=1&sort=&type=&grade=&prevq=&q=월석
    result = Wombat.crawl do
      base_url "http://m.bns.plaync.com"
      path "/bs/market/search?ct=&level=&stepper=&exact=1&sort=&type=&grade=&prevq=&q=월석"

      headline 'xpath=//*[@id="listMarket"]/tbody'

      explore 'xpath=//*[@id="listMarket"]/tbody/tr' do |e|
        e
      end
      # //*[@id="listMarket"]/tbody/tr[1]/th/div[2]/div[1]/span[1]
      what_list('xpath=//*[@id="listMarket"]/tbody/tr[*]/th/div[2]/div[1]', :list)

      price_gold css: '#listMarket > tbody > tr:nth-child(1) > th > div.price > div.unit > span.gold'
      price_silver css: '#listMarket > tbody > tr:nth-child(1) > th > div.price > div.unit > span.silver'
      price_bronze css: '#listMarket > tbody > tr:nth-child(1) > th > div.price > div.unit > span.bronze'
      #
      # what_is "css=.column.secondary p", :html
      #
      # explore "xpath=//ul/li[2]/a" do |e|
      #   e.gsub(/Explore/, "LOVE")
      # end
      #
      # benefits do
      #   first_benefit "css=.column.leftmost h3"
      #   second_benefir "css=.column.leftmid h3"
      #   third_benefit "css=.column.rightmid h3"
      #   fourth_benefit "css=.column.rightmost h3"
      # end
    end
    p result
    render json: result.to_json
  end
end
