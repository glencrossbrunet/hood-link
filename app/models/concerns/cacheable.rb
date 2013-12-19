module Cacheable
  extend ActiveSupport::Concern

  included do
    
    def daily_intervals_cache_key(date, interval)
      [ self.class.table_name, id, date.strftime('%Y%m%d'), interval.seconds.to_i ].join(':')
    end
    
    def daily_intervals_with_caching(date, interval)
      Rails.cache.fetch(daily_intervals_cache_key date, interval) do
        daily_intervals_without_caching(date, interval)
      end
    end
    alias_method_chain :daily_intervals, :caching
    
  end
end