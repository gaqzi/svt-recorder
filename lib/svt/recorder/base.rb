#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module SVT
  module Recorder
    class Base
      attr_reader :title
      attr_reader :base_url
      attr_reader :bitrate

      def bitrates
        raise NotImplementedError, 'Bitrates undefined!'
      end

      def part_urls(bitrate = '')
        raise NotImplementedError, 'part_urls undefined!'
      end

      def self.record(url)
        self.new(url)
      end

      # Yields all +parts+ concatenated with base_url
      def all_parts
        parts do |part|
          yield File.join(base_url, part)
        end
      end

      # Returns all parts as an array or yielded one part at a time
      def parts
        if block_given?
          @parts.each {|part| yield part }
        else
          @parts
        end
      end
    end # /Base
  end # /Recorder
end # /SVT
