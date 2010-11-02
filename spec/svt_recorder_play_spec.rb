# -*- coding: utf-8 -*-
require 'spec_helper'

module SVT
  module Recorder
    describe Play do
      describe 'Play.record' do
        it 'should not raise any exceptions' do
          lambda { SVT::Recorder::Play.record($play_html) }.should_not raise_error
        end

        it 'should return an array consisting of [base_url, [parts], bitrate, video_title]' do
          data = SVT::Recorder::Play.record($play_html)

          data.size.should == 4
          data[3].should == 'Matvecka: Varför är de smala inte feta? - Dokumentärfilm'
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
        it 'should return an array consisting of [base_url, parts, bitrate]' do
          recorder.bitrates
          parts = recorder.part_urls(bitrate)

          parts[0].should == 'spec/support'
          parts[1].size.should == 308
          parts[2].should == bitrate
        end

        it 'should choose the highest bitrate available if no bitrate is passed in' do
          parts = recorder.part_urls

          parts[2].should == 696752
        end
      end
    end
  end # /Recorder
end # /SVT

