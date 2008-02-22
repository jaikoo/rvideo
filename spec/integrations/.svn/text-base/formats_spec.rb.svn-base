require File.dirname(__FILE__) + '/../spec_helper'

module RVideo
  context "Using various builds of ffmpeg, RVideo should properly inspect" do
    specify "a cell-phone MP4 file" do
      file = Inspector.new(:raw_response => files(:kites))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:00:19.6"
      file.duration.should == 19600
      file.bitrate.should == 98
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.1"
      file.audio_codec.should == "samr / 0x726D6173"
      file.audio_sample_rate.should == 8000
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "mono"
      file.video_codec.should == "mpeg4"
      file.video_stream_id.should == "#0.0"
      file.video_colorspace.should == "yuv420p"
      file.width.should == 176
      file.height.should == 144
      file.fps.should == "10.00"
    end
    
    specify "a cell-phone MP4 file (2)" do
      file = Inspector.new(:raw_response => files(:kites2))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:00:19.6"
      file.duration.should == 19600
      file.bitrate.should == 98
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.1"
      file.audio_codec.should == "samr / 0x726D6173"
      file.audio_sample_rate.should == 8000
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "mono"
      file.video_codec.should == "mpeg4"
      file.video_stream_id.should == "#0.0"
      file.video_colorspace.should == "yuv420p"
      file.width.should == 176
      file.height.should == 144
      file.fps.should == "10.00"
    end
    
    specify "fancypants" do
      file = Inspector.new(:raw_response => files(:fancypants))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:00:35.4"
      file.duration.should == 35400
      file.bitrate.should == 1980
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.1"
      file.audio_codec.should == "aac"
      file.audio_sample_rate.should == 44100
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "stereo"
      file.video_codec.should == "h264"
      file.video_stream_id.should == "#0.0"
      file.video_colorspace.should == "yuv420p"
      file.width.should == 720
      file.height.should == 400
      file.fps.should == "23.98"
    end
    
    specify "mpeg4/xvid" do
      file = Inspector.new(:raw_response => files(:chainsaw))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:01:09.5"
      file.duration.should == 69500
      file.bitrate.should == 970
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.1"
      file.audio_codec.should == "mp2"
      file.audio_sample_rate.should == 48000
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "stereo"
      file.video_codec.should == "mpeg4"
      file.video_stream_id.should == "#0.0"
      file.video_colorspace.should == "yuv420p"
      file.width.should == 624
      file.height.should == 352
      file.fps.should == "23.98"
    end
    
    specify "mpeg1" do
      file = Inspector.new(:raw_response => files(:mpeg1_957))
      file.container.should == "mpeg"
      file.raw_duration.should == "00:00:22.6"
      file.duration.should == 22600
      file.bitrate.should == 808
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.0"
      file.audio_codec.should == "mp2"
      file.audio_sample_rate.should == 32000
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "mono"
      file.video_codec.should == "mpeg1video"
      file.video_stream_id.should == "#0.1"
      file.video_colorspace.should == "yuv420p"
      file.width.should == 320
      file.height.should == 240
      file.fps.should == "25.00"
    end
    
    specify "avi/mpeg4/mp3" do
      file = Inspector.new(:raw_response => files(:buffy))
      file.container.should == "avi"
      file.raw_duration.should == "00:43:25.3"
      file.duration.should == 2605300
      file.bitrate.should == 1266
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.1"
      file.audio_codec.should == "mp3"
      file.audio_sample_rate.should == 48000
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "stereo"
      file.video_codec.should == "mpeg4"
      file.video_stream_id.should == "#0.0"
      file.video_colorspace.should == "yuv420p"
      file.width.should == 640
      file.height.should == 464
      file.fps.should == "23.98"
    end
    
    specify "HD mpeg2" do
      file = Inspector.new(:raw_response => files(:chairprank))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:00:36.6"
      file.duration.should == 36600
      file.bitrate.should == 26602
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.0"
      file.audio_codec.should == "pcm_s16le"
      file.audio_sample_rate.should == 48000
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "stereo"
      file.video_codec.should == "mpeg2video"
      file.video_stream_id.should == "#0.1"
      file.video_colorspace.should == "yuv420p"
      file.width.should == 1440
      file.height.should == 1080
      file.fps.should == "29.97"
    end
    
    specify "h264 (1)" do
      file = Inspector.new(:raw_response => files(:fire_short))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:00:10.0"
      file.duration.should == 10000
      file.bitrate.should == 23232
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.0"
      file.audio_codec.should == "pcm_s16le"
      file.audio_sample_rate.should == 48000
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "stereo"
      file.video_codec.should == "h264"
      file.video_stream_id.should == "#0.1"
      file.video_colorspace.should == "yuv420p"
      file.width.should == 1280
      file.height.should == 720
      file.fps.should == "29.97"
    end
    
    specify "h264 video only" do
      file = Inspector.new(:raw_response => files(:fire_video_only))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:00:10.0"
      file.duration.should == 10000
      file.bitrate.should == 506
      file.bitrate_units.should == "kb/s"
      file.audio?.should == false
      file.audio_codec.should == nil
      file.video_codec.should == "h264"
      file.video_stream_id.should == "#0.0"
      file.video_colorspace.should == "yuv420p"
      file.width.should == 320
      file.height.should == 180
      file.fps.should == "29.97"
    end
    
    specify "aac audio only" do
      file = Inspector.new(:raw_response => files(:fire_audio_only))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:00:10.0"
      file.duration.should == 10000
      file.bitrate.should == 86
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.0"
      file.audio_codec.should == "aac"
      file.audio_sample_rate.should == 48000
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "stereo"
      file.video?.should == false
      file.video_codec.should be_nil
    end
    
    specify "apple intermediate" do
      file = Inspector.new(:raw_response => files(:fireproof))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:00:18.7"
      file.duration.should == 18700
      file.bitrate.should == 24281
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.0"
      file.audio_codec.should == "pcm_s16be"
      file.audio_sample_rate.should == 48000
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "mono"
      file.video_codec.should == "Apple Intermediate Codec"
      file.video_stream_id.should == "#0.1"
      file.video_colorspace.should == nil
      file.width.should == 1280
      file.height.should == 720
      file.fps.should == "600.00" # this is a known FFMPEG problem
    end
    
    specify "dv video" do
      
    end
    
    specify "msmpeg4" do
      
    end
    
    specify "mpeg2 ac3" do
      
    end
    
    specify "m4v h264" do
      
    end
    
    specify "3g2" do
      
    end
    
    specify "3gp (1)" do
      
    end
    
    specify "3gp (2)" do
      
    end
    
    specify "flv" do
      
    end
    
    specify "wmv (1)" do
      
    end
    
    specify "wmv/wmv3/wmav2" do
      
    end
    
    specify "wmva/wmva2" do
      
    end
    
    specify "mov/msmpeg4" do
      
    end
    
    specify "audio only mp3" do
      file = Inspector.new(:raw_response => files(:duck))
      file.container.should == "mp3"
      file.raw_duration.should == "00:02:03.0"
      file.duration.should == 123000
      file.bitrate.should == 128
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.0"
      file.audio_codec.should == "mp3"
      file.audio_sample_rate.should == 44100
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "stereo"
      file.audio?.should == true
      file.video?.should == false
    end
    
    specify "audio only aac" do
      file = Inspector.new(:raw_response => files(:eiffel))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should == "00:02:50.3"
      file.duration.should == 170300
      file.bitrate.should == 162
      file.bitrate_units.should == "kb/s"
      file.audio_stream_id.should == "#0.0"
      file.audio_codec.should == "aac"
      file.audio_sample_rate.should == 44100
      file.audio_sample_units.should == "Hz"
      file.audio_channels_string.should == "stereo"
      file.audio?.should == true
      file.video?.should == false
    end
    
    specify "invalid file" do
      file = Inspector.new(:raw_response => files(:invalid))
      file.container.should == "mov,mp4,m4a,3gp,3g2,mj2"
      file.raw_duration.should be_nil
      file.valid?.should be_false
      file.unknown_format?.should be_false
      file.unreadable_file?.should be_true
    end
    
    specify "failing mp3 file" do
      file = Inspector.new(:raw_response => files(:failing_ogg))
      file.raw_duration.should be_nil
      file.invalid?.should be_true
      file.unknown_format?.should be_false
      file.unreadable_file?.should be_true
    end  
  end
end