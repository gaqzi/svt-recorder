#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

module SVT
  module Recorder
    # Given an URL to a HTML document and a CSS search path find
    # the 'data-json-href' attribute that will give the URL for a
    # videos playlist. This playlist will then be used to fetch all
    # parts/chunks of a video.
    #
    # Args:
    #   url      :: Any valid URL
    #   css_path :: A CSS expression to search, ex. Play have used '#player'
    #
    # Yields:
    #   url :: The URL from data-json-href, Play have to add modify the URL
    #          to make it absolute. So the caller makes any modifications
    #          before the JSON-file gets fetched.
    #
    # Returns:
    #   A hash with these keys:
    #     :title :: The title of the video
    #     :url   :: The URL to the playlist
    def self.fetch_playlist(url, css_path)
      doc = Nokogiri::HTML(open(url).read)
      player = doc.at_css(css_path)
      stream = player['data-json-href']
      stream = yield stream

      js = JSON.parse(open(stream).read)
      if not js['video']['availableOnMobile']
        raise ArgumentError, "The passed in URL is not available for mobile, non-rtmp"
      end

      title = js['context']['title']
      v = js['video']['videoReferences'].find({}) {|v| v['playerType'] == 'ios' }

      {:title => title, :url => v['url']}
    end

    class Base
      def initialize(opts={})
        @title      = opts[:title] or ''
        @stream     = opts[:url]
        @base_url   = File.dirname(opts[:url])

        @bitrates   = {} # bitrate => stream
        @part_base  = ''
        @first_part = 0
        @last_part  = 0
      end

      attr_reader :title
      attr_reader :base_url
      attr_reader :bitrate

      # All part URL:s for a specific +bitrate+
      #
      # Args:
      #   bitrate :: The bitrate for which to fetch the parts,
      #                defaults to the highest bitrate available.
      #
      # Returns:
      #   self
      def part_urls(bitrate = nil)
        @bitrate = if bitrate.nil?
                     get_streams() if @bitrates.empty?
                     @bitrates.keys.max
                   else
                     bitrate
                   end

        url = File.join(@base_url, @bitrates[@bitrate])

        open(url).each do |row|
          next if row[0..0] == '#'
          row.strip!

          @part_base = File.dirname(row) if @part_base.empty?
          @last_part += 1
        end

        self
      end

      # All available bitrates for this video/playlist.
      # Returns:
      #   An array of bitrates, orderered highest->lowest
      def bitrates
        get_streams() if @bitrates.empty?
        @bitrates.keys.sort.reverse
      end

      # Returns or yields all parts, in order, for this video.
      # If all parts then are downloaded in sequence and concatenated there
      # will be a playable movie.
      #
      # Yield:
      #   A complete part download URL
      #
      # Returns:
      #   All parts in an ordered array, first -> last
      def parts
        part_urls() if @last_part == 0

        if block_given?
          (@first_part...@last_part).each do |i|
            yield "#{@part_base}/segment#{i}.ts"
          end
        else
          # I want you Object#tap
          tmp = []
          parts {|part| tmp << part }
          tmp
        end
      end

      # Yields all +parts+ concatenated with base_url
      def all_parts
        parts do |part|
          yield File.join(base_url, part)
        end
      end

      #--
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

          if match = row.match(/#EXT-X-STREAM-INF:.+BANDWIDTH=(.+) ?$/)
            bitrate = match[1].to_i
          end
        end
      end # /get_streams
    end # /Base
  end # /Recorder
end # /SVT
