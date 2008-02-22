require File.dirname(__FILE__) + '/../spec_helper'

module RVideo
  module Tools
  
    describe Flvtool2 do
      before do
        setup_flvtool2_spec
      end
      
      it "should initialize with valid arguments" do
        @flvtool2.class.should == Flvtool2
      end
      
      it "should have the correct tool_command" do
        @flvtool2.tool_command.should == 'flvtool2'
      end
      
      it "should call parse_result on execute, with a result string" do
        @flvtool2.should_receive(:parse_result).once.with /\AERROR: No such file or directory/
        @flvtool2.execute
      end
      
      it "should mixin AbstractTool" do
        Flvtool2.included_modules.include?(AbstractTool::InstanceMethods).should be_true
      end
      
      it "should set supported options successfully" do
        @flvtool2.options[:temp_file].should == @options[:temp_file]
        @flvtool2.options[:output_file].should == @options[:output_file]
      end
      
    end

    describe Flvtool2, " when parsing a result" do
      before do
        setup_flvtool2_spec
      end
      
      it "should set metadata if called with -P option" do
        @flvtool2.send(:parse_result, @metadata_result).should be_true
        @flvtool2.raw_metadata.should == @metadata_result
      end
      
      it "should succeed but not set metadata without -P option" do
        @flvtool2.send(:parse_result,"").should be_true
      end
    end
    
    context Flvtool2, " result parsing should raise an exception" do
      
      setup do
        setup_flvtool2_spec
      end
      
      specify "when not passed a command" do
        lambda {
          @flvtool2.send(:parse_result, @helptext)
        }.should raise_error(TranscoderError::InvalidCommand, /flvtool2 help text/)
      end
      
      specify "when receiving an empty file" do
        lambda {
          @flvtool2.send(:parse_result, @empty_file)
        }.should raise_error(TranscoderError::InvalidFile, /Output file was empty/)
      end
      
      specify "when passed an invalid input file" do
        lambda {
          @flvtool2.send(:parse_result, @non_flv_input)
        }.should raise_error(TranscoderError::InvalidFile, "input must be a valid FLV file")
      end
      
      specify "when input file not found" do
        lambda {
          @flvtool2.send(:parse_result, @no_input_file)
        }.should raise_error(TranscoderError::InputFileNotFound, /^ERROR: No such file or directory/)
      end
      
      specify "when receiving unexpected results" do
        lambda {
          @flvtool2.send(:parse_result, @unexpected_results)
        }.should raise_error(TranscoderError::UnexpectedResult, /ffmpeg/i)
      end      
    end
  end
end

