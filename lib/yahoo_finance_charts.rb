module YahooFinanceCharts

  class Base
    attr_accessor :symbol, :range, :chart_type, :log_scale, :size, :moving_averages, :exponential_moving_averages, :chart_overlays, :overlays, :indicators
    
    VALID_RANGES = %w(1d 5d 3m 6m 1y 2y 5y max)
    VALID_TYPES = %w(b l c)
    VALID_SIZES = %w(s m l)
    VALID_OVERLAYS = %w(m5 m10 m20 m50 m100 m200 e5 e10 e20 e50 e100 e200 b p s v)
    VALID_INDICATORS = %w(m26-12-9 f14 p12 r14 ss fs v vm w14)
    
    
    def self.range_options
      VALID_RANGES.collect {|r| [r, r]}
    end
    
    def self.type_options
      [ ['Bar', 'b'], ['Line', 'l'], ['Candle', 'c'] ]
    end
    
    def self.scale_options
      [ ['Log', 'on'], ['Linear', 'off'] ]
    end
    
    def self.size_options
      [ ['Small', 's'], ['Medium', 'm'], ['Large', 'l'] ]
    end
    
    def self.mma_options
      %w(5 10 20 50 100 200).collect {|a| [a, 'm'+a]}
    end
    
    def self.ema_options
      %w(5 10 20 50 100 200).collect {|a| [a, 'e'+a]}
    end
    
    def self.indicator_options
      [ ['MACD', 'm26-12-9'], ['MFI', 'f14'], ['ROC', 'p12'], ['RSI', 'r14'], ['Slow Stoch', 'ss'], ['Fast Stoch', 'fs'], ['Volume', 'v'], ['Volume+MA', 'vm'], ['Williams %R', 'w14']]
    end
    
    def self.overlay_options
      [ ['Bollinger Bands', 'b'], ['Parabolic SAR', 'p'], ['Splits', 's'], ['Volume', 'v']]
    end
    
    
    def initialize(params = {})
      @overlays = []
      @indicators = []
      @moving_averages = []
      @exponential_moving_averages = []
      @chart_overlays = []
      [:symbol, :range, :chart_type, :log_scale, :size, :moving_averages, :exponential_moving_averages, :chart_overlays, :overlays, :indicators].each do |attribute|
        value = params[attribute] || params[attribute.to_s]
        self.send(attribute.to_s + '=', value) unless value==nil
      end
    end
    
    
    def symbol=(s)
      @symbol = s
    end
    
    def range=(r)
      return if r==nil
      raise 'Invalid range' unless VALID_RANGES.include?( r )
      @range = r
    end
    
    def chart_type=(t)
      return if t==nil
      raise 'Invalid type' unless VALID_TYPES.include?( t )
      @chart_type = t
    end
    
    def log_scale=( boolean = '1' )
      return if boolean==nil
      raise 'Invalid scale' unless %w(on off 0 1).include?( boolean )
      value = 'on' if %w(on 1).include?( boolean )
      value = 'off' if %w(off 0).include?( boolean )
      @scale = value
    end
    
    def size=(s)
      return if s==nil
      raise 'Invalid size' unless VALID_SIZES.include?( s )
      @size = s
    end
    
    def moving_averages=( mmas = {} )
      return if mmas==nil or mmas.empty?
      mmas.each_pair do |key, value|
        raise 'Invalid moving average' unless VALID_OVERLAYS.include?( key )
      end
      @moving_averages = mmas.keys
      @overlays.concat @moving_averages
    end
    
    def exponential_moving_averages=( emas = {} )
      return if emas==nil or emas.empty?
      emas.each_pair do |key, value|
        raise 'Invalid exponential moving average' unless VALID_OVERLAYS.include?( key )
      end
      @exponential_moving_averages = emas.keys
      @overlays.concat @exponential_moving_averages
    end
    
    def chart_overlays=( overlays = {} )
      return if overlays==nil or overlays.empty?
      overlays.each_pair do |key, value|
        raise 'Invalid overlay' unless VALID_OVERLAYS.include?( key )
      end
      @chart_overlays = overlays.keys
      @overlays.concat @chart_overlays
    end
    
    def overlays=(overlay_array = [])
      return if overlay_array==nil || overlay_array.empty?
      overlay_array.each do |overlay|
        raise 'Invalid overlay' unless VALID_OVERLAYS.include?( overlay )
      end
      @overlays = overlay_array
    end
    
    def indicators=(indicator_hash = {})
      return if indicator_hash==nil || indicator_hash.empty?
      indicator_hash.each_pair do |key, value|
        raise 'Invalid indicator' unless VALID_INDICATORS.include?( key )
      end
      @indicators = indicator_hash.keys
    end
    
    
    def url
      base_url = 'http://chart.finance.yahoo.com/z?'
      params_hash = {
        :s => symbol,
        :t => range,
        :q => chart_type,
        :l => log_scale,
        :z => size,
        :p => overlays.join(','),
        :a => indicators.join(',')
      }
      params_array = []
      params_hash.each_pair do |key, value|
        params_array << [key, value].join('=') unless value==nil
      end
      base_url + params_array.join('&')
    end

  end

end
