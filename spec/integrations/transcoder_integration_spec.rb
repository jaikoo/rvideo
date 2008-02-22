require File.dirname(__FILE__) + '/../spec_helper'

module RVideo
  describe "The entire system should work together" do
    it "with kites.mp4" do
      output_file = "#{TEMP_PATH}/kites.flv"
      FileUtils.rm_f(output_file)
      FileTest.exist?(output_file).should_not be_true
      transcoder = Transcoder.new("#{TEST_FILE_PATH}/kites.mp4")
      transcoder.original.class.should == Inspector
      transcoder.original.duration.should == 19600
      transcoder.execute(recipes('flash_300')['command'], {:output_file => output_file})
      FileTest.exist?(output_file).should be_true
    end

    it "with The Michael Scott Story" do
      file = 'michael_scott_story.mov'
      output_file = "#{TEMP_PATH}/#{file}.flv"
      FileUtils.rm_f(output_file)
      FileTest.exist?(output_file).should_not be_true
      transcoder = Transcoder.new("#{TEST_FILE_PATH}/#{file}")
      transcoder.original.class.should == Inspector
      transcoder.original.duration.should == 30400
      transcoder.execute(recipes('one_pass')['command'], {:output_file => output_file})
      FileTest.exist?(output_file).should be_true
    end

  end
  
  describe "When taking screenshots" do
    it "should create a screenshot with a default output path" do
      output_file = "#{TEMP_PATH}/kites-10p.jpg"
      FileTest.exist?(output_file).should_not be_true
      file = Inspector.new(:file => "#{TEST_FILE_PATH}/kites.mp4")
      file.capture_frame("10%").should == output_file
      FileTest.exist?(output_file).should be_true
      FileUtils.rm_f(output_file)
    end
    
    it "should create a screenshot with a custom output path" do
      output_file = "#{TEST_FILE_PATH}/kites-10p.jpg"
      FileTest.exist?(output_file).should_not be_true
      file = Inspector.new(:file => "#{TEST_FILE_PATH}/kites.mp4")
      file.capture_frame("10%", output_file).should == output_file
      FileTest.exist?(output_file).should be_true
      FileUtils.rm_f(output_file)
    end
  end
end