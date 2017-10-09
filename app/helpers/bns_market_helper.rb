module BnsMarketHelper
  def convert_humun_time(second)
    day, hour = (second/60/60).divmod(24)
    time_str = ''
    time_str = "#{day}D " if day > 0
    time_str = time_str + "#{hour}H" if hour > 0
    time_str
  end
end
