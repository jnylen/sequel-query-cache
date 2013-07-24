# coding: utf-8
module Sequel
  module Plugins
    module Cacheable
      MAJOR_VERSION = 1
      MINOR_VERSION = 1
      TINY_VERSION  = 0
      VERSION = [MAJOR_VERSION, MINOR_VERSION, TINY_VERSION].join('.')

      def self.version; VERSION; end
    end
  end
end
