require File.dirname(__FILE__) + '/../spec_helper'

module RVideo
  describe Inspector do
    it "should raise an error if ffmpeg cannot be found" do
      lambda {
        file = Inspector.new(:file => "#{TEST_FILE_PATH}/kites.mp4", :ffmpeg_binary => "ffmpeg-nonexistant")
      }.should raise_error(RuntimeError, /^ffmpeg could not be found/)
    end
    
    it "should raise an error if it doesn't recognize a file format" do
      unrecognized_format(:text)
    end
    
    def unrecognized_format(format)
      file = Inspector.new(:raw_response => files(format))
      file.unknown_format?.should be_true
    end
  end
  
  describe Inspector, " when grabbing a frame" do
    before do
      @file = Inspector.new(:raw_response => files(:kites))
    end
    
    it "should calculate a timecode, when given a percentage" do
      @file.duration.should == 19600
      @file.calculate_time("10%").should be_close(1.96, 0.1)
      @file.calculate_time("1%").should be_close(0.196, 0.001)
      @file.calculate_time("75%").should be_close(14.7, 0.1)
      @file.calculate_time("100%").should be_close(19.6, 0.1)
    end
    
    it "should calculate a timecode, when given a frame" do
      @file.fps.should == "10.00"
      @file.calculate_time("10f").should be_close(1.0, 0.1)
      @file.calculate_time("27.6f").should be_close(2.76, 0.1)
      
      @file.stub!(:fps).and_return(29.97)
      @file.calculate_time("276f").should be_close(9.2, 0.1)
      @file.calculate_time("10f").should be_close(0.3, 0.1)
      @file.calculate_time("29.97f").should be_close(1.0, 0.01)
    end
      
    it "should return itself when given seconds" do
      [1, 10, 14, 3.7, 2.8273, 16].each do |t|
        @file.calculate_time("#{t}s").should == t
      end
    end
    
    it "should return itself when given no letter" do
      [1, 10, 14, 3.7, 2.8273, 16].each do |t|
        @file.calculate_time("#{t}").should == t
      end
    end
    
    it "should return a frame at 99%, when given something outside of the bounds of the file" do
      nn = @file.calculate_time("99%")
      %w(101% 20s 99 300f).each do |tc|
        @file.calculate_time(tc).should be_close(nn, 0.01)
      end
    end
  end
  
  describe Inspector, " parsing ffmpeg info" do
    
    it "should read ffmpeg build data successfully (with a darwinports build)" do
      file = Inspector.new(:raw_response => ffmpeg('darwinports'))
      file.ffmpeg_configuration.should == "--prefix=/opt/local --prefix=/opt/local --disable-vhook --mandir=/opt/local/share/man --extra-cflags=-DHAVE_LRINTF --extra-ldflags=-d -L/opt/local/lib --enable-gpl --enable-mp3lame --enable-libogg --enable-vorbis --enable-faac --enable-faad --enable-xvid --enable-x264 --enable-a52 --enable-dts"
      file.ffmpeg_version.should == "SVN-r6399"
      file.ffmpeg_libav.should == ["libavutil version: 49.0.1", "libavcodec version: 51.16.0", "libavformat version: 50.5.0"]
      file.ffmpeg_build.should == "built on Mar 29 2007 17:18:04, gcc: 4.0.1 (Apple Computer, Inc. build 5367)"
      file.raw_metadata.should =~ /^Input #/
    end
    
    it "should read ffmpeg build data successfully (with a compiled build)" do
      file = Inspector.new(:raw_response => ffmpeg(:osx_intel_1))
      file.ffmpeg_configuration.should == "--enable-memalign-hack --enable-mp3lame --enable-gpl --disable-vhook --disable-ffplay --disable-ffserver --enable-a52 --enable-xvid --enable-faac --enable-faad --enable-amr_nb --enable-amr_wb --enable-pthreads --enable-x264"
      file.ffmpeg_version.should == "CVS"
      file.ffmpeg_libav.should == ["libavutil version: 49.0.0", "libavcodec version: 51.9.0", "libavformat version: 50.4.0"]
      file.ffmpeg_build.should == "built on Apr 15 2006 04:58:19, gcc: 4.0.1 (Apple Computer, Inc. build 5250)"
      file.raw_metadata.should =~ /^Input #/
    end
    
    it "should handle '\n' newline characters" do
      raw_response = "FFmpeg version SVN-r10656, Copyright (c) 2000-2007 Fabrice Bellard, et al.\n  configuration: --enable-libmp3lame --enable-libogg --enable-libvorbis --enable-liba52 --enable-libxvid --enable-libfaac --enable-libfaad --enable-libx264 --enable-libxvid --enable-pp --enable-shared --enable-gpl --enable-libtheora --enable-libfaadbin --enable-liba52bin --enable-libamr_nb --enable-libamr_wb --enable-libacfr16 --extra-ldflags=-L/root/src/ffmpeg/libavcodec/acfr16/ --extra-libs=-lacfr\n  libavutil version: 49.5.0\n  libavcodec version: 51.44.0\n  libavformat version: 51.14.0\n  built on Oct  9 2007 18:53:49, gcc: 4.1.2 (Ubuntu 4.1.2-0ubuntu4)\nInput #0, mp3, from '/mnt/app/worker/tmp/2112/2007-07-29_11AM.mp3':\n  Duration: 00:22:09.2, bitrate: 80 kb/s\n  Stream #0.0: Audio: mp3, 22050 Hz, stereo, 80 kb/s\nMust supply at least one output file\n"
      
      file = Inspector.new(:raw_response => raw_response)
      file.ffmpeg_version.should == "SVN-r10656"
      file.audio_codec.should == "mp3"
    end
  end
end