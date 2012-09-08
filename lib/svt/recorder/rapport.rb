# -*- coding: utf-8 -*-
lib = File.expand_path(File.dirname(__FILE__))
$:.unshift lib unless $:.include?(lib)
require 'base'

require 'open-uri'
require 'nokogiri'

module SVT
  module Recorder
    # Recorder for SVT Play Rapport
    # Takes an URL for svt.se and returns the download URL in
    # the same format as SVT Play class.
    #
    # Usage is the same as for SVT::Recorder::Play.
    class Rapport < Base
      def initialize(url)
        video = SVT::Recorder.fetch_playlist(url, '.svtplayer')

        super(video)
      end

      def self.record(url)
        recorder = SVT::Recorder::Rapport.new(url)
        recorder.part_urls
      end
    end
  end
end
