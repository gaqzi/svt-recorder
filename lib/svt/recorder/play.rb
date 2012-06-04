# -*- coding: utf-8 -*-

lib = File.expand_path(File.dirname(__FILE__))
$:.unshift lib unless $:.include?(lib)
require 'base'

require 'open-uri'

require 'nokogiri'
require 'json'

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
    class Play < Base
      def initialize(url)
        video = SVT::Recorder.fetch_playlist(url, '#player') do |url|
          "#{File.join('http://www.svtplay.se', url)}?output=json"
        end

        super(video)
      end

      # Instantiate the class with +url+ and get all part URL:s for
      # the highest bitrate available.
      def self.record(url)
        recorder = SVT::Recorder::Play.new(url)
        recorder.part_urls
      end
    end # /Play
  end # /Recorder
end # /SVT
