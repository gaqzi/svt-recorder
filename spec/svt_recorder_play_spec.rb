# -*- coding: utf-8 -*-
require 'spec_helper'

module SVT
  module Recorder
    describe Play do
      describe 'Play.record' do
        it 'should not raise any exceptions' do
          lambda { SVT::Recorder::Play.record($play_html) }.should_not raise_error
        end

        it 'should return an instantiated and ready to use version of itself' do
          data = SVT::Recorder::Play.record($play_html)

          data.title.should == 'Matvecka: Varför är de smala inte feta? - Dokumentärfilm'
        end
      end

      let(:bitrate) { 696752 }
      let(:recorder) { SVT::Recorder::Play.new($play_html) }

      describe "#new" do
        it "should take an argument that is a URL to a SVT Play page" do
          lambda { SVT::Recorder::Play.new($play_html) }.should_not raise_error
        end

        it "should raise an ArgumentError exception if the page does not contain a <video> tag" do
          lambda { SVT::Recorder::Play.new($faulty_play_html) }.should raise_error(ArgumentError)
        end
      end

      describe '#title' do
        it 'should return the title set on the HTML page' do
          recorder.title.should == 'Matvecka: Varför är de smala inte feta? - Dokumentärfilm'
        end
      end

      describe '#bitrates' do
        it 'should give a list of all available bitrates' do
          recorder.bitrates.sort.should == [47646, 143498, 696752, 258689].sort
        end
      end

      describe '#part_urls' do
        it 'should return itself and respond to base_url, parts, bitrate and title' do
          recorder.bitrates
          data = recorder.part_urls(bitrate)

          data.base_url.should == 'spec/support'
          data.parts.size.should == 308
          data.bitrate.should == bitrate
          data.title.should == 'Matvecka: Varför är de smala inte feta? - Dokumentärfilm'
        end

        it 'should choose the highest bitrate available if no bitrate is passed in' do
          data = recorder.part_urls

          data.bitrate.should == 696752
        end
      end

      describe '#parts' do
        it 'should work as a block' do
          recorder.part_urls
          i = 0
          recorder.parts {|x| i += 1}
          i.should == 308
        end

        it 'should return an array when called without a block' do
          recorder.part_urls
          recorder.parts.size.should == 308
        end

        it 'should start with the correct directory' do
          recorder.part_urls
          recorder.parts[0].should == 'GEOSEMOBIL_1027MATVECKA-PLAY-hts-a-v1_1_Layer1/Period1/segment0.ts'
        end
      end
    end # /Play
  end # /Recorder
end # /SVT

