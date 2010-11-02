# -*- coding: utf-8 -*-
require 'open-uri'

module SVT
  module Recorder
    # Recorder for SVT Play.
    # Takes the URL for a video on SVT Play and returns the URLs
    # for all parts.
    #
    # Usage:
    #   recorder = SVT::Recorder::Play.new(url)
    #   recorder.title # => The title of the video from SVT Play
    #   # If you want to decide which bitrate you want to record check which
    #   # are available, otherwise the highest bitrate will be choosen.
    #   recorder.bitrates # => [696752, ... more bitrates ...]
    #   recorder.part_urls(696752) # => [base_url, [part_names], bitrate]
    #
    # Or for the quick fix:
    #   SVT::Recorder::Play.record(url) # => [base_url, [part_names], bitrate, video_title]
    class Play
      def initialize(url)
        doc = open(url).read
        # Parsing HTML with Regexps isn't nice, but wanting to use pure Ruby
        # for this script I prefer it over using Hpricot or Nokogiri.
        # Will change if needed in the future
        @stream = doc.match(/<video.+src="([^"]+)/)[1] rescue nil
        if @stream.nil? or @stream.empty?
          raise ArgumentError, "The passed in URL does not contain a valid <video>-tag"
        end
        @title = doc.match(/<title>(.+)<\/title>/m)[1].sub('| SVT Play', '').strip

        @bitrates = {} # bitrate => stream
        @base_url = File.dirname(@stream)
      end

      # The title of the video
      attr_reader :title

      # All available bitrates for the +url+ passed in earlier.
      # Order: highest->lowest
      def bitrates
        get_streams() if @bitrates.empty?
        @bitrates.keys.sort.reverse
      end

      # All part URL:s for a specific +bitrate+
      # If no +bitrate+ is specified the highest bitrate is choosen
      def part_urls(bitrate = nil)
        if bitrate.nil?
          get_streams() if @bitrates.empty?
          bitrate = @bitrates.keys.max
        end

        url = File.join(@base_url, @bitrates[bitrate])

        parts = []
        open(url).each do |row|
          row.strip!
          next if row[0..0] == '#'

          parts << row
        end

        [@base_url, parts, bitrate]
      end

      # Instantiate the class with +url+ and get all part URL:s for
      # the highest bitrate available.
      def self.record(url)
        recorder = SVT::Recorder::Play.new(url)
        recorder.part_urls.push recorder.title
      end

      private
      # A naïve parser, but until it turns out to be a problem it'll do.
      #
      # The format is:
      #   EXT-X-.... BANDWIDTH=<bitrate>
      #   playlist-filename
      def get_streams
        bitrate = nil
        open(@stream).each do |row|
          row.strip!

          if bitrate
            @bitrates[bitrate] = row
            bitrate = nil
          end

          if match = row.match(/#EXT-X-STREAM-INF:.+BANDWIDTH=(.+)$/)
            bitrate = match[1].to_i
          end
        end
      end # /get_streams
    end # /Play
  end # /Recorder
end # /SVT
