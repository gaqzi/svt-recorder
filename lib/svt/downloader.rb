# -*- coding: utf-8 -*-
require 'open-uri'

module SVT
  class Downloader
    def initialize(uri)
      doc = open(uri).read
      # Parsing HTML with Regexps isn't nice, but wanting to use pure Ruby
      # for this script I prefer it over using Hpricot or Nokogiri.
      # Will change if needed in the future
      @stream = doc.match(/<video.+src="([^"]+)/)[1] rescue nil
      if @stream.nil? or @stream.empty?
        raise ArgumentError, "The passed in URI does not contain a valid <video>-tag"
      end
      @title = doc.match(/<title>(.+)<\/title>/m)[1].sub(' | SVT Play', '').strip

      @bitrates = {} # bitrate => layer
      @base_uri = File.dirname(@stream)
    end

    attr_reader :title

    # All available bitrates for the +uri+ passed in.
    # Order: highest->lowest
    def bitrates
      get_streams() if @bitrates.empty?
      @bitrates.keys.sort.reverse
    end

    # All part URI:s for +bitrate+
    def download_urls(bitrate)
      uri = File.join(@base_uri, @bitrates[bitrate])

      parts = []
      open(uri).each do |row|
        row.strip!
        next if row[0].to_s == '#'

        parts << File.join(@base_uri, row)
      end

      parts
    end

    # Instantiate the script with +uri+ and get all part URI:s for
    # the highest bitrate available.
    def self.download(uri)
      downloader = SVT::Downloader.new(uri)
      highest_bitrate = downloader.bitrates[0]
      downloader.download_urls(highest_bitrate)
    end

    private
    # A naïve parser, but until it turns out to be a problem it'll do
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
  end # /Downloader
end # /SVT
