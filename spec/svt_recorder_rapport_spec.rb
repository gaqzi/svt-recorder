# -*- coding: utf-8 -*-
require 'spec_helper'

module SVT
  module Recorder
    describe Rapport do
      class Rapport
        def rapport_xml_url(id = '')
          "spec/support/#{id}"
        end
      end

      describe 'Rapport.record' do
        it 'should not raise any exceptions' do
          lambda { SVT::Recorder::Rapport.record($rapport_url) }.should_not raise_error
        end

        it 'should return an array consisting of [base_url, [parts], bitrate, video_title]' do
          data = SVT::Recorder::Rapport.record($rapport_url)
          data.size.should == 4
          data[3].should == 'Huvudvärk kan ha orsakat polispådraget i Göteborg'
        end
      end

      let(:recorder) { SVT::Recorder::Rapport.new($rapport_url) }

      describe '#new' do
        it 'should take an argument that is a URL to a Play Rapport video' do
          lambda { SVT::Recorder::Rapport.new($rapport_url) }.should_not raise_error
        end
      end

      describe '#title' do
        it 'should return the video title' do
          recorder.title.should == 'Huvudvärk kan ha orsakat polispådraget i Göteborg'
        end
      end

      describe '#bitrates' do
        it 'should return the available bitrates' do
          recorder.bitrates.sort.should == [650]
        end
      end

      describe '#part_urls' do
        it 'should not care what is passed in as a bitrate' do
          lambda { recorder.part_urls('I AM CRRRRAAZY!!!!') }.should_not raise_error
        end

        it 'should return an array consisting of [base_url, parts, bitrate]' do
          parts = recorder.part_urls

          parts[0].should == 'http://www0.c00928.cdn.qbrick.com/00928/kluster/20101101'
          parts[1].size.should == 1
          parts[1][0].should == 'PR-2010-1101-TOHAGBG1930.flv'
          parts[2].should == 650
        end
      end
    end # /Rapport
  end # /Recorder
end # /SVT
