#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

#--
# Since I'm planning to use this library both in Ruby 1.9.2 and 1.8.7
# and 1.9.2 removes . from LOAD_PATH add this directory to the load path
$:.push File.expand_path(File.dirname(__FILE__))

require 'recorder/play'
require 'recorder/rapport'

module SVT #:nodoc:
  # == Summary
  # This library will give you the URL:s for recording files from
  # SVT Play and Play rapport.
  #
  # Read the documentation for the Play class for how to use
  # those classes directly.
  module Recorder
    # To facilitate easy recordings you can use this method to easily
    # instantiate the right class depending on the URL passed in.
    #
    # If the URL matches playrapport.se it will use the Rapport class,
    # else the Play class.
    #
    # Returns an array consisting of:
    # <tt>[base_url, [parts], bitrate, video_title]</tt>
    def self.record(url)
      if url.match(/playrapport.se/)
        SVT::Recorder::Rapport.record(url)
      else
        SVT::Recorder::Play.record(url)
      end
    end

    VERSION = '0.9.6'
  end
end
