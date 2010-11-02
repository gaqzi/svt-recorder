#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'open-uri'
require 'rexml/document'

module SVT
  module Recorder
    # Recorder for SVT Play Rapport
    # Takes an URL for playrapport.se and returns the download URL in
    # the same format as SVT Play class.
    #
    # Usage is the same as for SVT::Recorder::Play, apart from that
    # Play Rapport doesn't play around with different bitrates.
    class Rapport
      def initialize(url)
        @id = url.match(/(\d+)$/)[1]
        doc = REXML::Document.new(open(rapport_xml_url(@id)))
        content = doc.elements['//media:content']
        @title = doc.elements['//title'].text
        @bitrate = content.attribute('bitrate').value.to_i
        @url = content.attribute('url').value
      end

      attr_reader :title

      # This is the base URL from where Play Rapport fetches its information
      # As a method to make it easier to replace for testing
      def rapport_xml_url(id = '') #:nodoc:
        "http://xml.svtplay.se/v1/videos/#{id}"
      end

      def bitrates ; [@bitrate] ; end

      def part_urls(bitrate = :whatever)
        [File.dirname(@url), [File.basename(@url)], @bitrate]
      end

      def self.record(url)
        recorder = SVT::Recorder::Rapport.new(url)
        recorder.part_urls.push recorder.title
      end
    end
  end
end
