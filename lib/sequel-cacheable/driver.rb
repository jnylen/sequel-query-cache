require 'msgpack'

module Sequel::Plugins
  module Cacheable
    DRIVERS = %w(memcache dalli redis).freeze

    class Driver
      def self.factory(*args)
        case args[0].class.name
        when 'Memcache'
          MemcacheDriver.new(*args)
        when 'Dalli::Client'
          DalliDriver.new(*args)
        when 'Redis'
          RedisDriver.new(*args)
        else
          Driver.new(*args)
        end
      end

      def initialize(store, pack_lib = MessagePack)
        @store = store
        @pack_lib = MessagePack
      end

      def get(key)
        val = @store.get(key)

        return val.nil? ? val : @pack_lib.unpack(val)
      end

      def set(key, val, expire = nil)
        @store.set(key, @pack_lib.pack(val))
        @store.expire(key, expire) unless expire.nil?

        return val
      end

      def del(key)
        @store.del(key)

        return nil
      end

      def expire(key, time)
        @store.expire(key, time)
      end

      def fetch(key, *args, &block)
        get(key) || set(key, block.call(*args))
      end
    end
  end
end

Sequel::Plugins::Cacheable::DRIVERS.each do |driver|
  require "sequel-cacheable/driver/#{driver}"
end
