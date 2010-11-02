# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'SVT::Recorder.record' do
  it 'should instantiate a Rapport recorder when called with a playrapport.se URL' do
    SVT::Recorder::Rapport.stub(:record)
    SVT::Recorder::Rapport.should_receive(:record)

    SVT::Recorder.record('http://playrapport.se/#/video/2220728')
  end

  it 'should instantiate a Play recorder when the URL does not match playrapport.se' do
    SVT::Recorder::Play.stub(:record)
    SVT::Recorder::Play.should_receive(:record)

    SVT::Recorder.record('http://svtplay.se/t/103472/wikileaks')
  end
end
