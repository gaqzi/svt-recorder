# -*- encoding: utf-8 -*-
require 'spec_helper'

module SVT
  describe "Downloader.download" do
    it "should not raise any exceptions" do
      lambda { SVT::Downloader.download($play_html) }.should_not raise_error
    end
  end

  describe Downloader do
    let(:bitrate) { 696752 }
    let(:downloader) { SVT::Downloader.new($play_html) }

    describe "#new" do
      it "shall take an argument that is an URI to a SVT Play page" do
        lambda { SVT::Downloader.new($play_html) }.should_not raise_error
      end

      it "should raise an ArgumentError exception if the page does not contain a <video> tag" do
        lambda { SVT::Downloader.new($faulty_play_html) }.should raise_error(ArgumentError)
      end
    end

    describe '#title' do
      it 'should return the title set on the HTML page' do
        downloader.title.should == 'Matvecka: Varför är de smala inte feta? - Dokumentärfilm'
      end
    end

    describe '#bitrates' do
      it 'should give a list of all available bitrates' do
        downloader.bitrates.sort.should == [47646, 143498, 696752, 258689].sort
      end
    end

    describe '#download_urls' do
      it 'should return an array of download urls' do
        downloader.bitrates
        downloader.download_urls(bitrate).size.should == 308
      end
    end
  end
end

