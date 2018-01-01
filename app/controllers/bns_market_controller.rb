class BnsMarketController < ApplicationController
  def main

    made_item_infos = [
        # 철무방
        {
            made_item_name: '진화석',
            made_item_num: 35,
            made_price: 180,
            made_time: 1.day,
            materials: [
                        { name: '영석', num: 230 },
                        { name: '월석', num: 60 },
                        { name: '영단', num: 230 },
                        { name: '선단', num: 60 }
            ]
        },
        {
            made_item_name: '설혼석',
            made_item_num: 20,
            made_price: 900,
            made_time: 5.days,
            materials: [
                        { name: '영석', num: 850 },
                        { name: '월석', num: 370 },
                        { name: '영단', num: 850 },
                        { name: '선단', num: 370 }
            ]
        },
        # 태상문
        {
            made_item_name: '명인 합성목편 묶음',
            made_item_num: 6,
            made_price: 540,
            made_time: 3.days,
            materials: [
                { name: '영석', num: 695 },
                { name: '월석', num: 175 },
                { name: '영단', num: 695 },
                { name: '선단', num: 175 }
            ]
        },
        {
            made_item_name: '진마골',
            made_item_num: 9,
            made_price: 90,
            made_time: 12.hours,
            materials: [
                { name: '영석', num: 115 },
                { name: '월석', num: 30 },
                { name: '영단', num: 115 },
                { name: '선단', num: 30 }
            ]
        },
        # 만금당
        {
            made_item_name: '사성 금강석 주머니',
            made_item_num: 2,
            made_price: 1260,
            made_time: 7.days,
            materials: [
                        { name: '영석', num: 1620 },
                        { name: '월석', num: 405 },
                        { name: '영단', num: 1620 },
                        { name: '선단', num: 405 }
            ]
        },
        {
            made_item_name: '삼성 금강석 주머니',
            made_item_num: 2,
            made_price: 900,
            made_time: 5.days,
            materials: [
                        { name: '영석', num: 850 },
                        { name: '월석', num: 370 },
                        { name: '영단', num: 850 },
                        { name: '선단', num: 370 }
            ]
        },
        {
            made_item_name: '팔각 금강석 주머니',
            made_item_num: 3,
            made_price: 900,
            made_time: 5.days,
            materials: [
                        { name: '영석', num: 850 },
                        { name: '월석', num: 370 },
                        { name: '영단', num: 850 },
                        { name: '선단', num: 370 }
            ]
        },
        # 일미문
        {
            made_item_name: '순한 만두 음식상자',
            made_item_num: 20,
            made_price: 180,
            made_time: 1.day,
            materials: [
                { name: '영석', num: 230 },
                { name: '월석', num: 60 },
                { name: '영단', num: 230 },
                { name: '선단', num: 60 }
            ]
        },
        {
            made_item_name: '매운 만두 음식상자',
            made_item_num: 12,
            made_price: 180,
            made_time: 1.day,
            materials: [
                { name: '영석', num: 230 },
                { name: '월석', num: 60 },
                { name: '영단', num: 230 },
                { name: '선단', num: 60 }
            ]
        },
        {
            made_item_name: '용봉탕 음식상자',
            made_item_num: 10,
            made_price: 180,
            made_time: 1.day,
            materials: [
                { name: '영석', num: 230 },
                { name: '월석', num: 60 },
                { name: '영단', num: 230 },
                { name: '선단', num: 60 }
            ]
        },
        # 약왕원
        {
            made_item_name: '천년초 비약 상자',
            made_item_num: 25,
            made_price: 180,
            made_time: 1.day,
            materials: [
                { name: '영석', num: 230 },
                { name: '월석', num: 60 },
                { name: '영단', num: 230 },
                { name: '선단', num: 60 }
            ]
        },
        # 성군당
        {
            made_item_name: '빛나는 백청 봉인부적',
            made_item_num: 6,
            made_price: 540,
            made_time: 3.days,
            materials: [
                { name: '영석', num: 695 },
                { name: '월석', num: 175 },
                { name: '영단', num: 695 },
                { name: '선단', num: 175 }
            ]
        },
        {
            made_item_name: '부활 부적꾸러미',
            made_item_num: 35,
            made_price: 180,
            made_time: 1.day,
            materials: [
                { name: '영석', num: 230 },
                { name: '월석', num: 60 },
                { name: '영단', num: 230 },
                { name: '선단', num: 60 }
            ]
        }
    ]
    @result = []
    made_item_infos.each do |info|
      info.merge!(item_cost(info))
      info[:earning_by_hour] = (info[:earning_price] / (info[:made_time]/60/60)).round(2)

      if info[:earning_by_hour] > params[:earn].to_i
        @result << info
      end
    end
  end

  def item_cost(made_item_info)
    materials = made_item_info[:materials]

    result = {}
    result[:price] = materials.inject(0) do |sum, item|
      sum += (BnsMarket.item_price(item[:name]) * item[:num])
      sum
    end

    result[:production_cost] = made_item_info[:made_price]
    result[:total_cost] = result[:price] + result[:production_cost]
    # 가격 * 생산수 - 수수료(0.7%)
    result[:item_price] = BnsMarket.item_price(made_item_info[:made_item_name]) * made_item_info[:made_item_num] * 0.93
    result[:earning_price] = result[:item_price] - result[:total_cost]

    result
  end
end
