require File.dirname(__FILE__) + '/../spec_helper'

def setup_spec
  @options = {:output_file => "bar", :resolution => "baz"}
  @input_file = "#{TEST_FILE_PATH}/kites.mp4"
  @simple_avi = "ffmpeg -i $input_file$ -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s $resolution$ -y $output_file$"
  @transcoder = RVideo::Transcoder.new(@input_file)
  @mock_original_file = mock(:original)
  @mock_original_file.stub!(:raw_response)
  RVideo::Inspector.stub!(:new).and_return(@mock_original_file)
end

module RVideo
  
  describe Transcoder, " execution" do
    before do
      setup_spec
      @transcoder.stub!(:check_integrity).and_return(true)
    end
    
    it "should pass a string as-is, along with options" do
      @transcoder.stub!(:parse_and_execute)
      @simple_avi = "ffmpeg -i foo"
      @transcoder.execute(@simple_avi, @options)
    end
    
    it "should store a Tool object at transcoder.executed_commands" do
      @mock_ffmpeg = mock("ffmpeg")
      Tools::AbstractTool.stub!(:assign).and_return(@mock_ffmpeg)
      @mock_ffmpeg.should_receive(:execute)
      @mock_ffmpeg.stub!(:original=)
      @transcoder.execute(@simple_avi, @options)
      @transcoder.executed_commands.size.should == 1
      @transcoder.executed_commands.first.should == @mock_ffmpeg
    end
    
    it "should set original file" do
      @mock_ffmpeg = mock("ffmpeg")
      Tools::AbstractTool.stub!(:assign).and_return(@mock_ffmpeg)
      @mock_ffmpeg.stub!(:execute)
      @mock_ffmpeg.should_receive(:original=).with(@transcoder.original)
      @transcoder.execute(@simple_avi, @options)
    end
    
    it "should raise an exception when trying to call a tool that doesn't exist" do
      lambda {
        @transcoder.send(:parse_and_execute, "foo -i bar", {})
      }.should raise_error(TranscoderError::UnknownTool, /recipe tried to use the 'foo' tool/)
    end
    
    it "should raise an exception when the first argument is not a string" do
      [String, 1, 1.0, true, nil, :foo].each do |obj|
        lambda {
          @transcoder.execute(obj, @options)
        }.should raise_error(TranscoderError::ParameterError, /expected.*recipe.*string/i)      
      end
    end
  end
  
  describe Transcoder, " file integrity checks" do

    before do
      setup_spec
      @transcoder.stub!(:parse_and_execute)
      @mock_processed_file = mock("processed")
      @mock_original_file.stub!(:duration).and_return 10
      @mock_original_file.stub!(:invalid?).and_return false
      @mock_processed_file.stub!(:duration).and_return 10
      @mock_processed_file.stub!(:invalid?).and_return false
      #Inspector.should_receive(:new).once.with(:file => "foo").and_return(@mock_original_file)
      Inspector.should_receive(:new).once.with(:file => "bar").and_return(@mock_processed_file)
    end

    it "should call the inspector twice on a successful job, and should set @original and @processed" do
      @transcoder.original.should_not be_nil
      @transcoder.processed.should be_nil

      @transcoder.execute(@simple_avi, @options)
      @transcoder.original.should == @mock_original_file
      @transcoder.processed.should == @mock_processed_file
    end
    
    it "should check integrity" do
      @transcoder.should_receive(:check_integrity).once.and_return true
      @transcoder.execute(@simple_avi, @options).should be_true
      @transcoder.errors.should be_empty
    end
    
    it "should fail if output duration is more than 10% different than the original" do
      @mock_original_file.should_receive(:duration).twice.and_return(10)
      @mock_processed_file.should_receive(:duration).twice.and_return(13)
      @transcoder.execute(@simple_avi, @options).should be_false
      @transcoder.errors.should == ["Original file has a duration of 10, but processed file has a duration of 13"]
    end
    
    it "should fail if the processed file is invalid" do
      @mock_processed_file.should_receive(:invalid?).and_return(true)
      @transcoder.execute(@simple_avi, @options).should be_false
      @transcoder.errors.should_not be_empty
    end
    
  end
  
  describe Transcoder, "#parse_and_execute" do
    before do
      setup_spec
      @mock_tool = mock("tool")
      @mock_tool.stub!(:execute)
      @mock_tool.stub!(:original=)
      @options_plus_input = @options.merge(:input_file => @input_file)
    end
    
    it "should assign a command via AbstractTool.assign, and pass the right options" do
      Tools::AbstractTool.should_receive(:assign).with(@simple_avi, @options_plus_input).and_return(@mock_tool)
      @transcoder.send(:parse_and_execute, @simple_avi, @options)
    end

    it "should call Tools::AbstractTool once with a one-line recipe" do
      Tools::AbstractTool.should_receive(:assign).once.and_return(@mock_tool)
      @transcoder.send(:parse_and_execute, @simple_avi, @options)
    end
    
    it "should call twice with a two-line recipe" do
      two_line = "ffmpeg -i foo \n ffmpeg -i bar"
      Tools::AbstractTool.should_receive(:assign).twice.and_return(@mock_tool)
      @transcoder.send(:parse_and_execute, two_line, @options)
    end
    
    it "should call five times with a five-line recipe" do
      five_line = "ffmpeg -i foo \n ffmpeg -i bar \n flvtool -i foo \n mp4box \n qt tools 8"
      Tools::AbstractTool.should_receive(:assign).exactly(5).and_return(@mock_tool)
      @transcoder.send(:parse_and_execute, five_line, @options)
    end
    
    it "should pass an exception from the abstract tool" do
      Tools::AbstractTool.should_receive(:assign).and_raise(TranscoderError::UnexpectedResult)
      
      lambda {
        @transcoder.send(:parse_and_execute, @simple_avi, @options)
      }.should raise_error(TranscoderError::UnexpectedResult)
    end
  end

end
