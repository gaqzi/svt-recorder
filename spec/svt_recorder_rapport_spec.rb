# -*- coding: utf-8 -*-
require 'spec_helper'

module SVT
  module Recorder
    describe Rapport do

      describe 'Rapport.record' do
        it 'should not raise any exceptions' do
          lambda { SVT::Recorder::Rapport.record($rapport_url) }.should_not raise_error
        end

        it 'should return an instantiated and ready to use version of itself' do
          data = SVT::Recorder::Rapport.record($rapport_url)
          data.title.should == title
        end
      end

      let(:title)        { '"Jag var jättestressad i finalen"' }
      let(:no_parts)     { 54 }
      let(:bitrate)      { 2508785 }
      let(:all_bitrates) { [49710, 144202, 259851, 700075, 1370141, 2508785] }
      let(:recorder)     { SVT::Recorder::Rapport.new($rapport_url) }

      describe '#new' do
        it 'should take an argument that is a URL to a Play Rapport video' do
          lambda { SVT::Recorder::Rapport.new($rapport_url) }.should_not raise_error
        end
      end

      describe '#title' do
        it 'should return the video title' do
          recorder.title.should == title
        end
      end

      describe '#bitrates' do
        it 'should return the available bitrates' do
          recorder.bitrates.sort.should == all_bitrates
        end
      end

      describe '#part_urls' do
        it 'should not care what is passed in as a bitrate' do
          lambda { recorder.part_urls('I AM CRRRRAAZY!!!!') }.should raise_error
        end

        it 'should be ready for downloading' do
          data = recorder.part_urls

          data.base_url.should == 'http://www0.c90910.dna.qbrick.com/90910/od/20120604/NYH-JORGENJONSS-hts-a-v1-b-21819c6bf2994eb1'
          data.parts.size.should == no_parts
          data.parts[0].should == 'NYH-JORGENJONSS-hts-a-v1-b-21819c6bf2994eb1_Layer6/2592_Period1/segment0.ts'
          data.bitrate.should == bitrate
        end
      end

      describe '#parts' do
        it 'should work as a block' do
          recorder.part_urls
          i = 0
          recorder.parts {|x| i += 1}
          i.should == no_parts
        end

        it 'should return an array when called without a block' do
          recorder.part_urls
          recorder.parts.size.should == no_parts
        end
      end
    end # /Rapport
  end # /Recorder
end # /SVT