def setup_flvtool2_spec
  @options = {:temp_file => "foo", :output_file => "bar"}
  @command = "flvtool2 -U $temp_file$ $output_file$"
  @flvtool2 = RVideo::Tools::Flvtool2.new(@command, @options)
  
  @helptext = "FLVTool2 1.0.6
  Copyright (c) 2005-2007 Norman Timmler (inlet media e.K., Hamburg, Germany)
  Get the latest version from http://www.inlet-media.de/flvtool2
  This program is published under the BSD license.

  Usage: flvtool2 [-ACDPUVaciklnoprstvx]... [-key:value]... in-path|stdin [out-path|stdout]

  If out-path is omitted, in-path will be overwritten.
  In-path can be a single file, or a directory. If in-path is a directory,
  out-path has to be likewise, or can be omitted. Directory recursion
  is controlled by the -r switch. You can use stdin and stdout keywords
  as in- and out-path for piping or redirecting.

  Chain commands like that: -UP (updates FLV file than prints out meta data)

  Commands:
    -A            Adds tags from -t tags-file
    -C            Cuts file using -i inpoint and -o outpoint
    -D            Debugs file (writes a lot to stdout)
    -H            Helpscreen will be shown
    -P            Prints out meta data to stdout
    -U            Updates FLV with an onMetaTag event

  Switches:
    -a            Collapse space between cutted regions
    -c            Compatibility mode calculates some onMetaTag values different
    -key:value    Key-value-pair for onMetaData tag (overwrites generated values)
    -i timestamp  Inpoint for cut command in miliseconds
    -k            Keyframe mode slides onCuePoint(navigation) tags added by the
                  add command to nearest keyframe position
    -l            Logs FLV stream reading to stream.log in current directory
    -n            Number of tag to debug
    -o timestamp  Outpoint for cut command in miliseconds
    -p            Preserve mode only updates FLVs that have not been processed
                  before
    -r            Recursion for directory processing
    -s            Simulation mode never writes FLV data to out-path
    -t path       Tagfile (MetaTags written in XML)
    -v            Verbose mode
    -x            XML mode instead of YAML mode

  REPORT BUGS at http://projects.inlet-media.de/flvtool2
  Powered by Riva VX, http://rivavx.com"
  
  @non_flv_input = "ERROR: IO is not a FLV stream. Wrong signature.
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flv/stream.rb:393:in `read_header'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flv/stream.rb:57:in `initialize'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:272:in `new'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:272:in `open_stream'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:238:in `process_files'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:225:in `each'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:225:in `process_files'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:44:in `execute!'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2.rb:168:in `execute!'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2.rb:228
  ERROR: /opt/local/lib/ruby/vendor_ruby/1.8/rubygems/custom_require.rb:27:in `gem_original_require'
  ERROR: /opt/local/lib/ruby/vendor_ruby/1.8/rubygems/custom_require.rb:27:in `require'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/bin/flvtool2:2
  ERROR: /opt/local/bin/flvtool2:18:in `load'
  ERROR: /opt/local/bin/flvtool2:18"
  
  @no_input_file = "ERROR: No such file or directory - /Users/jon/code/spinoza/rvideo/foobar
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:259:in `initialize'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:259:in `open'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:259:in `open_stream'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:238:in `process_files'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:225:in `each'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:225:in `process_files'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:44:in `execute!'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2.rb:168:in `execute!'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2.rb:228
  ERROR: /opt/local/lib/ruby/vendor_ruby/1.8/rubygems/custom_require.rb:27:in `gem_original_require'
  ERROR: /opt/local/lib/ruby/vendor_ruby/1.8/rubygems/custom_require.rb:27:in `require'
  ERROR: /opt/local/lib/ruby/gems/1.8/gems/flvtool2-1.0.6/bin/flvtool2:2
  ERROR: /opt/local/bin/flvtool2:18:in `load'
  ERROR: /opt/local/bin/flvtool2:18"
  
  @unexpected_results = "FFmpeg version CVS, Copyright (c) 2000-2004 Fabrice Bellard
  Mac OSX universal build for ffmpegX
    configuration:  --enable-memalign-hack --enable-mp3lame --enable-gpl --disable-vhook --disable-ffplay --disable-ffserver --enable-a52 --enable-xvid --enable-faac --enable-faad --enable-amr_nb --enable-amr_wb --enable-pthreads --enable-x264 
    libavutil version: 49.0.0
    libavcodec version: 51.9.0
    libavformat version: 50.4.0
    built on Apr 15 2006 04:58:19, gcc: 4.0.1 (Apple Computer, Inc. build 5250)

  Seems that stream 1 comes from film source: 600.00 (600/1) -> 59.75 (239/4)
  Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'jobjob2.mov':
    Duration: 00:01:09.0, start: 0.000000, bitrate: 28847 kb/s
    Stream #0.0(eng): Audio: aac, 44100 Hz, stereo
    Stream #0.1(eng), 59.75 fps(r): Video: dvvideo, yuv411p, 720x480
  Stream mapping:
    Stream #0.1 -> #0.0
    Stream #0.0 -> #0.1
  Press [q] to stop encoding"
  
  @empty_file = "ERROR: undefined method `timestamp' for nil:NilClass ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flv/stream.rb:285:in `lasttimestamp' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flv/stream.rb:274:in `duration' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:181:in `add_meta_data_tag' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:137:in `update' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:47:in `send' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:47:in `execute!' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:46:in `each' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:46:in `execute!' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:239:in `process_files' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:225:in `each' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:225:in `process_files' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2/base.rb:44:in `execute!' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2.rb:168:in `execute!' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/lib/flvtool2.rb:228 ERROR: /usr/lib/ruby/1.8/rubygems/custom_require.rb:27:in `gem_original_require' ERROR: /usr/lib/ruby/1.8/rubygems/custom_require.rb:27:in `require' ERROR: /var/lib/gems/1.8/gems/flvtool2-1.0.6/bin/flvtool2:2 ERROR: /var/lib/gems/1.8/bin/flvtool2:18:in `load' ERROR: /var/lib/gems/1.8/bin/flvtool2:18"
  
  @metadata_result = "---
  /Users/jon/code/spinoza/rvideo/temp.flv: 
    hasKeyframes: true
    cuePoints: 
    audiodatarate: 64.8512825785226
    hasVideo: true
    stereo: false
    canSeekToEnd: false
    framerate: 30
    audiosamplerate: 44000
    videocodecid: 2
    datasize: 992710
    lasttimestamp: 19.453
    audiosamplesize: 16
    audiosize: 165955
    hasAudio: true
    audiodelay: 0
    videosize: 825165
    metadatadate: Fri Sep 14 13:25:58 GMT-0500 2007
    metadatacreator: inlet media FLVTool2 v1.0.6 - http://www.inlet-media.de/flvtool2
    lastkeyframetimestamp: 19.219
    height: 240
    filesize: 998071
    hasMetadata: true
    keyframes: 
      times: 
        - 0
        - 0.4
        - 0.801
        - 1.201
        - 1.602
        - 2.002
        - 2.402
        - 2.803
        - 3.203
        - 3.604
        - 4.004
        - 4.404
        - 4.805
        - 5.205
        - 5.606
        - 6.006
        - 6.406
        - 6.807
        - 7.207
        - 7.608
        - 8.008
        - 8.408
        - 8.809
        - 9.209
        - 9.61
        - 10.01
        - 10.41
        - 10.811
        - 11.211
        - 11.612
        - 12.012
        - 12.412
        - 12.813
        - 13.213
        - 13.614
        - 14.014
        - 14.414
        - 14.815
        - 15.215
        - 15.616
        - 16.016
        - 16.416
        - 16.817
        - 17.217
        - 17.618
        - 18.018
        - 18.418
        - 18.819
        - 19.219
      filepositions: 
        - 1573
        - 24627
        - 56532
        - 90630
        - 137024
        - 185134
        - 225110
        - 262990
        - 291508
        - 330947
        - 370739
        - 398621
        - 426203
        - 448515
        - 468895
        - 488660
        - 508208
        - 523991
        - 541463
        - 558463
        - 572248
        - 590480
        - 604788
        - 620959
        - 632658
        - 645806
        - 655949
        - 668266
        - 684172
        - 697064
        - 713306
        - 728607
        - 746615
        - 760836
        - 774867
        - 790766
        - 804779
        - 821676
        - 843681
        - 857278
        - 873427
        - 888404
        - 900958
        - 914336
        - 927537
        - 941037
        - 958188
        - 974841
        - 988796
    audiocodecid: 2
    videodatarate: 336.705289672544
    duration: 19.486
    hasCuePoints: false
    width: 320
  ..."
end