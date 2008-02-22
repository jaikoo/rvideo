require File.dirname(__FILE__) + '/../spec_helper'

module RVideo
  module Tools
  
    describe Mencoder do
      before do
        setup_mencoder_spec
      end
      
      it "should initialize with valid arguments" do
        @mencoder.class.should == Mencoder
      end
      
      it "should have the correct tool_command" do
        @mencoder.tool_command.should == 'mencoder'
      end
      
      it "should call parse_result on execute, with a mencoder result string" do
        @mencoder.should_receive(:parse_result).once.with /\AMEncoder/
        @mencoder.execute
      end
      
      it "should mixin AbstractTool" do
        Mencoder.included_modules.include?(AbstractTool::InstanceMethods).should be_true
      end
      
      it "should set supported options successfully" do
        @mencoder.options[:resolution].should == @options[:resolution]
        @mencoder.options[:input_file].should == @options[:input_file]
        @mencoder.options[:output_file].should == @options[:output_file]
      end
    end
    
    describe Mencoder, " when parsing a result" do
      before do
        setup_mencoder_spec
      end
      
      it "should create correct result metadata (1)" do
        @mencoder.send(:parse_result, @long_result)
      end

    end
    
    context Mencoder, " result parsing should raise an exception" do
      
      setup do
        setup_mencoder_spec
      end
      
      specify "when not passed a command" do
        result = "MEncoder 1.0rc1-4.0.1 (C) 2000-2006 MPlayer Team
        CPU: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz (Family: 6, Model: 15, Stepping: 6)
        CPUflags: Type: 6 MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
        Compiled for x86 CPU with extensions: MMX MMX2 SSE SSE2

        98 audio & 216 video codecs

        Exiting... (No output file specified, please see the -o option.)"
        
        lambda {
          @mencoder.send(:parse_result, result)
        }.should raise_error(TranscoderError::InvalidCommand, "no command passed to mencoder, or no output file specified")
      end
    end
  end
end

def setup_mencoder_spec
  @options = {:input_file => "foo", :output_file => "bar", :resolution => "baz"}
  @simple_avi = "mencoder -i $input_file$ -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s $resolution$ -y $output_file$"  
  @mencoder = RVideo::Tools::Mencoder.new(@simple_avi, @options)
  
  @long_result = "MEncoder 1.0rc1-4.0.1 (C) 2000-2006 MPlayer Team
  CPU: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz (Family: 6, Model: 15, Stepping: 6)
  CPUflags: Type: 6 MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
  Compiled for x86 CPU with extensions: MMX MMX2 SSE SSE2

  98 audio & 216 video codecs
  success: format: 0  data: 0x0 - 0xce3c20
  ASF file format detected.
  VIDEO:  [WMV1]  480x480  24bpp  25.000 fps    0.0 kbps ( 0.0 kbyte/s)
  [V] filefmt:6  fourcc:0x31564D57  size:480x480  fps:25.00  ftime:=0.0400
  ==========================================================================
  Opening audio decoder: [ffmpeg] FFmpeg/libavcodec audio decoders
  AUDIO: 44100 Hz, 2 ch, s16le, 64.0 kbit/4.54% (ratio: 8005->176400)
  Selected audio codec: [ffwmav2] afm: ffmpeg (DivX audio v2 (FFmpeg))
  ==========================================================================
  ** MUXER_LAVF *****************************************************************
  You have certified that your video stream does not contain B frames.
  REMEMBER: MEncoder's libavformat muxing is presently broken and will generate
  INCORRECT files in the presence of B frames. Moreover, due to bugs MPlayer
  will play these INCORRECT files as if nothing were wrong!
  *******************************************************************************
  OK, exit
  Opening video filter: [expand osd=1]
  Expand: -1 x -1, -1 ; -1, osd: 1, aspect: 0.000000, round: 1
  Opening video filter: [harddup]
  ==========================================================================
  Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
  Selected video codec: [ffwmv1] vfm: ffmpeg (FFmpeg M$ WMV1/WMV7)
  ==========================================================================
  VDec: vo config request - 480 x 480 (preferred colorspace: Planar YV12)
  VDec: using Planar YV12 as output csp (no 0)
  Movie-Aspect is undefined - no prescaling applied.
  videocodec: libavcodec (480x480 fourcc=34504d46 [FMP4])
  VIDEO CODEC ID: 13
  AUDIO CODEC ID: 15002, TAG: 0
  Writing header...
  Pos:   0.0s      1f ( 1%)  0.00fps Trem:   0min   1mb  A-V:0.000 [0:0]
  1 duplicate frame(s)!
  Pos:   0.1s      2f ( 1%)  0.00fps Trem:   0min   1mb  A-V:0.007 [0:0]
  1 duplicate frame(s)!
  Pos:   0.2s      3f ( 1%)  0.00fps Trem:   0min   2mb  A-V:0.013 [0:0]
  1 duplicate frame(s)!
  Pos:   0.2s      4f ( 1%)  0.00fps Trem:   0min   2mb  A-V:0.020 [0:0]
  1 duplicate frame(s)!
  Pos:   0.3s      5f ( 1%)  0.00fps Trem:   0min   3mb  A-V:0.027 [0:0]
  1 duplicate frame(s)!
  Pos:   0.4s      6f ( 1%)  0.00fps Trem:   0min   3mb  A-V:0.033 [0:0]
  1 duplicate frame(s)!
  Pos:   0.5s      8f ( 1%)  0.00fps Trem:   0min   3mb  A-V:0.013 [0:0]
  1 duplicate frame(s)!
  Pos:   0.5s      9f ( 1%)  0.00fps Trem:   0min   4mb  A-V:0.020 [0:0]
  1 duplicate frame(s)!
  Pos:   0.6s     10f ( 1%)  0.00fps Trem:   0min   4mb  A-V:0.027 [0:56]
  1 duplicate frame(s)!
  Pos:   0.7s     11f ( 1%)  0.00fps Trem:   0min   4mb  A-V:0.033 [0:56]
  1 duplicate frame(s)!
  Pos:   0.8s     13f ( 1%)  0.00fps Trem:   0min   4mb  A-V:0.013 [0:58]
  1 duplicate frame(s)!
  Pos:   0.8s     14f ( 1%)  0.00fps Trem:   0min   4mb  A-V:0.020 [0:58]
  1 duplicate frame(s)!
  Pos:   0.9s     15f ( 1%)  0.00fps Trem:   0min   4mb  A-V:0.027 [0:59]
  1 duplicate frame(s)!
  Pos:   1.0s     16f ( 1%)  0.00fps Trem:   0min   4mb  A-V:0.033 [0:59]
  1 duplicate frame(s)!
  Pos:   1.1s     18f ( 1%)  0.00fps Trem:   0min   5mb  A-V:0.013 [726:60]
  1 duplicate frame(s)!
  Pos:   1.1s     19f ( 1%)  0.00fps Trem:   0min   5mb  A-V:0.020 [713:61]
  1 duplicate frame(s)!
  Pos:   1.2s     20f ( 1%)  0.00fps Trem:   0min   5mb  A-V:0.027 [696:60]
  1 duplicate frame(s)!
  Pos:   1.3s     21f ( 1%)  0.00fps Trem:   0min   5mb  A-V:0.032 [685:61]
  1 duplicate frame(s)!
  Pos:   1.4s     23f ( 2%)  0.00fps Trem:   0min   5mb  A-V:0.012 [675:61]
  1 duplicate frame(s)!
  Pos:   1.4s     24f ( 2%)  0.00fps Trem:   0min   5mb  A-V:0.019 [665:61]
  1 duplicate frame(s)!
  Pos:   1.5s     25f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.025 [655:62]
  1 duplicate frame(s)!
  Pos:   1.6s     26f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.032 [644:62]
  1 duplicate frame(s)!
  Pos:   1.6s     27f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.031 [635:63]
  1 duplicate frame(s)!
  Pos:   1.7s     29f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.009 [628:63]
  1 duplicate frame(s)!
  Pos:   1.8s     30f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.009 [619:63]
  1 duplicate frame(s)!
  Pos:   1.9s     31f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.016 [612:63]
  1 duplicate frame(s)!
  Pos:   1.9s     32f ( 2%)  0.00fps Trem:   0min   5mb  A-V:0.022 [603:64]
  1 duplicate frame(s)!
  Pos:   2.0s     33f ( 2%)  0.00fps Trem:   0min   5mb  A-V:0.028 [597:64]
  1 duplicate frame(s)!
  Pos:   2.1s     34f ( 2%)  0.00fps Trem:   0min   5mb  A-V:0.030 [591:64]
  1 duplicate frame(s)!
  Pos:   2.2s     36f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.002 [589:65]
  1 duplicate frame(s)!
  Pos:   2.2s     37f ( 2%)  0.00fps Trem:   0min   6mb  A-V:-0.001 [584:65]
  1 duplicate frame(s)!
  Pos:   2.3s     38f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.005 [579:65]
  1 duplicate frame(s)!
  Pos:   2.4s     39f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.008 [574:65]
  1 duplicate frame(s)!
  Pos:   2.4s     40f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.015 [569:65]
  1 duplicate frame(s)!
  Pos:   2.5s     41f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.019 [564:65]
  1 duplicate frame(s)!
  Pos:   2.6s     42f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.014 [562:65]
  1 duplicate frame(s)!
  Pos:   2.6s     43f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.008 [557:65]
  1 duplicate frame(s)!
  Pos:   2.7s     44f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.014 [553:65]
  1 duplicate frame(s)!
  Pos:   2.8s     45f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.017 [549:64]
  1 duplicate frame(s)!
  Pos:   2.8s     46f ( 2%)  0.00fps Trem:   0min   6mb  A-V:0.014 [545:64]
  1 duplicate frame(s)!
  Pos:   2.9s     47f ( 3%)  0.00fps Trem:   0min   6mb  A-V:0.021 [540:64]
  1 duplicate frame(s)!
  Pos:   3.0s     48f ( 3%)  0.00fps Trem:   0min   6mb  A-V:0.026 [538:64]
  1 duplicate frame(s)!
  Pos:   3.0s     49f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.023 [533:64]
  1 duplicate frame(s)!
  Pos:   3.1s     50f ( 3%)  0.00fps Trem:   0min   6mb  A-V:0.030 [530:64]
  1 duplicate frame(s)!
  Pos:   3.2s     51f ( 3%)  0.00fps Trem:   0min   6mb  A-V:0.031 [527:64]
  1 duplicate frame(s)!
  Pos:   3.2s     52f ( 3%)  0.00fps Trem:   0min   6mb  A-V:0.025 [524:64]
  1 duplicate frame(s)!
  Pos:   3.3s     53f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.031 [520:64]
  1 duplicate frame(s)!
  Pos:   3.4s     54f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.030 [517:64]
  1 duplicate frame(s)!
  Pos:   3.4s     55f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.025 [512:65]
  1 duplicate frame(s)!
  Pos:   3.5s     56f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.032 [509:64]
  1 duplicate frame(s)!
  Pos:   3.6s     58f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.007 [504:64]
  1 duplicate frame(s)!
  Pos:   3.7s     59f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.010 [499:64]
  1 duplicate frame(s)!
  Pos:   3.7s     60f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.008 [496:64]
  1 duplicate frame(s)!
  Pos:   3.8s     61f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.012 [493:64]
  1 duplicate frame(s)!
  Pos:   3.9s     62f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.010 [493:64]
  1 duplicate frame(s)!
  Pos:   3.9s     63f ( 3%)  0.00fps Trem:   0min   6mb  A-V:0.015 [490:64]
  1 duplicate frame(s)!
  Pos:   4.0s     64f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.014 [488:64]
  1 duplicate frame(s)!
  Pos:   4.1s     65f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.008 [484:64]
  1 duplicate frame(s)!
  Pos:   4.1s     66f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.012 [481:64]
  1 duplicate frame(s)!
  Pos:   4.2s     67f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.012 [479:64]
  1 duplicate frame(s)!
  Pos:   4.3s     68f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.006 [476:64]
  1 duplicate frame(s)!
  Pos:   4.3s     69f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.012 [474:64]
  1 duplicate frame(s)!
  Pos:   4.4s     70f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.011 [472:64]
  1 duplicate frame(s)!
  Pos:   4.5s     71f ( 3%)  0.00fps Trem:   0min   7mb  A-V:0.006 [469:64]
  1 duplicate frame(s)!
  Pos:   4.5s     72f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.011 [466:64]
  1 duplicate frame(s)!
  Pos:   4.6s     73f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.007 [466:64]
  1 duplicate frame(s)!
  Pos:   4.7s     74f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.014 [466:64]
  1 duplicate frame(s)!
  Pos:   4.7s     75f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.014 [463:64]
  1 duplicate frame(s)!
  Pos:   4.8s     76f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.010 [463:64]
  1 duplicate frame(s)!
  Pos:   4.9s     77f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.016 [463:64]
  1 duplicate frame(s)!
  Pos:   4.9s     78f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.019 [462:63]
  1 duplicate frame(s)!
  Pos:   5.0s     79f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.013 [460:64]
  1 duplicate frame(s)!
  Pos:   5.1s     80f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.017 [458:63]
  1 duplicate frame(s)!
  Pos:   5.1s     81f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.017 [457:63]
  1 duplicate frame(s)!
  Pos:   5.2s     82f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.023 [456:63]
  1 duplicate frame(s)!
  Pos:   5.3s     83f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.024 [454:64]
  1 duplicate frame(s)!
  Pos:   5.3s     84f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.030 [453:64]
  1 duplicate frame(s)!
  Pos:   5.4s     85f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.032 [452:64]
  1 duplicate frame(s)!
  Pos:   5.5s     87f ( 4%)  0.00fps Trem:   0min   7mb  A-V:0.003 [453:64]
  1 duplicate frame(s)!
  Pos:   5.6s     88f ( 4%)  0.00fps Trem:   0min   7mb  A-V:-0.001 [452:64]
  1 duplicate frame(s)!
  Pos:   5.6s     89f ( 4%)  0.00fps Trem:   0min   7mb  A-V:-0.008 [450:64]
  1 duplicate frame(s)!
  Pos:   5.7s     90f ( 4%)  0.00fps Trem:   0min   7mb  A-V:-0.001 [449:64]
  1 duplicate frame(s)!
  Pos:   5.8s     91f ( 4%)  0.00fps Trem:   0min   7mb  A-V:-0.002 [448:64]
  1 duplicate frame(s)!
  Pos:   5.8s     92f ( 4%)  0.00fps Trem:   0min   7mb  A-V:-0.009 [446:63]
  1 duplicate frame(s)!
  Pos:   5.9s     93f ( 5%)  0.00fps Trem:   0min   6mb  A-V:-0.004 [445:64]
  1 duplicate frame(s)!
  Pos:   6.0s     94f ( 5%)  0.00fps Trem:   0min   6mb  A-V:-0.009 [444:63]
  1 duplicate frame(s)!
  Pos:   6.0s     95f ( 5%)  0.00fps Trem:   0min   6mb  A-V:-0.015 [442:63]
  1 duplicate frame(s)!
  Pos:   6.1s     96f ( 5%)  0.00fps Trem:   0min   7mb  A-V:-0.012 [449:63]
  1 duplicate frame(s)!
  Pos:   6.2s     97f ( 5%) 96.13fps Trem:   0min   7mb  A-V:-0.013 [446:63]
  1 duplicate frame(s)!
  Pos:   6.2s     98f ( 5%) 96.08fps Trem:   0min   7mb  A-V:-0.009 [444:64]
  1 duplicate frame(s)!
  Pos:   6.3s     99f ( 5%) 96.30fps Trem:   0min   7mb  A-V:-0.011 [442:64]
  1 duplicate frame(s)!
  Pos:   6.4s    100f ( 5%) 96.15fps Trem:   0min   7mb  A-V:-0.017 [445:64]
  1 duplicate frame(s)!
  Pos:   6.4s    101f ( 5%) 96.10fps Trem:   0min   7mb  A-V:-0.014 [442:64]
  1 duplicate frame(s)!
  Pos:   6.5s    102f ( 5%) 96.32fps Trem:   0min   7mb  A-V:-0.015 [441:64]
  1 duplicate frame(s)!
  Pos:   6.6s    103f ( 5%) 96.17fps Trem:   0min   7mb  A-V:-0.009 [439:64]
  1 duplicate frame(s)!
  Pos:   6.6s    104f ( 5%) 96.30fps Trem:   0min   7mb  A-V:-0.007 [441:64]
  1 duplicate frame(s)!
  Pos:   6.7s    105f ( 5%) 96.24fps Trem:   0min   7mb  A-V:-0.014 [440:64]
  1 duplicate frame(s)!
  Pos:   6.8s    106f ( 5%) 96.36fps Trem:   0min   7mb  A-V:-0.007 [439:64]
  1 duplicate frame(s)!
  Pos:   6.8s    107f ( 5%) 96.31fps Trem:   0min   7mb  A-V:-0.007 [437:64]
  1 duplicate frame(s)!
  Pos:   6.9s    108f ( 5%) 96.09fps Trem:   0min   7mb  A-V:-0.014 [437:64]
  1 duplicate frame(s)!
  Pos:   7.0s    109f ( 5%) 95.70fps Trem:   0min   7mb  A-V:-0.020 [436:64]
  1 duplicate frame(s)!
  Pos:   7.0s    110f ( 5%) 86.89fps Trem:   0min   7mb  A-V:-0.017 [436:63]
  1 duplicate frame(s)!
  Pos:   7.1s    111f ( 5%) 87.06fps Trem:   0min   7mb  A-V:-0.018 [434:63]
  1 duplicate frame(s)!
  Pos:   7.2s    112f ( 5%) 87.02fps Trem:   0min   7mb  A-V:-0.024 [436:63]
  1 duplicate frame(s)!
  Pos:   7.2s    113f ( 5%) 87.26fps Trem:   0min   7mb  A-V:-0.017 [435:63]
  1 duplicate frame(s)!
  Pos:   7.3s    114f ( 5%) 87.29fps Trem:   0min   7mb  A-V:-0.016 [434:63]
  1 duplicate frame(s)!
  Pos:   7.4s    115f ( 5%) 87.45fps Trem:   0min   7mb  A-V:-0.019 [433:63]
  1 duplicate frame(s)!
  Pos:   7.4s    116f ( 5%) 87.48fps Trem:   0min   7mb  A-V:-0.012 [433:63]
  1 duplicate frame(s)!
  Pos:   7.5s    117f ( 5%) 87.51fps Trem:   0min   7mb  A-V:-0.015 [432:63]
  1 duplicate frame(s)!
  Pos:   7.6s    118f ( 5%) 87.60fps Trem:   0min   7mb  A-V:-0.022 [431:63]
  1 duplicate frame(s)!
  Pos:   7.6s    119f ( 5%) 87.69fps Trem:   0min   7mb  A-V:-0.029 [429:63]
  1 duplicate frame(s)!
  Pos:   7.7s    120f ( 6%) 87.78fps Trem:   0min   7mb  A-V:-0.022 [431:63]
  1 duplicate frame(s)!
  Pos:   7.8s    121f ( 6%) 87.81fps Trem:   0min   7mb  A-V:-0.021 [430:63]
  1 duplicate frame(s)!
  Pos:   7.8s    122f ( 6%) 87.90fps Trem:   0min   7mb  A-V:-0.024 [430:63]
  1 duplicate frame(s)!
  Pos:   7.9s    123f ( 6%) 87.92fps Trem:   0min   7mb  A-V:-0.030 [428:63]
  1 duplicate frame(s)!
  Pos:   8.0s    124f ( 6%) 87.88fps Trem:   0min   7mb  A-V:-0.024 [427:63]
  1 duplicate frame(s)!
  Pos:   8.0s    125f ( 6%) 87.97fps Trem:   0min   7mb  A-V:-0.020 [427:63]
  1 duplicate frame(s)!
  Pos:   8.1s    126f ( 6%) 87.99fps Trem:   0min   7mb  A-V:-0.025 [427:63]
  1 duplicate frame(s)!
  Pos:   8.2s    127f ( 6%) 88.13fps Trem:   0min   7mb  A-V:-0.032 [426:63]
  1 duplicate frame(s)!
  Pos:   8.2s    128f ( 6%) 88.09fps Trem:   0min   7mb  A-V:-0.026 [425:63]
  1 duplicate frame(s)!
  Pos:   8.3s    129f ( 6%) 88.30fps Trem:   0min   7mb  A-V:-0.026 [425:63]
  1 duplicate frame(s)!
  Pos:   8.4s    130f ( 6%) 88.20fps Trem:   0min   7mb  A-V:-0.032 [457:63]
  1 duplicate frame(s)!
  Pos:   8.4s    131f ( 6%) 88.16fps Trem:   0min   7mb  A-V:-0.029 [459:63]
  1 duplicate frame(s)!
  Pos:   8.5s    132f ( 6%) 88.35fps Trem:   0min   7mb  A-V:-0.022 [457:63]
  1 duplicate frame(s)!
  Pos:   8.6s    133f ( 6%) 88.37fps Trem:   0min   7mb  A-V:-0.023 [456:63]
  1 duplicate frame(s)!
  Pos:   8.6s    134f ( 6%) 88.51fps Trem:   0min   7mb  A-V:-0.016 [457:63]
  1 duplicate frame(s)!
  Pos:   8.7s    135f ( 6%) 88.52fps Trem:   0min   7mb  A-V:-0.018 [457:63]
  1 duplicate frame(s)!
  Pos:   8.8s    136f ( 6%) 88.66fps Trem:   0min   8mb  A-V:-0.023 [457:63]
  1 duplicate frame(s)!
  Pos:   8.8s    137f ( 7%) 88.62fps Trem:   0min   7mb  A-V:-0.018 [458:63]
  1 duplicate frame(s)!
  Pos:   8.9s    138f ( 7%) 88.80fps Trem:   0min   7mb  A-V:-0.017 [458:63]
  1 duplicate frame(s)!
  Pos:   9.0s    139f ( 7%) 88.82fps Trem:   0min   7mb  A-V:-0.024 [458:63]
  1 duplicate frame(s)!
  Pos:   9.0s    140f ( 7%) 88.83fps Trem:   0min   7mb  A-V:-0.018 [457:63]
  1 duplicate frame(s)!
  Pos:   9.1s    141f ( 7%) 88.96fps Trem:   0min   7mb  A-V:-0.016 [457:64]
  1 duplicate frame(s)!
  Pos:   9.2s    142f ( 7%) 88.97fps Trem:   0min   7mb  A-V:-0.023 [458:63]
  1 duplicate frame(s)!
  Pos:   9.2s    143f ( 7%) 89.04fps Trem:   0min   7mb  A-V:-0.016 [458:64]
  1 duplicate frame(s)!
  Pos:   9.3s    144f ( 7%) 89.05fps Trem:   0min   7mb  A-V:-0.018 [457:63]
  1 duplicate frame(s)!
  Pos:   9.4s    145f ( 7%) 89.12fps Trem:   0min   8mb  A-V:-0.011 [458:64]
  1 duplicate frame(s)!
  Pos:   9.4s    146f ( 7%) 89.13fps Trem:   0min   8mb  A-V:-0.011 [458:64]
  1 duplicate frame(s)!
  Pos:   9.5s    147f ( 7%) 89.14fps Trem:   0min   8mb  A-V:-0.018 [457:64]
  1 duplicate frame(s)!
  Pos:   9.6s    148f ( 7%) 89.26fps Trem:   0min   8mb  A-V:-0.025 [456:64]
  1 duplicate frame(s)!
  Pos:   9.6s    149f ( 7%) 89.28fps Trem:   0min   8mb  A-V:-0.021 [455:64]
  1 duplicate frame(s)!
  Pos:   9.7s    150f ( 7%) 89.39fps Trem:   0min   8mb  A-V:-0.021 [454:64]
  1 duplicate frame(s)!
  Pos:   9.8s    151f ( 7%) 89.35fps Trem:   0min   7mb  A-V:-0.015 [454:64]
  1 duplicate frame(s)!
  Pos:   9.8s    152f ( 7%) 89.52fps Trem:   0min   7mb  A-V:-0.011 [454:64]
  1 duplicate frame(s)!
  Pos:   9.9s    153f ( 7%) 89.47fps Trem:   0min   8mb  A-V:-0.004 [454:64]
  1 duplicate frame(s)!
  Pos:  10.0s    154f ( 7%) 89.59fps Trem:   0min   8mb  A-V:-0.000 [454:64]
  1 duplicate frame(s)!
  Pos:  10.0s    155f ( 7%) 89.60fps Trem:   0min   8mb  A-V:-0.005 [454:64]
  1 duplicate frame(s)!
  Pos:  10.1s    156f ( 7%) 89.60fps Trem:   0min   8mb  A-V:-0.012 [454:64]
  1 duplicate frame(s)!
  Pos:  10.2s    157f ( 7%) 89.66fps Trem:   0min   8mb  A-V:-0.005 [454:64]
  1 duplicate frame(s)!
  Pos:  10.2s    158f ( 7%) 89.67fps Trem:   0min   8mb  A-V:-0.007 [455:64]
  1 duplicate frame(s)!
  Pos:  10.3s    159f ( 7%) 89.78fps Trem:   0min   8mb  A-V:-0.012 [455:64]
  1 duplicate frame(s)!
  Pos:  10.4s    160f ( 7%) 89.74fps Trem:   0min   8mb  A-V:-0.010 [454:64]
  1 duplicate frame(s)!
  Pos:  10.4s    161f ( 7%) 89.89fps Trem:   0min   8mb  A-V:-0.011 [455:64]
  1 duplicate frame(s)!
  Pos:  10.5s    162f ( 7%) 89.90fps Trem:   0min   8mb  A-V:-0.018 [455:64]
  1 duplicate frame(s)!
  Pos:  10.6s    163f ( 7%) 89.86fps Trem:   0min   8mb  A-V:-0.012 [455:64]
  1 duplicate frame(s)!
  Pos:  10.6s    164f ( 7%) 90.01fps Trem:   0min   8mb  A-V:-0.010 [455:64]
  1 duplicate frame(s)!
  Pos:  10.7s    165f ( 7%) 89.97fps Trem:   0min   8mb  A-V:-0.005 [454:64]
  1 duplicate frame(s)!
  Pos:  10.8s    166f ( 7%) 90.07fps Trem:   0min   8mb  A-V:-0.004 [454:64]
  1 duplicate frame(s)!
  Pos:  10.8s    167f ( 7%) 90.08fps Trem:   0min   8mb  A-V:-0.011 [454:64]
  1 duplicate frame(s)!
  Pos:  10.9s    168f ( 8%) 90.13fps Trem:   0min   8mb  A-V:-0.004 [453:64]
  1 duplicate frame(s)!
  Pos:  11.0s    169f ( 8%) 90.18fps Trem:   0min   8mb  A-V:-0.005 [453:64]
  1 duplicate frame(s)!
  Pos:  11.0s    170f ( 8%) 90.19fps Trem:   0min   8mb  A-V:-0.011 [453:64]
  1 duplicate frame(s)!
  Pos:  11.1s    171f ( 8%) 90.29fps Trem:   0min   8mb  A-V:-0.018 [452:64]
  1 duplicate frame(s)!
  Pos:  11.2s    172f ( 8%) 90.24fps Trem:   0min   8mb  A-V:-0.016 [452:64]
  1 duplicate frame(s)!
  Pos:  11.2s    173f ( 8%) 90.34fps Trem:   0min   8mb  A-V:-0.018 [452:64]
  1 duplicate frame(s)!
  Pos:  11.3s    174f ( 8%) 90.34fps Trem:   0min   8mb  A-V:-0.011 [452:63]
  1 duplicate frame(s)!
  Pos:  11.4s    175f ( 8%) 90.49fps Trem:   0min   8mb  A-V:-0.008 [452:63]
  1 duplicate frame(s)!
  Pos:  11.4s    176f ( 8%) 90.44fps Trem:   0min   8mb  A-V:-0.001 [452:63]
  1 duplicate frame(s)!
  Pos:  11.5s    177f ( 8%) 90.54fps Trem:   0min   8mb  A-V:0.003 [452:63]
  1 duplicate frame(s)!
  Pos:  11.6s    178f ( 8%) 90.54fps Trem:   0min   8mb  A-V:-0.001 [452:63]
  1 duplicate frame(s)!
  Pos:  11.6s    179f ( 8%) 90.45fps Trem:   0min   8mb  A-V:0.002 [452:63]
  1 duplicate frame(s)!
  Pos:  11.7s    180f ( 8%) 90.59fps Trem:   0min   8mb  A-V:0.001 [452:63]
  1 duplicate frame(s)!
  Pos:  11.8s    181f ( 8%) 90.59fps Trem:   0min   8mb  A-V:-0.005 [452:63]
  1 duplicate frame(s)!
  Pos:  11.8s    182f ( 8%) 90.55fps Trem:   0min   8mb  A-V:0.002 [453:63]
  1 duplicate frame(s)!
  Pos:  11.9s    183f ( 8%) 90.50fps Trem:   0min   8mb  A-V:-0.001 [453:63]
  1 duplicate frame(s)!
  Pos:  12.0s    184f ( 8%) 90.60fps Trem:   0min   8mb  A-V:-0.007 [453:63]
  1 duplicate frame(s)!
  Pos:  12.0s    185f ( 9%) 90.51fps Trem:   0min   8mb  A-V:-0.002 [453:63]
  1 duplicate frame(s)!
  Pos:  12.1s    186f ( 9%) 90.47fps Trem:   0min   8mb  A-V:-0.006 [454:63]
  1 duplicate frame(s)!
  Pos:  12.2s    187f ( 9%) 90.51fps Trem:   0min   8mb  A-V:-0.013 [454:63]
  1 duplicate frame(s)!
  Pos:  12.2s    188f ( 9%) 90.47fps Trem:   0min   8mb  A-V:-0.011 [454:63]
  1 duplicate frame(s)!
  Pos:  12.3s    189f ( 9%) 90.56fps Trem:   0min   8mb  A-V:-0.013 [454:63]
  1 duplicate frame(s)!
  Pos:  12.4s    190f ( 9%) 90.52fps Trem:   0min   8mb  A-V:-0.009 [455:63]
  1 duplicate frame(s)!
  Pos:  12.4s    191f ( 9%) 90.44fps Trem:   0min   8mb  A-V:-0.010 [455:63]
  1 duplicate frame(s)!
  Pos:  12.5s    192f ( 9%) 90.40fps Trem:   0min   8mb  A-V:-0.003 [454:63]
  1 duplicate frame(s)!
  Pos:  12.6s    193f ( 9%) 90.48fps Trem:   0min   8mb  A-V:0.002 [455:63]
  1 duplicate frame(s)!
  Pos:  12.6s    194f ( 9%) 90.44fps Trem:   0min   8mb  A-V:-0.003 [455:63]
  1 duplicate frame(s)!
  Pos:  12.7s    195f ( 9%) 90.45fps Trem:   0min   8mb  A-V:-0.009 [454:63]
  1 duplicate frame(s)!
  Pos:  12.8s    196f ( 9%) 90.45fps Trem:   0min   8mb  A-V:-0.003 [455:63]
  1 duplicate frame(s)!
  Pos:  12.8s    197f ( 9%) 90.37fps Trem:   0min   8mb  A-V:-0.005 [455:63]
  1 duplicate frame(s)!
  Pos:  12.9s    198f ( 9%) 90.41fps Trem:   0min   8mb  A-V:-0.012 [456:63]
  1 duplicate frame(s)!
  Pos:  13.0s    199f ( 9%) 90.37fps Trem:   0min   8mb  A-V:-0.008 [456:63]
  1 duplicate frame(s)!
  Pos:  13.0s    200f ( 9%) 90.42fps Trem:   0min   8mb  A-V:-0.009 [456:63]
  1 duplicate frame(s)!
  Pos:  13.1s    201f ( 9%) 90.38fps Trem:   0min   8mb  A-V:-0.015 [456:63]
  1 duplicate frame(s)!
  Pos:  13.2s    202f ( 9%) 90.30fps Trem:   0min   8mb  A-V:-0.011 [456:63]
  1 duplicate frame(s)!
  Pos:  13.2s    203f ( 9%) 90.34fps Trem:   0min   8mb  A-V:-0.011 [456:63]
  1 duplicate frame(s)!
  Pos:  13.3s    204f ( 9%) 90.31fps Trem:   0min   8mb  A-V:-0.017 [456:63]
  1 duplicate frame(s)!
  Pos:  13.4s    205f ( 9%) 90.35fps Trem:   0min   8mb  A-V:-0.011 [456:63]
  1 duplicate frame(s)!
  Pos:  13.4s    206f ( 9%) 90.31fps Trem:   0min   8mb  A-V:-0.012 [456:63]
  1 duplicate frame(s)!
  Pos:  13.5s    207f ( 9%) 90.35fps Trem:   0min   8mb  A-V:-0.005 [455:63]
  1 duplicate frame(s)!
  Pos:  13.6s    208f ( 9%) 90.32fps Trem:   0min   8mb  A-V:-0.007 [456:63]
  1 duplicate frame(s)!
  Pos:  13.6s    209f (10%) 90.28fps Trem:   0min   8mb  A-V:-0.002 [456:63]
  1 duplicate frame(s)!
  Pos:  13.7s    210f (10%) 90.32fps Trem:   0min   8mb  A-V:-0.001 [456:63]
  1 duplicate frame(s)!
  Pos:  13.8s    211f (10%) 90.29fps Trem:   0min   8mb  A-V:0.004 [457:63]
  1 duplicate frame(s)!
  Pos:  13.8s    212f (10%) 90.33fps Trem:   0min   8mb  A-V:0.005 [457:64]
  1 duplicate frame(s)!
  Pos:  13.9s    213f (10%) 90.33fps Trem:   0min   8mb  A-V:-0.001 [457:64]
  1 duplicate frame(s)!
  Pos:  14.0s    214f (10%) 90.37fps Trem:   0min   8mb  A-V:-0.008 [457:64]
  1 duplicate frame(s)!
  Pos:  14.0s    215f (10%) 90.26fps Trem:   0min   8mb  A-V:-0.005 [457:64]
  1 duplicate frame(s)!
  Pos:  14.1s    216f (10%) 90.34fps Trem:   0min   8mb  A-V:-0.006 [457:63]
  1 duplicate frame(s)!
  Pos:  14.2s    217f (10%) 90.34fps Trem:   0min   8mb  A-V:-0.012 [456:63]
  1 duplicate frame(s)!
  Pos:  14.2s    218f (10%) 90.23fps Trem:   0min   8mb  A-V:-0.011 [456:63]
  1 duplicate frame(s)!
  Pos:  14.3s    219f (10%) 90.31fps Trem:   0min   8mb  A-V:-0.014 [457:63]
  1 duplicate frame(s)!
  Pos:  14.4s    220f (10%) 90.27fps Trem:   0min   8mb  A-V:-0.008 [456:63]
  1 duplicate frame(s)!
  Pos:  14.4s    221f (10%) 90.28fps Trem:   0min   8mb  A-V:-0.005 [456:63]
  1 duplicate frame(s)!
  Pos:  14.5s    222f (10%) 90.24fps Trem:   0min   8mb  A-V:0.001 [456:63]
  1 duplicate frame(s)!
  Pos:  14.6s    223f (10%) 90.32fps Trem:   0min   8mb  A-V:0.002 [455:63]
  1 duplicate frame(s)!
  Pos:  14.6s    224f (10%) 90.29fps Trem:   0min   8mb  A-V:-0.004 [455:63]
  1 duplicate frame(s)!
  Pos:  14.7s    225f (10%) 90.29fps Trem:   0min   8mb  A-V:-0.011 [455:64]
  1 duplicate frame(s)!
  Pos:  14.8s    226f (10%) 90.36fps Trem:   0min   8mb  A-V:-0.005 [455:64]
  1 duplicate frame(s)!
  Pos:  14.8s    227f (10%) 90.33fps Trem:   0min   8mb  A-V:-0.009 [455:64]
  1 duplicate frame(s)!
  Pos:  14.9s    228f (10%) 90.37fps Trem:   0min   8mb  A-V:-0.003 [455:64]
  1 duplicate frame(s)!
  Pos:  15.0s    229f (10%) 90.37fps Trem:   0min   8mb  A-V:-0.005 [455:64]
  1 duplicate frame(s)!
  Pos:  15.0s    230f (10%) 90.44fps Trem:   0min   8mb  A-V:-0.012 [454:64]
  1 duplicate frame(s)!
  Pos:  15.1s    231f (10%) 90.41fps Trem:   0min   8mb  A-V:-0.008 [454:64]
  1 duplicate frame(s)!
  Pos:  15.2s    232f (10%) 90.48fps Trem:   0min   8mb  A-V:-0.009 [454:64]
  1 duplicate frame(s)!
  Pos:  15.2s    233f (10%) 90.49fps Trem:   0min   8mb  A-V:-0.015 [454:64]
  1 duplicate frame(s)!
  Pos:  15.3s    234f (10%) 90.45fps Trem:   0min   8mb  A-V:-0.014 [453:64]
  1 duplicate frame(s)!
  Pos:  15.4s    235f (10%) 90.52fps Trem:   0min   8mb  A-V:-0.017 [453:64]
  1 duplicate frame(s)!
  Pos:  15.4s    236f (10%) 90.56fps Trem:   0min   8mb  A-V:-0.023 [453:64]
  1 duplicate frame(s)!
  Pos:  15.5s    237f (10%) 90.63fps Trem:   0min   8mb  A-V:-0.030 [452:64]
  1 duplicate frame(s)!
  Pos:  15.6s    238f (11%) 90.60fps Trem:   0min   8mb  A-V:-0.026 [452:64]
  1 duplicate frame(s)!
  Pos:  15.6s    239f (11%) 90.67fps Trem:   0min   8mb  A-V:-0.026 [452:64]
  1 duplicate frame(s)!
  Pos:  15.7s    240f (11%) 90.63fps Trem:   0min   8mb  A-V:-0.033 [452:64]
  1 duplicate frame(s)!
  Pos:  15.8s    241f (11%) 90.64fps Trem:   0min   8mb  A-V:-0.030 [451:64]
  1 duplicate frame(s)!
  Pos:  15.8s    242f (11%) 90.60fps Trem:   0min   8mb  A-V:-0.032 [452:64]
  1 duplicate frame(s)!
  Pos:  15.9s    243f (11%) 90.57fps Trem:   0min   8mb  A-V:-0.025 [452:64]
  1 duplicate frame(s)!
  Pos:  16.0s    244f (11%) 90.64fps Trem:   0min   8mb  A-V:-0.021 [452:64]
  1 duplicate frame(s)!
  Pos:  16.0s    245f (11%) 90.64fps Trem:   0min   8mb  A-V:-0.025 [451:64]
  1 duplicate frame(s)!
  Pos:  16.1s    246f (11%) 90.64fps Trem:   0min   8mb  A-V:-0.018 [450:64]
  1 duplicate frame(s)!
  Pos:  16.2s    247f (11%) 90.64fps Trem:   0min   8mb  A-V:-0.019 [449:64]
  1 duplicate frame(s)!
  Pos:  16.2s    248f (11%) 90.68fps Trem:   0min   8mb  A-V:-0.026 [449:64]
  1 duplicate frame(s)!
  Pos:  16.3s    249f (11%) 90.74fps Trem:   0min   8mb  A-V:-0.033 [448:64]
  1 duplicate frame(s)!
  Pos:  16.4s    250f (11%) 90.74fps Trem:   0min   8mb  A-V:-0.030 [447:64]
  1 duplicate frame(s)!
  Pos:  16.4s    251f (11%) 90.81fps Trem:   0min   8mb  A-V:-0.033 [447:64]
  1 duplicate frame(s)!
  Pos:  16.5s    252f (11%) 90.81fps Trem:   0min   8mb  A-V:-0.028 [446:64]
  1 duplicate frame(s)!
  Pos:  16.6s    253f (11%) 90.81fps Trem:   0min   8mb  A-V:-0.028 [446:64]
  1 duplicate frame(s)!
  Pos:  16.6s    254f (11%) 90.78fps Trem:   0min   8mb  A-V:-0.022 [445:64]
  1 duplicate frame(s)!
  Pos:  16.7s    255f (11%) 90.81fps Trem:   0min   9mb  A-V:-0.018 [462:64]
  1 duplicate frame(s)!
  Pos:  16.8s    256f (11%) 90.84fps Trem:   0min   9mb  A-V:-0.023 [461:64]
  1 duplicate frame(s)!
  Pos:  16.9s    257f (11%) 90.84fps Trem:   0min   9mb  A-V:-0.030 [460:64]
  1 duplicate frame(s)!
  Pos:  16.9s    258f (11%) 90.94fps Trem:   0min   9mb  A-V:-0.023 [459:64]
  1 duplicate frame(s)!
  Pos:  17.0s    259f (11%) 90.91fps Trem:   0min   9mb  A-V:-0.024 [459:63]
  1 duplicate frame(s)!
  Pos:  17.1s    260f (11%) 91.00fps Trem:   0min   9mb  A-V:-0.017 [458:63]
  1 duplicate frame(s)!
  Pos:  17.1s    261f (11%) 91.00fps Trem:   0min   9mb  A-V:-0.018 [457:64]
  1 duplicate frame(s)!
  Pos:  17.2s    262f (11%) 91.10fps Trem:   0min   9mb  A-V:-0.022 [456:64]
  1 duplicate frame(s)!
  Pos:  17.3s    263f (11%) 91.07fps Trem:   0min   9mb  A-V:-0.018 [456:64]
  1 duplicate frame(s)!
  Pos:  17.3s    264f (11%) 91.10fps Trem:   0min   9mb  A-V:-0.023 [456:64]
  1 duplicate frame(s)!
  Pos:  17.4s    265f (11%) 91.16fps Trem:   0min   9mb  A-V:-0.030 [456:64]
  1 duplicate frame(s)!
  Pos:  17.5s    266f (12%) 91.16fps Trem:   0min   8mb  A-V:-0.026 [456:63]
  1 duplicate frame(s)!
  Pos:  17.5s    267f (12%) 91.25fps Trem:   0min   8mb  A-V:-0.027 [456:63]
  1 duplicate frame(s)!
  Pos:  17.6s    268f (12%) 91.22fps Trem:   0min   9mb  A-V:-0.033 [455:63]
  1 duplicate frame(s)!
  Pos:  17.7s    269f (12%) 91.28fps Trem:   0min   9mb  A-V:-0.027 [455:63]
  1 duplicate frame(s)!
  Pos:  17.7s    270f (12%) 91.31fps Trem:   0min   9mb  A-V:-0.027 [455:63]
  1 duplicate frame(s)!
  Pos:  17.8s    271f (12%) 91.34fps Trem:   0min   8mb  A-V:-0.021 [454:63]
  1 duplicate frame(s)!
  Pos:  17.9s    272f (12%) 91.37fps Trem:   0min   8mb  A-V:-0.021 [454:63]
  1 duplicate frame(s)!
  Pos:  17.9s    273f (12%) 91.37fps Trem:   0min   8mb  A-V:-0.027 [453:63]
  1 duplicate frame(s)!
  Pos:  18.0s    274f (12%) 91.46fps Trem:   0min   8mb  A-V:-0.034 [453:63]
  1 duplicate frame(s)!
  Pos:  18.1s    275f (12%) 91.45fps Trem:   0min   8mb  A-V:-0.027 [452:63]
  1 duplicate frame(s)!
  Pos:  18.1s    276f (12%) 91.54fps Trem:   0min   8mb  A-V:-0.022 [452:63]
  1 duplicate frame(s)!
  Pos:  18.2s    277f (12%) 91.51fps Trem:   0min   8mb  A-V:-0.016 [452:63]
  1 duplicate frame(s)!
  Pos:  18.3s    278f (12%) 91.57fps Trem:   0min   8mb  A-V:-0.013 [452:63]
  1 duplicate frame(s)!
  Pos:  18.3s    279f (12%) 91.57fps Trem:   0min   8mb  A-V:-0.006 [451:63]
  1 duplicate frame(s)!
  Pos:  18.4s    280f (12%) 91.56fps Trem:   0min   8mb  A-V:-0.006 [451:63]
  1 duplicate frame(s)!
  Pos:  18.5s    281f (12%) 91.65fps Trem:   0min   8mb  A-V:-0.009 [450:63]
  1 duplicate frame(s)!
  Pos:  18.5s    282f (12%) 91.65fps Trem:   0min   8mb  A-V:-0.016 [450:63]
  1 duplicate frame(s)!
  Pos:  18.6s    283f (12%) 91.67fps Trem:   0min   8mb  A-V:-0.010 [449:63]
  1 duplicate frame(s)!
  Pos:  18.7s    284f (12%) 91.70fps Trem:   0min   8mb  A-V:-0.011 [449:63]
  1 duplicate frame(s)!
  Pos:  18.7s    285f (12%) 91.76fps Trem:   0min   8mb  A-V:-0.017 [449:63]
  1 duplicate frame(s)!
  Pos:  18.8s    286f (12%) 91.75fps Trem:   0min   8mb  A-V:-0.012 [448:63]
  1 duplicate frame(s)!
  Pos:  18.9s    287f (12%) 91.75fps Trem:   0min   8mb  A-V:-0.017 [447:63]
  1 duplicate frame(s)!
  Pos:  18.9s    288f (12%) 91.84fps Trem:   0min   8mb  A-V:-0.024 [446:63]
  1 duplicate frame(s)!
  Pos:  19.0s    289f (12%) 91.80fps Trem:   0min   8mb  A-V:-0.018 [446:63]
  1 duplicate frame(s)!
  Pos:  19.1s    290f (12%) 91.89fps Trem:   0min   9mb  A-V:-0.017 [445:63]
  1 duplicate frame(s)!
  Pos:  19.1s    291f (12%) 91.89fps Trem:   0min   9mb  A-V:-0.024 [444:63]
  1 duplicate frame(s)!
  Pos:  19.2s    292f (13%) 91.94fps Trem:   0min   8mb  A-V:-0.017 [444:63]
  1 duplicate frame(s)!
  Pos:  19.3s    293f (13%) 91.96fps Trem:   0min   8mb  A-V:-0.018 [443:63]
  1 duplicate frame(s)!
  Pos:  19.3s    294f (13%) 92.02fps Trem:   0min   8mb  A-V:-0.011 [443:63]
  1 duplicate frame(s)!
  Pos:  19.4s    295f (13%) 92.01fps Trem:   0min   8mb  A-V:-0.011 [442:63]
  1 duplicate frame(s)!
  Pos:  19.5s    296f (13%) 92.01fps Trem:   0min   8mb  A-V:-0.017 [442:63]
  1 duplicate frame(s)!
  Pos:  19.5s    297f (13%) 92.06fps Trem:   0min   8mb  A-V:-0.011 [442:63]
  1 duplicate frame(s)!
  Pos:  19.6s    298f (13%) 92.06fps Trem:   0min   8mb  A-V:-0.014 [441:63]
  1 duplicate frame(s)!
  Pos:  19.7s    299f (13%) 92.14fps Trem:   0min   8mb  A-V:-0.007 [441:63]
  1 duplicate frame(s)!
  Pos:  19.7s    300f (13%) 92.14fps Trem:   0min   8mb  A-V:-0.009 [441:63]
  1 duplicate frame(s)!
  Pos:  19.8s    301f (13%) 92.19fps Trem:   0min   8mb  A-V:-0.002 [441:63]
  1 duplicate frame(s)!
  Pos:  19.9s    302f (13%) 92.13fps Trem:   0min   8mb  A-V:-0.003 [441:63]
  1 duplicate frame(s)!
  Pos:  19.9s    303f (13%) 92.10fps Trem:   0min   8mb  A-V:-0.010 [440:64]
  1 duplicate frame(s)!
  Pos:  20.0s    304f (13%) 92.12fps Trem:   0min   8mb  A-V:-0.005 [439:64]
  1 duplicate frame(s)!
  Pos:  20.1s    305f (13%) 92.15fps Trem:   0min   8mb  A-V:-0.009 [439:64]
  1 duplicate frame(s)!
  Pos:  20.1s    306f (13%) 92.20fps Trem:   0min   8mb  A-V:-0.015 [439:64]
  1 duplicate frame(s)!
  Pos:  20.2s    307f (13%) 92.16fps Trem:   0min   8mb  A-V:-0.009 [438:64]
  1 duplicate frame(s)!
  Pos:  20.3s    308f (13%) 92.22fps Trem:   0min   8mb  A-V:-0.005 [438:64]
  1 duplicate frame(s)!
  Pos:  20.3s    309f (13%) 92.24fps Trem:   0min   8mb  A-V:-0.011 [438:64]
  1 duplicate frame(s)!
  Pos:  20.4s    310f (13%) 92.29fps Trem:   0min   8mb  A-V:-0.004 [437:64]
  1 duplicate frame(s)!
  Pos:  20.5s    311f (13%) 92.26fps Trem:   0min   8mb  A-V:-0.006 [436:64]
  1 duplicate frame(s)!
  Pos:  20.5s    312f (13%) 92.25fps Trem:   0min   8mb  A-V:-0.013 [436:64]
  1 duplicate frame(s)!
  Pos:  20.6s    313f (14%) 92.28fps Trem:   0min   8mb  A-V:-0.008 [436:64]
  1 duplicate frame(s)!
  Pos:  20.7s    314f (14%) 92.27fps Trem:   0min   8mb  A-V:-0.012 [435:64]
  1 duplicate frame(s)!
  Pos:  20.7s    315f (14%) 92.32fps Trem:   0min   8mb  A-V:-0.019 [435:64]
  1 duplicate frame(s)!
  Pos:  20.8s    316f (14%) 92.26fps Trem:   0min   8mb  A-V:-0.016 [435:64]
  1 duplicate frame(s)!
  Pos:  20.9s    317f (14%) 92.29fps Trem:   0min   8mb  A-V:-0.018 [435:64]
  1 duplicate frame(s)!
  Pos:  20.9s    318f (14%) 92.28fps Trem:   0min   8mb  A-V:-0.025 [435:64]
  1 duplicate frame(s)!
  Pos:  21.0s    319f (14%) 92.25fps Trem:   0min   8mb  A-V:-0.018 [435:64]
  1 duplicate frame(s)!
  Pos:  21.1s    320f (14%) 92.30fps Trem:   0min   8mb  A-V:-0.016 [435:64]
  1 duplicate frame(s)!
  Pos:  21.1s    321f (14%) 92.29fps Trem:   0min   8mb  A-V:-0.023 [435:64]
  1 duplicate frame(s)!
  Pos:  21.2s    322f (14%) 92.32fps Trem:   0min   8mb  A-V:-0.016 [435:64]
  1 duplicate frame(s)!
  Pos:  21.3s    323f (14%) 92.31fps Trem:   0min   8mb  A-V:-0.017 [435:64]
  1 duplicate frame(s)!
  Pos:  21.3s    324f (14%) 92.33fps Trem:   0min   8mb  A-V:-0.010 [435:64]
  1 duplicate frame(s)!
  Pos:  21.4s    325f (14%) 92.33fps Trem:   0min   8mb  A-V:-0.011 [435:64]
  1 duplicate frame(s)!
  Pos:  21.5s    326f (14%) 92.30fps Trem:   0min   8mb  A-V:-0.018 [435:64]
  1 duplicate frame(s)!
  Pos:  21.5s    327f (14%) 92.35fps Trem:   0min   8mb  A-V:-0.024 [435:64]
  1 duplicate frame(s)!
  Pos:  21.6s    328f (14%) 92.32fps Trem:   0min   8mb  A-V:-0.022 [435:64]
  1 duplicate frame(s)!
  Pos:  21.7s    329f (14%) 92.36fps Trem:   0min   8mb  A-V:-0.025 [435:64]
  1 duplicate frame(s)!
  Pos:  21.7s    330f (14%) 92.36fps Trem:   0min   8mb  A-V:-0.018 [435:64]
  1 duplicate frame(s)!
  Pos:  21.8s    331f (14%) 92.41fps Trem:   0min   8mb  A-V:-0.015 [435:64]
  1 duplicate frame(s)!
  Pos:  21.9s    332f (14%) 92.38fps Trem:   0min   8mb  A-V:-0.020 [435:63]
  1 duplicate frame(s)!
  Pos:  21.9s    333f (14%) 92.40fps Trem:   0min   8mb  A-V:-0.014 [435:63]
  1 duplicate frame(s)!
  Pos:  22.0s    334f (14%) 92.39fps Trem:   0min   8mb  A-V:-0.015 [435:64]
  1 duplicate frame(s)!
  Pos:  22.1s    335f (14%) 92.39fps Trem:   0min   8mb  A-V:-0.022 [436:63]
  1 duplicate frame(s)!
  Pos:  22.1s    336f (15%) 92.43fps Trem:   0min   8mb  A-V:-0.015 [436:63]
  1 duplicate frame(s)!
  Pos:  22.2s    337f (15%) 92.38fps Trem:   0min   8mb  A-V:-0.018 [436:63]
  1 duplicate frame(s)!
  Pos:  22.3s    338f (15%) 92.43fps Trem:   0min   8mb  A-V:-0.011 [436:63]
  1 duplicate frame(s)!
  Pos:  22.3s    339f (15%) 92.42fps Trem:   0min   8mb  A-V:-0.013 [435:63]
  1 duplicate frame(s)!
  Pos:  22.4s    340f (15%) 92.47fps Trem:   0min   8mb  A-V:-0.019 [435:63]
  1 duplicate frame(s)!
  Pos:  22.5s    341f (15%) 92.44fps Trem:   0min   8mb  A-V:-0.012 [435:64]
  1 duplicate frame(s)!
  Pos:  22.5s    342f (15%) 92.43fps Trem:   0min   8mb  A-V:-0.013 [435:63]
  1 duplicate frame(s)!
  Pos:  22.6s    343f (15%) 92.48fps Trem:   0min   8mb  A-V:-0.019 [435:63]
  1 duplicate frame(s)!
  Pos:  22.7s    344f (15%) 92.45fps Trem:   0min   8mb  A-V:-0.025 [435:63]
  1 duplicate frame(s)!
  Pos:  22.7s    345f (15%) 92.47fps Trem:   0min   8mb  A-V:-0.019 [435:63]
  1 duplicate frame(s)!
  Pos:  22.8s    346f (15%) 92.46fps Trem:   0min   8mb  A-V:-0.022 [435:63]
  1 duplicate frame(s)!
  Pos:  22.9s    347f (15%) 92.51fps Trem:   0min   8mb  A-V:-0.028 [435:63]
  1 duplicate frame(s)!
  Pos:  22.9s    348f (15%) 92.50fps Trem:   0min   8mb  A-V:-0.022 [435:63]
  1 duplicate frame(s)!
  Pos:  23.0s    349f (15%) 92.55fps Trem:   0min   8mb  A-V:-0.017 [435:63]
  1 duplicate frame(s)!
  Pos:  23.1s    350f (15%) 92.54fps Trem:   0min   8mb  A-V:-0.021 [435:63]
  1 duplicate frame(s)!
  Pos:  23.1s    351f (15%) 92.51fps Trem:   0min   8mb  A-V:-0.015 [436:63]
  1 duplicate frame(s)!
  Pos:  23.2s    352f (15%) 92.56fps Trem:   0min   8mb  A-V:-0.014 [436:63]
  1 duplicate frame(s)!
  Pos:  23.3s    353f (15%) 92.53fps Trem:   0min   8mb  A-V:-0.008 [436:63]
  1 duplicate frame(s)!
  Pos:  23.3s    354f (15%) 92.57fps Trem:   0min   8mb  A-V:-0.008 [436:63]
  1 duplicate frame(s)!
  Pos:  23.4s    355f (15%) 92.57fps Trem:   0min   8mb  A-V:-0.014 [436:63]
  1 duplicate frame(s)!
  Pos:  23.5s    356f (15%) 92.64fps Trem:   0min   8mb  A-V:-0.021 [435:63]
  1 duplicate frame(s)!
  Pos:  23.5s    357f (15%) 92.61fps Trem:   0min   8mb  A-V:-0.015 [435:63]
  1 duplicate frame(s)!
  Pos:  23.6s    358f (15%) 92.58fps Trem:   0min   8mb  A-V:-0.018 [435:63]
  1 duplicate frame(s)!
  Pos:  23.7s    359f (15%) 92.60fps Trem:   0min   8mb  A-V:-0.012 [435:63]
  1 duplicate frame(s)!
  Pos:  23.7s    360f (15%) 92.59fps Trem:   0min   8mb  A-V:-0.015 [435:63]
  1 duplicate frame(s)!
  Pos:  23.8s    361f (15%) 92.64fps Trem:   0min   8mb  A-V:-0.021 [435:63]
  1 duplicate frame(s)!
  Pos:  23.9s    362f (15%) 92.61fps Trem:   0min   8mb  A-V:-0.014 [436:63]
  1 duplicate frame(s)!
  Pos:  23.9s    363f (15%) 92.65fps Trem:   0min   8mb  A-V:-0.011 [436:63]
  1 duplicate frame(s)!
  Pos:  24.0s    364f (16%) 92.62fps Trem:   0min   8mb  A-V:-0.005 [436:63]
  1 duplicate frame(s)!
  Pos:  24.1s    365f (16%) 92.66fps Trem:   0min   8mb  A-V:-0.001 [436:63]
  1 duplicate frame(s)!
  Pos:  24.1s    366f (16%) 92.66fps Trem:   0min   8mb  A-V:-0.006 [436:63]
  1 duplicate frame(s)!
  Pos:  24.2s    367f (16%) 92.65fps Trem:   0min   8mb  A-V:-0.013 [436:63]
  1 duplicate frame(s)!
  Pos:  24.3s    368f (16%) 92.70fps Trem:   0min   8mb  A-V:-0.020 [436:63]
  1 duplicate frame(s)!
  Pos:  24.3s    369f (16%) 92.67fps Trem:   0min   8mb  A-V:-0.017 [436:63]
  1 duplicate frame(s)!
  Pos:  24.4s    370f (16%) 92.71fps Trem:   0min   8mb  A-V:-0.019 [436:63]
  1 duplicate frame(s)!
  Pos:  24.5s    371f (16%) 92.68fps Trem:   0min   8mb  A-V:-0.025 [437:63]
  1 duplicate frame(s)!
  Pos:  24.5s    372f (16%) 92.72fps Trem:   0min   8mb  A-V:-0.019 [437:63]
  1 duplicate frame(s)!
  Pos:  24.6s    373f (16%) 92.72fps Trem:   0min   8mb  A-V:-0.018 [436:63]
  1 duplicate frame(s)!
  Pos:  24.7s    374f (16%) 92.69fps Trem:   0min   8mb  A-V:-0.011 [436:63]
  1 duplicate frame(s)!
  Pos:  24.7s    375f (16%) 92.75fps Trem:   0min   8mb  A-V:-0.010 [436:63]
  1 duplicate frame(s)!
  Pos:  24.8s    376f (16%) 92.75fps Trem:   0min   8mb  A-V:-0.016 [437:63]
  1 duplicate frame(s)!
  Pos:  24.9s    377f (16%) 92.79fps Trem:   0min   8mb  A-V:-0.023 [437:63]
  1 duplicate frame(s)!
  Pos:  24.9s    378f (16%) 92.74fps Trem:   0min   8mb  A-V:-0.019 [437:63]
  1 duplicate frame(s)!
  Pos:  25.0s    379f (16%) 92.80fps Trem:   0min   8mb  A-V:-0.019 [436:63]
  1 duplicate frame(s)!
  Pos:  25.1s    380f (16%) 92.75fps Trem:   0min   9mb  A-V:-0.012 [448:63]
  1 duplicate frame(s)!
  Pos:  25.1s    381f (16%) 92.72fps Trem:   0min   9mb  A-V:-0.012 [448:63]
  1 duplicate frame(s)!
  Pos:  25.2s    382f (16%) 92.79fps Trem:   0min   9mb  A-V:-0.016 [447:63]
  1 duplicate frame(s)!
  Pos:  25.3s    383f (16%) 92.78fps Trem:   0min   9mb  A-V:-0.014 [447:63]
  1 duplicate frame(s)!
  Pos:  25.3s    384f (16%) 92.82fps Trem:   0min   9mb  A-V:-0.016 [447:63]
  1 duplicate frame(s)!
  Pos:  25.4s    385f (16%) 92.79fps Trem:   0min   9mb  A-V:-0.023 [447:64]
  1 duplicate frame(s)!
  Pos:  25.5s    386f (17%) 92.83fps Trem:   0min   9mb  A-V:-0.016 [448:64]
  1 duplicate frame(s)!
  Pos:  25.5s    387f (17%) 92.83fps Trem:   0min   9mb  A-V:-0.017 [448:64]
  1 duplicate frame(s)!
  Pos:  25.6s    388f (17%) 92.87fps Trem:   0min   9mb  A-V:-0.022 [448:64]
  1 duplicate frame(s)!
  Pos:  25.7s    389f (17%) 92.84fps Trem:   0min   9mb  A-V:-0.016 [448:64]
  1 duplicate frame(s)!
  Pos:  25.7s    390f (17%) 92.86fps Trem:   0min   9mb  A-V:-0.019 [448:64]
  1 duplicate frame(s)!
  Pos:  25.8s    391f (17%) 92.90fps Trem:   0min   9mb  A-V:-0.025 [448:64]
  1 duplicate frame(s)!
  Pos:  25.9s    392f (17%) 92.87fps Trem:   0min   9mb  A-V:-0.021 [448:64]
  1 duplicate frame(s)!
  Pos:  25.9s    393f (17%) 92.91fps Trem:   0min   9mb  A-V:-0.022 [448:64]
  1 duplicate frame(s)!
  Pos:  26.0s    394f (17%) 92.90fps Trem:   0min   9mb  A-V:-0.016 [448:64]
  1 duplicate frame(s)!
  Pos:  26.1s    395f (17%) 92.94fps Trem:   0min   9mb  A-V:-0.013 [448:64]
  1 duplicate frame(s)!
  Pos:  26.1s    396f (17%) 92.94fps Trem:   0min   9mb  A-V:-0.007 [448:64]
  1 duplicate frame(s)!
  Pos:  26.2s    397f (17%) 92.93fps Trem:   0min   9mb  A-V:-0.007 [448:64]
  1 duplicate frame(s)!
  Pos:  26.3s    398f (17%) 92.99fps Trem:   0min   9mb  A-V:-0.012 [448:64]
  1 duplicate frame(s)!
  Pos:  26.3s    399f (17%) 92.96fps Trem:   0min   9mb  A-V:-0.011 [448:64]
  1 duplicate frame(s)!
  Pos:  26.4s    400f (17%) 93.00fps Trem:   0min   9mb  A-V:-0.014 [448:64]
  1 duplicate frame(s)!
  Pos:  26.5s    401f (17%) 92.97fps Trem:   0min   9mb  A-V:-0.008 [448:64]
  1 duplicate frame(s)!
  Pos:  26.5s    402f (17%) 93.03fps Trem:   0min   9mb  A-V:-0.007 [448:64]
  1 duplicate frame(s)!
  Pos:  26.6s    403f (17%) 93.03fps Trem:   0min   9mb  A-V:-0.014 [449:64]
  1 duplicate frame(s)!
  Pos:  26.7s    404f (17%) 93.07fps Trem:   0min   9mb  A-V:-0.007 [449:64]
  1 duplicate frame(s)!
  Pos:  26.7s    405f (17%) 93.04fps Trem:   0min   9mb  A-V:-0.000 [449:64]
  1 duplicate frame(s)!
  Pos:  26.8s    406f (17%) 93.03fps Trem:   0min   9mb  A-V:-0.000 [449:64]
  1 duplicate frame(s)!
  Pos:  26.9s    407f (17%) 93.09fps Trem:   0min   9mb  A-V:-0.004 [449:64]
  1 duplicate frame(s)!
  Pos:  26.9s    408f (17%) 93.09fps Trem:   0min   9mb  A-V:-0.011 [448:64]
  1 duplicate frame(s)!
  Pos:  27.0s    409f (17%) 93.12fps Trem:   0min   9mb  A-V:-0.004 [448:64]
  1 duplicate frame(s)!
  Pos:  27.1s    410f (17%) 93.12fps Trem:   0min   9mb  A-V:-0.007 [448:64]
  1 duplicate frame(s)!
  Pos:  27.1s    411f (17%) 93.16fps Trem:   0min   9mb  A-V:-0.013 [448:64]
  1 duplicate frame(s)!
  Pos:  27.2s    412f (17%) 93.13fps Trem:   0min   9mb  A-V:-0.009 [448:64]
  1 duplicate frame(s)!
  Pos:  27.3s    413f (17%) 93.10fps Trem:   0min   9mb  A-V:-0.014 [448:64]
  1 duplicate frame(s)!
  Pos:  27.3s    414f (17%) 93.16fps Trem:   0min   9mb  A-V:-0.009 [448:64]
  1 duplicate frame(s)!
  Pos:  27.4s    415f (17%) 93.15fps Trem:   0min   9mb  A-V:-0.013 [448:64]
  1 duplicate frame(s)!
  Pos:  27.5s    416f (18%) 93.17fps Trem:   0min   9mb  A-V:-0.006 [448:64]
  1 duplicate frame(s)!
  Pos:  27.5s    417f (18%) 93.18fps Trem:   0min   9mb  A-V:-0.008 [448:64]
  1 duplicate frame(s)!
  Pos:  27.6s    418f (18%) 93.22fps Trem:   0min   9mb  A-V:-0.015 [447:64]
  1 duplicate frame(s)!
  Pos:  27.7s    419f (18%) 93.21fps Trem:   0min   9mb  A-V:-0.021 [447:64]
  1 duplicate frame(s)!
  Pos:  27.7s    420f (18%) 93.21fps Trem:   0min   9mb  A-V:-0.016 [447:64]
  1 duplicate frame(s)!
  Pos:  27.8s    421f (18%) 93.27fps Trem:   0min   9mb  A-V:-0.015 [447:64]
  1 duplicate frame(s)!
  Pos:  27.9s    422f (18%) 93.24fps Trem:   0min   9mb  A-V:-0.021 [448:64]
  1 duplicate frame(s)!
  Pos:  27.9s    423f (18%) 93.25fps Trem:   0min   9mb  A-V:-0.015 [447:64]
  1 duplicate frame(s)!
  Pos:  28.0s    424f (18%) 93.27fps Trem:   0min   9mb  A-V:-0.016 [447:64]
  1 duplicate frame(s)!
  Pos:  28.1s    425f (18%) 93.32fps Trem:   0min   9mb  A-V:-0.022 [447:64]
  1 duplicate frame(s)!
  Pos:  28.1s    426f (18%) 93.32fps Trem:   0min   9mb  A-V:-0.019 [447:64]
  1 duplicate frame(s)!
  Pos:  28.2s    427f (18%) 93.37fps Trem:   0min   9mb  A-V:-0.021 [447:63]
  1 duplicate frame(s)!
  Pos:  28.3s    428f (18%) 93.37fps Trem:   0min   9mb  A-V:-0.016 [447:63]
  1 duplicate frame(s)!
  Pos:  28.3s    429f (18%) 93.38fps Trem:   0min   9mb  A-V:-0.020 [447:63]
  1 duplicate frame(s)!
  Pos:  28.4s    430f (19%) 93.42fps Trem:   0min   9mb  A-V:-0.014 [447:63]
  1 duplicate frame(s)!
  Pos:  28.5s    431f (19%) 93.41fps Trem:   0min   9mb  A-V:-0.017 [447:63]
  1 duplicate frame(s)!
  Pos:  28.5s    432f (19%) 93.47fps Trem:   0min   9mb  A-V:-0.024 [446:63]
  1 duplicate frame(s)!
  Pos:  28.6s    433f (19%) 93.46fps Trem:   0min   9mb  A-V:-0.021 [446:63]
  1 duplicate frame(s)!
  Pos:  28.7s    434f (19%) 93.51fps Trem:   0min   9mb  A-V:-0.023 [446:63]
  1 duplicate frame(s)!
  Pos:  28.7s    435f (19%) 93.51fps Trem:   0min   9mb  A-V:-0.016 [446:63]
  1 duplicate frame(s)!
  Pos:  28.8s    436f (19%) 93.50fps Trem:   0min   9mb  A-V:-0.015 [446:63]
  1 duplicate frame(s)!
  Pos:  28.9s    437f (19%) 93.56fps Trem:   0min   9mb  A-V:-0.019 [445:63]
  1 duplicate frame(s)!
  Pos:  28.9s    438f (19%) 93.55fps Trem:   0min   9mb  A-V:-0.014 [445:63]
  1 duplicate frame(s)!
  Pos:  29.0s    439f (19%) 93.60fps Trem:   0min   9mb  A-V:-0.013 [445:63]
  1 duplicate frame(s)!
  Pos:  29.1s    440f (19%) 93.62fps Trem:   0min   9mb  A-V:-0.020 [444:63]
  1 duplicate frame(s)!
  Pos:  29.1s    441f (19%) 93.65fps Trem:   0min   9mb  A-V:-0.013 [444:63]
  1 duplicate frame(s)!
  Pos:  29.2s    442f (19%) 93.64fps Trem:   0min   9mb  A-V:-0.007 [444:63]
  1 duplicate frame(s)!
  Pos:  29.3s    443f (19%) 93.70fps Trem:   0min   9mb  A-V:-0.003 [443:63]
  1 duplicate frame(s)!
  Pos:  29.3s    444f (19%) 93.69fps Trem:   0min   9mb  A-V:-0.008 [443:63]
  1 duplicate frame(s)!
  Pos:  29.4s    445f (19%) 93.68fps Trem:   0min   9mb  A-V:-0.005 [443:63]
  1 duplicate frame(s)!
  Pos:  29.5s    446f (19%) 93.74fps Trem:   0min   9mb  A-V:-0.006 [443:63]
  1 duplicate frame(s)!
  Pos:  29.5s    447f (19%) 93.73fps Trem:   0min   9mb  A-V:-0.013 [442:63]
  1 duplicate frame(s)!
  Pos:  29.6s    448f (19%) 93.76fps Trem:   0min   9mb  A-V:-0.006 [442:63]
  1 duplicate frame(s)!
  Pos:  29.7s    449f (19%) 93.78fps Trem:   0min   9mb  A-V:-0.008 [442:63]
  1 duplicate frame(s)!
  Pos:  29.7s    450f (19%) 93.81fps Trem:   0min   9mb  A-V:-0.013 [441:63]
  1 duplicate frame(s)!
  Pos:  29.8s    451f (19%) 93.82fps Trem:   0min   9mb  A-V:-0.020 [441:63]
  1 duplicate frame(s)!
  Pos:  29.9s    452f (19%) 93.81fps Trem:   0min   9mb  A-V:-0.015 [441:63]
  1 duplicate frame(s)!
  Pos:  29.9s    453f (19%) 93.87fps Trem:   0min   9mb  A-V:-0.014 [441:63]
  1 duplicate frame(s)!
  Pos:  30.0s    454f (19%) 93.86fps Trem:   0min   9mb  A-V:-0.021 [440:63]
  1 duplicate frame(s)!
  Pos:  30.1s    455f (19%) 93.91fps Trem:   0min   9mb  A-V:-0.014 [440:63]
  1 duplicate frame(s)!
  Pos:  30.1s    456f (19%) 93.90fps Trem:   0min   9mb  A-V:-0.017 [440:63]
  1 duplicate frame(s)!
  Pos:  30.2s    457f (19%) 93.94fps Trem:   0min   9mb  A-V:-0.023 [440:63]
  1 duplicate frame(s)!
  Pos:  30.3s    458f (20%) 93.93fps Trem:   0min   9mb  A-V:-0.019 [440:63]
  1 duplicate frame(s)!
  Pos:  30.3s    459f (20%) 93.92fps Trem:   0min   9mb  A-V:-0.023 [440:63]
  1 duplicate frame(s)!
  Pos:  30.4s    460f (20%) 93.95fps Trem:   0min   9mb  A-V:-0.030 [440:63]
  1 duplicate frame(s)!
  Pos:  30.5s    461f (20%) 93.95fps Trem:   0min   9mb  A-V:-0.024 [440:63]
  1 duplicate frame(s)!
  Pos:  30.5s    462f (20%) 94.00fps Trem:   0min   9mb  A-V:-0.023 [439:63]
  1 duplicate frame(s)!
  Pos:  30.6s    463f (20%) 93.99fps Trem:   0min   9mb  A-V:-0.030 [439:63]
  1 duplicate frame(s)!
  Pos:  30.7s    464f (20%) 94.04fps Trem:   0min   9mb  A-V:-0.036 [439:63]
  1 duplicate frame(s)!
  Pos:  30.7s    465f (20%) 94.02fps Trem:   0min   9mb  A-V:-0.030 [439:63]
  1 duplicate frame(s)!
  Pos:  30.8s    466f (20%) 94.07fps Trem:   0min   9mb  A-V:-0.026 [438:63]
  1 duplicate frame(s)!
  Pos:  30.9s    467f (20%) 94.08fps Trem:   0min   9mb  A-V:-0.031 [438:63]
  1 duplicate frame(s)!
  Pos:  30.9s    468f (20%) 94.05fps Trem:   0min   9mb  A-V:-0.025 [438:63]
  1 duplicate frame(s)!
  Pos:  31.0s    469f (20%) 94.10fps Trem:   0min   9mb  A-V:-0.023 [438:63]
  1 duplicate frame(s)!
  Pos:  31.1s    470f (20%) 94.11fps Trem:   0min   9mb  A-V:-0.030 [438:63]
  1 duplicate frame(s)!
  Pos:  31.1s    471f (20%) 94.12fps Trem:   0min   9mb  A-V:-0.023 [438:63]
  1 duplicate frame(s)!
  Pos:  31.2s    472f (20%) 94.14fps Trem:   0min   9mb  A-V:-0.025 [437:63]
  1 duplicate frame(s)!
  Pos:  31.3s    473f (20%) 94.17fps Trem:   0min   9mb  A-V:-0.032 [437:63]
  1 duplicate frame(s)!
  Pos:  31.3s    474f (20%) 94.16fps Trem:   0min   9mb  A-V:-0.026 [437:63]
  1 duplicate frame(s)!
  Pos:  31.4s    475f (20%) 94.17fps Trem:   0min   9mb  A-V:-0.028 [437:63]
  1 duplicate frame(s)!
  Pos:  31.5s    476f (20%) 94.20fps Trem:   0min   9mb  A-V:-0.035 [436:63]
  1 duplicate frame(s)!
  Pos:  31.5s    477f (20%) 94.19fps Trem:   0min   9mb  A-V:-0.028 [436:63]
  1 duplicate frame(s)!
  Pos:  31.6s    478f (20%) 94.24fps Trem:   0min   9mb  A-V:-0.026 [436:63]
  1 duplicate frame(s)!
  Pos:  31.7s    479f (20%) 94.25fps Trem:   0min   9mb  A-V:-0.032 [435:63]
  1 duplicate frame(s)!
  Pos:  31.7s    480f (20%) 94.28fps Trem:   0min   9mb  A-V:-0.025 [435:63]
  1 duplicate frame(s)!
  Pos:  31.8s    481f (20%) 94.30fps Trem:   0min   9mb  A-V:-0.025 [434:63]
  1 duplicate frame(s)!
  Pos:  31.9s    482f (20%) 94.29fps Trem:   0min   9mb  A-V:-0.029 [434:63]
  1 duplicate frame(s)!
  Pos:  31.9s    483f (21%) 94.26fps Trem:   0min   9mb  A-V:-0.025 [434:63]
  1 duplicate frame(s)!
  Pos:  32.0s    484f (21%) 94.26fps Trem:   0min   9mb  A-V:-0.029 [434:64]
  1 duplicate frame(s)!
  Pos:  32.1s    486f (21%) 94.31fps Trem:   0min   9mb  A-V:-0.032 [434:64]
  2 duplicate frame(s)!
  Pos:  32.2s    487f (21%) 94.29fps Trem:   0min   8mb  A-V:-0.026 [433:64]
  1 duplicate frame(s)!
  Pos:  32.3s    489f (21%) 94.35fps Trem:   0min   8mb  A-V:-0.019 [433:64]
  2 duplicate frame(s)!
  Pos:  32.4s    490f (21%) 94.34fps Trem:   0min   8mb  A-V:-0.015 [433:64]
  1 duplicate frame(s)!
  Pos:  32.5s    492f (21%) 94.34fps Trem:   0min   8mb  A-V:-0.003 [433:64]
  1 duplicate frame(s)!
  Pos:  32.6s    493f (21%) 94.39fps Trem:   0min   8mb  A-V:-0.003 [433:64]
  2 duplicate frame(s)!
  Pos:  32.7s    495f (21%) 94.38fps Trem:   0min   8mb  A-V:-0.007 [432:64]
  1 duplicate frame(s)!
  Pos:  32.8s    496f (21%) 94.39fps Trem:   0min   9mb  A-V:-0.011 [432:64]
  1 duplicate frame(s)!
  Pos:  32.8s    497f (21%) 94.43fps Trem:   0min   9mb  A-V:-0.017 [432:64]
  1 duplicate frame(s)!
  Pos:  32.9s    498f (21%) 94.41fps Trem:   0min   9mb  A-V:-0.011 [432:64]
  1 duplicate frame(s)!
  Pos:  33.0s    499f (21%) 94.44fps Trem:   0min   9mb  A-V:-0.007 [431:64]
  1 duplicate frame(s)!
  Pos:  33.0s    500f (21%) 94.43fps Trem:   0min   9mb  A-V:-0.012 [431:64]
  1 duplicate frame(s)!
  Pos:  33.1s    501f (21%) 94.47fps Trem:   0min   9mb  A-V:-0.019 [431:64]
  1 duplicate frame(s)!
  Pos:  33.2s    502f (21%) 94.45fps Trem:   0min   9mb  A-V:-0.017 [430:64]
  1 duplicate frame(s)!
  Pos:  33.2s    503f (21%) 94.44fps Trem:   0min   9mb  A-V:-0.024 [430:64]
  1 duplicate frame(s)!
  Pos:  33.3s    504f (21%) 94.47fps Trem:   0min   9mb  A-V:-0.017 [429:64]
  1 duplicate frame(s)!
  Pos:  33.4s    505f (21%) 94.46fps Trem:   0min   9mb  A-V:-0.017 [429:64]
  1 duplicate frame(s)!
  Pos:  33.4s    506f (21%) 94.47fps Trem:   0min   9mb  A-V:-0.022 [437:64]
  1 duplicate frame(s)!
  Pos:  33.5s    507f (21%) 94.45fps Trem:   0min   9mb  A-V:-0.018 [437:64]
  1 duplicate frame(s)!
  Pos:  33.6s    508f (21%) 94.49fps Trem:   0min   9mb  A-V:-0.019 [437:64]
  1 duplicate frame(s)!
  Pos:  33.6s    509f (21%) 94.50fps Trem:   0min   9mb  A-V:-0.025 [437:64]
  1 duplicate frame(s)!
  Pos:  33.7s    510f (21%) 94.50fps Trem:   0min   9mb  A-V:-0.019 [437:64]
  1 duplicate frame(s)!
  Pos:  33.8s    511f (21%) 94.52fps Trem:   0min   9mb  A-V:-0.015 [437:64]
  1 duplicate frame(s)!
  Pos:  33.8s    512f (22%) 94.50fps Trem:   0min   9mb  A-V:-0.009 [437:64]
  1 duplicate frame(s)!
  Pos:  33.9s    513f (22%) 94.54fps Trem:   0min   9mb  A-V:-0.005 [437:64]
  1 duplicate frame(s)!
  Pos:  34.0s    514f (22%) 94.52fps Trem:   0min   9mb  A-V:0.001 [437:64]
  1 duplicate frame(s)!
  Pos:  34.0s    515f (22%) 94.56fps Trem:   0min   9mb  A-V:0.005 [437:64]
  1 duplicate frame(s)!
  Pos:  34.1s    516f (22%) 94.56fps Trem:   0min   9mb  A-V:-0.000 [437:64]
  1 duplicate frame(s)!
  Pos:  34.2s    517f (22%) 94.58fps Trem:   0min   9mb  A-V:0.004 [437:64]
  1 duplicate frame(s)!
  Pos:  34.2s    518f (22%) 94.58fps Trem:   0min   9mb  A-V:0.000 [437:64]
  1 duplicate frame(s)!
  Pos:  34.3s    519f (22%) 94.57fps Trem:   0min   9mb  A-V:0.007 [437:64]
  1 duplicate frame(s)!
  Pos:  34.4s    520f (22%) 94.61fps Trem:   0min   9mb  A-V:0.008 [437:64]
  1 duplicate frame(s)!
  Pos:  34.4s    521f (22%) 94.61fps Trem:   0min   9mb  A-V:0.001 [437:64]
  1 duplicate frame(s)!
  Pos:  34.5s    522f (22%) 94.63fps Trem:   0min   9mb  A-V:0.007 [437:64]
  1 duplicate frame(s)!
  Pos:  34.6s    523f (22%) 94.63fps Trem:   0min   9mb  A-V:0.003 [437:64]
  1 duplicate frame(s)!
  Pos:  34.6s    524f (22%) 94.67fps Trem:   0min   9mb  A-V:-0.003 [437:64]
  1 duplicate frame(s)!
  Pos:  34.7s    525f (22%) 94.66fps Trem:   0min   9mb  A-V:-0.000 [438:64]
  1 duplicate frame(s)!
  Pos:  34.8s    526f (22%) 94.66fps Trem:   0min   9mb  A-V:-0.006 [438:64]
  1 duplicate frame(s)!
  Pos:  34.8s    527f (22%) 94.68fps Trem:   0min   9mb  A-V:-0.012 [438:64]
  1 duplicate frame(s)!
  Pos:  34.9s    528f (22%) 94.67fps Trem:   0min   9mb  A-V:-0.006 [438:64]
  1 duplicate frame(s)!
  Pos:  35.0s    529f (22%) 94.72fps Trem:   0min   9mb  A-V:-0.003 [438:63]
  1 duplicate frame(s)!
  Pos:  35.0s    530f (22%) 94.73fps Trem:   0min   9mb  A-V:-0.009 [437:63]
  1 duplicate frame(s)!
  Pos:  35.1s    531f (22%) 94.75fps Trem:   0min   9mb  A-V:-0.003 [437:63]
  1 duplicate frame(s)!
  Pos:  35.2s    532f (22%) 94.75fps Trem:   0min   9mb  A-V:-0.002 [437:63]
  1 duplicate frame(s)!
  Pos:  35.2s    533f (22%) 94.79fps Trem:   0min   9mb  A-V:-0.006 [437:63]
  1 duplicate frame(s)!
  Pos:  35.3s    534f (22%) 94.80fps Trem:   0min   9mb  A-V:-0.013 [437:63]
  1 duplicate frame(s)!
  Pos:  35.4s    535f (23%) 94.77fps Trem:   0min   9mb  A-V:-0.011 [437:63]
  1 duplicate frame(s)!
  Pos:  35.4s    536f (23%) 94.82fps Trem:   0min   9mb  A-V:-0.013 [437:63]
  1 duplicate frame(s)!
  Pos:  35.5s    537f (23%) 94.79fps Trem:   0min   9mb  A-V:-0.006 [437:63]
  1 duplicate frame(s)!
  Pos:  35.6s    538f (23%) 94.84fps Trem:   0min   9mb  A-V:-0.004 [437:63]
  1 duplicate frame(s)!
  Pos:  35.6s    539f (23%) 94.83fps Trem:   0min   9mb  A-V:-0.011 [437:63]
  1 duplicate frame(s)!
  Pos:  35.7s    540f (23%) 94.85fps Trem:   0min   9mb  A-V:-0.018 [437:63]
  1 duplicate frame(s)!
  Pos:  35.8s    541f (23%) 94.83fps Trem:   0min   9mb  A-V:-0.011 [437:63]
  1 duplicate frame(s)!
  Pos:  35.8s    542f (23%) 94.79fps Trem:   0min   9mb  A-V:-0.013 [438:63]
  1 duplicate frame(s)!
  Pos:  35.9s    543f (23%) 94.81fps Trem:   0min   9mb  A-V:-0.020 [438:63]
  1 duplicate frame(s)!
  Pos:  36.0s    544f (23%) 94.79fps Trem:   0min   9mb  A-V:-0.016 [438:63]
  1 duplicate frame(s)!
  Pos:  36.0s    545f (23%) 94.80fps Trem:   0min   9mb  A-V:-0.017 [438:63]
  1 duplicate frame(s)!
  Pos:  36.1s    546f (23%) 94.78fps Trem:   0min   9mb  A-V:-0.010 [438:63]
  1 duplicate frame(s)!
  Pos:  36.2s    547f (23%) 94.80fps Trem:   0min   9mb  A-V:-0.005 [438:63]
  1 duplicate frame(s)!
  Pos:  36.2s    548f (23%) 94.78fps Trem:   0min   9mb  A-V:-0.009 [438:63]
  1 duplicate frame(s)!
  Pos:  36.3s    549f (23%) 94.77fps Trem:   0min   9mb  A-V:-0.016 [438:63]
  1 duplicate frame(s)!
  Pos:  36.4s    550f (23%) 94.78fps Trem:   0min   9mb  A-V:-0.011 [438:63]
  1 duplicate frame(s)!
  Pos:  36.4s    551f (23%) 94.75fps Trem:   0min   9mb  A-V:-0.014 [438:63]
  1 duplicate frame(s)!
  Pos:  36.5s    552f (23%) 94.76fps Trem:   0min   9mb  A-V:-0.021 [438:63]
  1 duplicate frame(s)!
  Pos:  36.6s    553f (23%) 94.76fps Trem:   0min   9mb  A-V:-0.016 [438:63]
  1 duplicate frame(s)!
  Pos:  36.6s    554f (23%) 94.77fps Trem:   0min   9mb  A-V:-0.015 [438:63]
  1 duplicate frame(s)!
  Pos:  36.7s    555f (24%) 94.74fps Trem:   0min   9mb  A-V:-0.012 [438:63]
  1 duplicate frame(s)!
  Pos:  36.8s    556f (24%) 94.75fps Trem:   0min   9mb  A-V:-0.012 [438:63]
  1 duplicate frame(s)!
  Pos:  36.8s    557f (24%) 94.74fps Trem:   0min   9mb  A-V:-0.019 [438:63]
  1 duplicate frame(s)!
  Pos:  36.9s    558f (24%) 94.72fps Trem:   0min   9mb  A-V:-0.012 [438:63]
  1 duplicate frame(s)!
  Pos:  37.0s    559f (24%) 94.75fps Trem:   0min   9mb  A-V:-0.010 [438:63]
  1 duplicate frame(s)!
  Pos:  37.0s    560f (24%) 94.72fps Trem:   0min   9mb  A-V:-0.017 [438:63]
  1 duplicate frame(s)!
  Pos:  37.1s    561f (24%) 94.75fps Trem:   0min   9mb  A-V:-0.010 [438:63]
  1 duplicate frame(s)!
  Pos:  37.2s    562f (24%) 94.72fps Trem:   0min   9mb  A-V:-0.010 [438:63]
  1 duplicate frame(s)!
  Pos:  37.2s    563f (24%) 94.73fps Trem:   0min   9mb  A-V:-0.015 [438:63]
  1 duplicate frame(s)!
  Pos:  37.3s    564f (24%) 94.71fps Trem:   0min   9mb  A-V:-0.009 [438:63]
  1 duplicate frame(s)!
  Pos:  37.4s    565f (24%) 94.70fps Trem:   0min   9mb  A-V:-0.012 [438:63]
  1 duplicate frame(s)!
  Pos:  37.4s    566f (24%) 94.71fps Trem:   0min   9mb  A-V:-0.006 [438:63]
  1 duplicate frame(s)!
  Pos:  37.5s    567f (24%) 94.69fps Trem:   0min   9mb  A-V:-0.009 [438:63]
  1 duplicate frame(s)!
  Pos:  37.6s    568f (24%) 94.71fps Trem:   0min   9mb  A-V:-0.015 [438:63]
  1 duplicate frame(s)!
  Pos:  37.6s    569f (24%) 94.68fps Trem:   0min   9mb  A-V:-0.011 [438:63]
  1 duplicate frame(s)!
  Pos:  37.7s    570f (24%) 94.70fps Trem:   0min   9mb  A-V:-0.012 [438:63]
  1 duplicate frame(s)!
  Pos:  37.8s    571f (24%) 94.68fps Trem:   0min   9mb  A-V:-0.019 [438:63]
  1 duplicate frame(s)!
  Pos:  37.8s    572f (24%) 94.69fps Trem:   0min   9mb  A-V:-0.013 [438:64]
  1 duplicate frame(s)!
  Pos:  37.9s    573f (24%) 94.66fps Trem:   0min   9mb  A-V:-0.006 [438:64]
  1 duplicate frame(s)!
  Pos:  38.0s    574f (24%) 94.66fps Trem:   0min   9mb  A-V:-0.009 [438:64]
  1 duplicate frame(s)!
  Pos:  38.0s    575f (25%) 94.67fps Trem:   0min   9mb  A-V:-0.002 [438:64]
  1 duplicate frame(s)!
  Pos:  38.1s    576f (25%) 94.63fps Trem:   0min   9mb  A-V:-0.005 [438:64]
  1 duplicate frame(s)!
  Pos:  38.2s    577f (25%) 94.65fps Trem:   0min   9mb  A-V:-0.011 [438:64]
  1 duplicate frame(s)!
  Pos:  38.2s    578f (25%) 94.61fps Trem:   0min   9mb  A-V:-0.007 [439:64]
  1 duplicate frame(s)!
  Pos:  38.3s    579f (25%) 94.64fps Trem:   0min   9mb  A-V:-0.008 [439:64]
  1 duplicate frame(s)!
  Pos:  38.4s    580f (25%) 94.62fps Trem:   0min   9mb  A-V:-0.014 [439:64]
  1 duplicate frame(s)!
  Pos:  38.4s    581f (25%) 94.59fps Trem:   0min   9mb  A-V:-0.014 [439:64]
  1 duplicate frame(s)!
  Pos:  38.5s    582f (25%) 94.62fps Trem:   0min   9mb  A-V:-0.018 [439:64]
  1 duplicate frame(s)!
  Pos:  38.6s    583f (25%) 94.60fps Trem:   0min   9mb  A-V:-0.011 [439:64]
  1 duplicate frame(s)!
  Pos:  38.6s    584f (25%) 94.62fps Trem:   0min   9mb  A-V:-0.008 [439:64]
  1 duplicate frame(s)!
  Pos:  38.7s    585f (25%) 94.61fps Trem:   0min   9mb  A-V:-0.014 [439:64]
  1 duplicate frame(s)!
  Pos:  38.8s    586f (25%) 94.62fps Trem:   0min   9mb  A-V:-0.021 [439:64]
  1 duplicate frame(s)!
  Pos:  38.8s    587f (25%) 94.60fps Trem:   0min   9mb  A-V:-0.014 [439:64]
  1 duplicate frame(s)!
  Pos:  38.9s    588f (25%) 94.59fps Trem:   0min   9mb  A-V:-0.017 [439:64]
  1 duplicate frame(s)!
  Pos:  39.0s    589f (25%) 94.62fps Trem:   0min   9mb  A-V:-0.024 [439:64]
  1 duplicate frame(s)!
  Pos:  39.0s    590f (25%) 94.58fps Trem:   0min   9mb  A-V:-0.017 [439:64]
  1 duplicate frame(s)!
  Pos:  39.1s    591f (25%) 94.61fps Trem:   0min   9mb  A-V:-0.015 [439:64]
  1 duplicate frame(s)!
  Pos:  39.2s    592f (25%) 94.58fps Trem:   0min   9mb  A-V:-0.009 [439:64]
  1 duplicate frame(s)!
  Pos:  39.2s    593f (25%) 94.61fps Trem:   0min   9mb  A-V:-0.005 [439:64]
  1 duplicate frame(s)!
  Pos:  39.3s    594f (25%) 94.59fps Trem:   0min   9mb  A-V:-0.009 [440:64]
  1 duplicate frame(s)!
  Pos:  39.4s    595f (25%) 94.61fps Trem:   0min   9mb  A-V:-0.016 [439:64]
  1 duplicate frame(s)!
  Pos:  39.4s    596f (25%) 94.57fps Trem:   0min   9mb  A-V:-0.015 [440:64]
  1 duplicate frame(s)!
  Pos:  39.5s    597f (25%) 94.55fps Trem:   0min   9mb  A-V:-0.008 [440:64]
  1 duplicate frame(s)!
  Pos:  39.6s    598f (25%) 94.58fps Trem:   0min   9mb  A-V:-0.007 [440:64]
  1 duplicate frame(s)!
  Pos:  39.6s    599f (25%) 94.57fps Trem:   0min   9mb  A-V:-0.014 [440:64]
  1 duplicate frame(s)!
  Pos:  39.7s    600f (25%) 94.58fps Trem:   0min   9mb  A-V:-0.020 [440:64]
  1 duplicate frame(s)!
  Pos:  39.8s    601f (25%) 94.56fps Trem:   0min   9mb  A-V:-0.016 [440:64]
  1 duplicate frame(s)!
  Pos:  39.8s    602f (25%) 94.56fps Trem:   0min   9mb  A-V:-0.016 [440:64]
  1 duplicate frame(s)!
  Pos:  39.9s    603f (25%) 94.56fps Trem:   0min   9mb  A-V:-0.022 [439:64]
  1 duplicate frame(s)!
  Pos:  40.0s    604f (26%) 94.55fps Trem:   0min   9mb  A-V:-0.020 [439:64]
  1 duplicate frame(s)!
  Pos:  40.0s    605f (26%) 94.59fps Trem:   0min   9mb  A-V:-0.023 [439:63]
  1 duplicate frame(s)!
  Pos:  40.1s    606f (26%) 94.58fps Trem:   0min   9mb  A-V:-0.016 [439:63]
  1 duplicate frame(s)!
  Pos:  40.2s    607f (26%) 94.61fps Trem:   0min   9mb  A-V:-0.013 [439:63]
  1 duplicate frame(s)!
  Pos:  40.2s    608f (26%) 94.60fps Trem:   0min   9mb  A-V:-0.019 [439:64]
  1 duplicate frame(s)!
  Pos:  40.3s    609f (26%) 94.62fps Trem:   0min   9mb  A-V:-0.012 [439:64]
  1 duplicate frame(s)!
  Pos:  40.4s    610f (26%) 94.62fps Trem:   0min   9mb  A-V:-0.012 [439:64]
  1 duplicate frame(s)!
  Pos:  40.4s    611f (26%) 94.66fps Trem:   0min   9mb  A-V:-0.017 [439:64]
  1 duplicate frame(s)!
  Pos:  40.5s    612f (26%) 94.63fps Trem:   0min   9mb  A-V:-0.011 [439:63]
  1 duplicate frame(s)!
  Pos:  40.6s    613f (26%) 94.64fps Trem:   0min   9mb  A-V:-0.014 [439:63]
  1 duplicate frame(s)!
  Pos:  40.6s    614f (26%) 94.67fps Trem:   0min   9mb  A-V:-0.021 [439:63]
  1 duplicate frame(s)!
  Pos:  40.7s    615f (26%) 94.66fps Trem:   0min   9mb  A-V:-0.014 [439:63]
  1 duplicate frame(s)!
  Pos:  40.8s    616f (26%) 94.70fps Trem:   0min   9mb  A-V:-0.010 [439:63]
  1 duplicate frame(s)!
  Pos:  40.8s    617f (26%) 94.69fps Trem:   0min   9mb  A-V:-0.016 [439:63]
  1 duplicate frame(s)!
  Pos:  40.9s    618f (26%) 94.73fps Trem:   0min   9mb  A-V:-0.023 [439:63]
  1 duplicate frame(s)!
  Pos:  41.0s    619f (26%) 94.71fps Trem:   0min   9mb  A-V:-0.016 [439:63]
  1 duplicate frame(s)!
  Pos:  41.0s    620f (26%) 94.71fps Trem:   0min   9mb  A-V:-0.018 [439:63]
  1 duplicate frame(s)!
  Pos:  41.1s    621f (26%) 94.75fps Trem:   0min   9mb  A-V:-0.025 [439:63]
  1 duplicate frame(s)!
  Pos:  41.2s    622f (26%) 94.74fps Trem:   0min   9mb  A-V:-0.018 [438:63]
  1 duplicate frame(s)!
  Pos:  41.2s    623f (26%) 94.78fps Trem:   0min   9mb  A-V:-0.014 [438:63]
  1 duplicate frame(s)!
  Pos:  41.3s    624f (26%) 94.76fps Trem:   0min   9mb  A-V:-0.007 [438:63]
  1 duplicate frame(s)!
  Pos:  41.4s    625f (26%) 94.80fps Trem:   0min   9mb  A-V:-0.004 [438:63]
  1 duplicate frame(s)!
  Pos:  41.4s    626f (26%) 94.81fps Trem:   0min   9mb  A-V:-0.009 [438:63]
  1 duplicate frame(s)!
  Pos:  41.5s    627f (26%) 94.78fps Trem:   0min   9mb  A-V:-0.010 [438:63]
  1 duplicate frame(s)!
  Pos:  41.6s    628f (26%) 94.82fps Trem:   0min   9mb  A-V:-0.015 [438:63]
  1 duplicate frame(s)!
  Pos:  41.6s    629f (26%) 94.81fps Trem:   0min   9mb  A-V:-0.008 [437:63]
  1 duplicate frame(s)!
  Pos:  41.7s    630f (26%) 94.85fps Trem:   0min   9mb  A-V:-0.006 [437:63]
  1 duplicate frame(s)!
  Pos:  41.8s    631f (27%) 94.80fps Trem:   0min   9mb  A-V:-0.000 [443:63]
  1 duplicate frame(s)!
  Pos:  41.8s    632f (27%) 94.84fps Trem:   0min   9mb  A-V:0.001 [443:63]
  1 duplicate frame(s)!
  Pos:  41.9s    633f (27%) 94.83fps Trem:   0min   9mb  A-V:0.007 [443:63]
  1 duplicate frame(s)!
  Pos:  42.0s    634f (27%) 94.87fps Trem:   0min   9mb  A-V:0.010 [443:63]
  1 duplicate frame(s)!
  Pos:  42.0s    635f (27%) 94.86fps Trem:   0min   9mb  A-V:0.004 [443:63]
  1 duplicate frame(s)!
  Pos:  42.1s    636f (27%) 94.85fps Trem:   0min   9mb  A-V:0.009 [443:63]
  1 duplicate frame(s)!
  Pos:  42.2s    637f (27%) 94.89fps Trem:   0min   9mb  A-V:0.009 [442:63]
  1 duplicate frame(s)!
  Pos:  42.2s    638f (27%) 94.90fps Trem:   0min   9mb  A-V:0.002 [442:63]
  1 duplicate frame(s)!
  Pos:  42.3s    639f (27%) 94.92fps Trem:   0min   9mb  A-V:0.008 [442:63]
  1 duplicate frame(s)!
  Pos:  42.4s    640f (27%) 94.93fps Trem:   0min   9mb  A-V:0.005 [442:63]
  1 duplicate frame(s)!
  Pos:  42.4s    641f (27%) 94.96fps Trem:   0min   9mb  A-V:-0.002 [442:63]
  1 duplicate frame(s)!
  Pos:  42.5s    642f (27%) 94.96fps Trem:   0min   9mb  A-V:0.002 [441:63]
  1 duplicate frame(s)!
  Pos:  42.6s    643f (27%) 94.95fps Trem:   0min   9mb  A-V:-0.003 [441:63]
  1 duplicate frame(s)!
  Pos:  42.6s    644f (27%) 94.99fps Trem:   0min   9mb  A-V:-0.010 [441:63]
  1 duplicate frame(s)!
  Pos:  42.7s    645f (27%) 94.98fps Trem:   0min   9mb  A-V:-0.004 [441:63]
  1 duplicate frame(s)!
  Pos:  42.8s    646f (27%) 95.01fps Trem:   0min   9mb  A-V:-0.002 [441:63]
  1 duplicate frame(s)!
  Pos:  42.8s    647f (27%) 95.01fps Trem:   0min   9mb  A-V:-0.009 [441:63]
  1 duplicate frame(s)!
  Pos:  42.9s    648f (27%) 95.03fps Trem:   0min   9mb  A-V:-0.002 [441:63]
  1 duplicate frame(s)!
  Pos:  43.0s    649f (27%) 95.04fps Trem:   0min   9mb  A-V:-0.005 [441:63]
  1 duplicate frame(s)!
  Pos:  43.0s    650f (27%) 95.06fps Trem:   0min   9mb  A-V:-0.011 [440:63]
  1 duplicate frame(s)!
  Pos:  43.1s    651f (27%) 95.05fps Trem:   0min   9mb  A-V:-0.011 [440:63]
  1 duplicate frame(s)!
  Pos:  43.2s    652f (28%) 95.03fps Trem:   0min   9mb  A-V:-0.005 [440:64]
  1 duplicate frame(s)!
  Pos:  43.2s    653f (28%) 95.06fps Trem:   0min   9mb  A-V:-0.004 [440:64]
  1 duplicate frame(s)!
  Pos:  43.3s    654f (28%) 95.06fps Trem:   0min   9mb  A-V:0.003 [440:64]
  1 duplicate frame(s)!
  Pos:  43.4s    655f (28%) 95.09fps Trem:   0min   9mb  A-V:0.004 [440:64]
  1 duplicate frame(s)!
  Pos:  43.4s    656f (28%) 95.09fps Trem:   0min   9mb  A-V:-0.002 [440:64]
  1 duplicate frame(s)!
  Pos:  43.5s    657f (28%) 95.12fps Trem:   0min   9mb  A-V:0.004 [439:64]
  1 duplicate frame(s)!
  Pos:  43.6s    658f (28%) 95.11fps Trem:   0min   9mb  A-V:0.004 [439:64]
  1 duplicate frame(s)!
  Pos:  43.6s    659f (28%) 95.11fps Trem:   0min   9mb  A-V:-0.003 [439:64]
  1 duplicate frame(s)!
  Pos:  43.7s    660f (28%) 95.13fps Trem:   0min   9mb  A-V:0.001 [439:64]
  1 duplicate frame(s)!
  Pos:  43.8s    661f (28%) 95.11fps Trem:   0min   9mb  A-V:-0.004 [439:64]
  1 duplicate frame(s)!
  Pos:  43.8s    662f (28%) 95.10fps Trem:   0min   9mb  A-V:-0.011 [439:64]
  1 duplicate frame(s)!
  Pos:  43.9s    663f (28%) 95.09fps Trem:   0min   9mb  A-V:-0.004 [439:64]
  1 duplicate frame(s)!
  Pos:  44.0s    664f (28%) 95.12fps Trem:   0min   9mb  A-V:-0.002 [439:64]
  1 duplicate frame(s)!
  Pos:  44.0s    665f (28%) 95.11fps Trem:   0min   9mb  A-V:-0.009 [439:64]
  1 duplicate frame(s)!
  Pos:  44.1s    666f (28%) 95.13fps Trem:   0min   9mb  A-V:-0.016 [439:64]
  1 duplicate frame(s)!
  Pos:  44.2s    667f (28%) 95.11fps Trem:   0min   9mb  A-V:-0.014 [438:64]
  1 duplicate frame(s)!
  Pos:  44.2s    668f (28%) 95.09fps Trem:   0min   9mb  A-V:-0.008 [438:64]
  1 duplicate frame(s)!
  Pos:  44.3s    669f (28%) 95.11fps Trem:   0min   9mb  A-V:-0.005 [438:64]
  1 duplicate frame(s)!
  Pos:  44.4s    670f (28%) 95.12fps Trem:   0min   9mb  A-V:-0.011 [437:64]
  1 duplicate frame(s)!
  Pos:  44.4s    671f (28%) 95.12fps Trem:   0min   9mb  A-V:-0.004 [437:64]
  1 duplicate frame(s)!
  Pos:  44.5s    672f (28%) 95.12fps Trem:   0min   9mb  A-V:-0.005 [437:64]
  1 duplicate frame(s)!
  Pos:  44.6s    673f (28%) 95.14fps Trem:   0min   9mb  A-V:-0.010 [437:64]
  1 duplicate frame(s)!
  Pos:  44.6s    674f (28%) 95.13fps Trem:   0min   9mb  A-V:-0.017 [437:64]
  1 duplicate frame(s)!
  Pos:  44.7s    675f (28%) 95.12fps Trem:   0min   9mb  A-V:-0.017 [436:64]
  1 duplicate frame(s)!
  Pos:  44.8s    676f (28%) 95.14fps Trem:   0min   9mb  A-V:-0.020 [436:64]
  1 duplicate frame(s)!
  Pos:  44.8s    677f (29%) 95.11fps Trem:   0min   9mb  A-V:-0.014 [436:64]
  1 duplicate frame(s)!
  Pos:  44.9s    678f (29%) 95.13fps Trem:   0min   9mb  A-V:-0.011 [436:64]
  1 duplicate frame(s)!
  Pos:  45.0s    679f (29%) 95.12fps Trem:   0min   9mb  A-V:-0.017 [436:64]
  1 duplicate frame(s)!
  Pos:  45.0s    680f (29%) 95.14fps Trem:   0min   9mb  A-V:-0.023 [436:64]
  1 duplicate frame(s)!
  Pos:  45.1s    681f (29%) 95.15fps Trem:   0min   9mb  A-V:-0.030 [435:64]
  1 duplicate frame(s)!
  Pos:  45.2s    682f (29%) 95.13fps Trem:   0min   9mb  A-V:-0.027 [435:63]
  1 duplicate frame(s)!
  Pos:  45.2s    683f (29%) 95.17fps Trem:   0min   9mb  A-V:-0.028 [435:63]
  1 duplicate frame(s)!
  Pos:  45.3s    684f (29%) 95.15fps Trem:   0min   9mb  A-V:-0.021 [435:63]
  1 duplicate frame(s)!
  Pos:  45.4s    685f (29%) 95.17fps Trem:   0min   9mb  A-V:-0.019 [435:63]
  1 duplicate frame(s)!
  Pos:  45.4s    686f (29%) 95.16fps Trem:   0min   9mb  A-V:-0.026 [435:63]
  1 duplicate frame(s)!
  Pos:  45.5s    687f (29%) 95.18fps Trem:   0min   9mb  A-V:-0.033 [435:63]
  1 duplicate frame(s)!
  Pos:  45.6s    688f (29%) 95.17fps Trem:   0min   9mb  A-V:-0.026 [434:63]
  1 duplicate frame(s)!
  Pos:  45.6s    689f (29%) 95.19fps Trem:   0min   9mb  A-V:-0.025 [434:63]
  1 duplicate frame(s)!
  Pos:  45.7s    690f (29%) 95.19fps Trem:   0min   9mb  A-V:-0.032 [434:63]
  1 duplicate frame(s)!
  Pos:  45.8s    691f (29%) 95.17fps Trem:   0min   9mb  A-V:-0.028 [434:63]
  1 duplicate frame(s)!
  Pos:  45.8s    692f (29%) 95.19fps Trem:   0min   9mb  A-V:-0.029 [434:63]
  1 duplicate frame(s)!
  Pos:  45.9s    693f (29%) 95.17fps Trem:   0min   9mb  A-V:-0.022 [433:63]
  1 duplicate frame(s)!
  Pos:  46.0s    694f (29%) 95.19fps Trem:   0min   9mb  A-V:-0.018 [433:63]
  1 duplicate frame(s)!
  Pos:  46.0s    695f (29%) 95.18fps Trem:   0min   9mb  A-V:-0.023 [433:63]
  1 duplicate frame(s)!
  Pos:  46.1s    696f (29%) 95.20fps Trem:   0min   9mb  A-V:-0.030 [433:63]
  1 duplicate frame(s)!
  Pos:  46.2s    697f (29%) 95.18fps Trem:   0min   9mb  A-V:-0.023 [433:63]
  1 duplicate frame(s)!
  Pos:  46.2s    698f (29%) 95.17fps Trem:   0min   9mb  A-V:-0.026 [432:63]
  1 duplicate frame(s)!
  Pos:  46.3s    699f (29%) 95.18fps Trem:   0min   9mb  A-V:-0.033 [432:63]
  1 duplicate frame(s)!
  Pos:  46.4s    700f (30%) 95.16fps Trem:   0min   9mb  A-V:-0.028 [432:63]
  1 duplicate frame(s)!
  Pos:  46.4s    701f (30%) 95.18fps Trem:   0min   9mb  A-V:-0.028 [432:63]
  1 duplicate frame(s)!
  Pos:  46.5s    702f (30%) 95.16fps Trem:   0min   9mb  A-V:-0.021 [433:63]
  1 duplicate frame(s)!
  Pos:  46.6s    703f (30%) 95.17fps Trem:   0min   9mb  A-V:-0.018 [433:63]
  1 duplicate frame(s)!
  Pos:  46.6s    704f (30%) 95.16fps Trem:   0min   9mb  A-V:-0.024 [433:63]
  1 duplicate frame(s)!
  Pos:  46.7s    705f (30%) 95.17fps Trem:   0min   9mb  A-V:-0.030 [433:63]
  1 duplicate frame(s)!
  Pos:  46.8s    706f (30%) 95.15fps Trem:   0min   9mb  A-V:-0.024 [433:63]
  1 duplicate frame(s)!
  Pos:  46.8s    707f (30%) 95.13fps Trem:   0min   9mb  A-V:-0.028 [433:63]
  1 duplicate frame(s)!
  Pos:  46.9s    708f (30%) 95.15fps Trem:   0min   9mb  A-V:-0.034 [433:63]
  1 duplicate frame(s)!
  Pos:  47.0s    709f (30%) 95.13fps Trem:   0min   9mb  A-V:-0.029 [432:63]
  1 duplicate frame(s)!
  Pos:  47.0s    710f (30%) 95.14fps Trem:   0min   9mb  A-V:-0.022 [433:63]
  1 duplicate frame(s)!
  Pos:  47.1s    711f (30%) 95.13fps Trem:   0min   9mb  A-V:-0.021 [433:63]
  1 duplicate frame(s)!
  Pos:  47.2s    712f (30%) 95.12fps Trem:   0min   9mb  A-V:-0.025 [433:63]
  1 duplicate frame(s)!
  Pos:  47.2s    713f (30%) 95.12fps Trem:   0min   9mb  A-V:-0.018 [433:63]
  1 duplicate frame(s)!
  Pos:  47.3s    714f (30%) 95.11fps Trem:   0min   9mb  A-V:-0.021 [433:63]
  1 duplicate frame(s)!
  Pos:  47.4s    715f (30%) 95.12fps Trem:   0min   9mb  A-V:-0.014 [433:63]
  1 duplicate frame(s)!
  Pos:  47.4s    716f (30%) 95.10fps Trem:   0min   9mb  A-V:-0.016 [433:63]
  1 duplicate frame(s)!
  Pos:  47.5s    717f (30%) 95.12fps Trem:   0min   9mb  A-V:-0.021 [433:63]
  1 duplicate frame(s)!
  Pos:  47.6s    718f (30%) 95.10fps Trem:   0min   9mb  A-V:-0.017 [433:63]
  1 duplicate frame(s)!
  Pos:  47.6s    719f (30%) 95.11fps Trem:   0min   9mb  A-V:-0.018 [433:63]
  1 duplicate frame(s)!
  Pos:  47.7s    720f (30%) 95.10fps Trem:   0min   9mb  A-V:-0.011 [433:63]
  1 duplicate frame(s)!
  Pos:  47.8s    721f (30%) 95.08fps Trem:   0min   9mb  A-V:-0.011 [433:63]
  1 duplicate frame(s)!
  Pos:  47.8s    722f (30%) 95.09fps Trem:   0min   9mb  A-V:-0.015 [433:63]
  1 duplicate frame(s)!
  Pos:  47.9s    723f (30%) 95.07fps Trem:   0min   9mb  A-V:-0.008 [433:64]
  1 duplicate frame(s)!
  Pos:  48.0s    724f (30%) 95.10fps Trem:   0min   9mb  A-V:-0.005 [433:64]
  1 duplicate frame(s)!
  Pos:  48.0s    725f (31%) 95.07fps Trem:   0min   9mb  A-V:0.001 [433:64]
  1 duplicate frame(s)!
  Pos:  48.1s    726f (31%) 95.10fps Trem:   0min   9mb  A-V:0.003 [433:64]
  1 duplicate frame(s)!
  Pos:  48.2s    727f (31%) 95.09fps Trem:   0min   9mb  A-V:-0.004 [433:64]
  1 duplicate frame(s)!
  Pos:  48.2s    728f (31%) 95.13fps Trem:   0min   9mb  A-V:-0.010 [433:64]
  1 duplicate frame(s)!
  Pos:  48.3s    729f (31%) 95.11fps Trem:   0min   9mb  A-V:-0.007 [433:64]
  1 duplicate frame(s)!
  Pos:  48.4s    730f (31%) 95.11fps Trem:   0min   9mb  A-V:-0.012 [433:64]
  1 duplicate frame(s)!
  Pos:  48.4s    731f (31%) 95.13fps Trem:   0min   9mb  A-V:-0.019 [433:64]
  1 duplicate frame(s)!
  Pos:  48.5s    732f (31%) 95.13fps Trem:   0min   9mb  A-V:-0.015 [433:64]
  1 duplicate frame(s)!
  Pos:  48.6s    733f (31%) 95.15fps Trem:   0min   9mb  A-V:-0.016 [433:64]
  1 duplicate frame(s)!
  Pos:  48.6s    734f (31%) 95.14fps Trem:   0min   9mb  A-V:-0.022 [433:64]
  1 duplicate frame(s)!
  Pos:  48.7s    735f (31%) 95.16fps Trem:   0min   9mb  A-V:-0.016 [433:64]
  1 duplicate frame(s)!
  Pos:  48.8s    736f (31%) 95.16fps Trem:   0min   9mb  A-V:-0.014 [433:63]
  1 duplicate frame(s)!
  Pos:  48.8s    737f (31%) 95.17fps Trem:   0min   9mb  A-V:-0.021 [433:63]
  1 duplicate frame(s)!
  Pos:  48.9s    738f (31%) 95.19fps Trem:   0min   9mb  A-V:-0.016 [433:63]
  1 duplicate frame(s)!
  Pos:  49.0s    739f (31%) 95.18fps Trem:   0min   9mb  A-V:-0.020 [433:64]
  1 duplicate frame(s)!
  Pos:  49.0s    740f (31%) 95.21fps Trem:   0min   9mb  A-V:-0.026 [433:63]
  1 duplicate frame(s)!
  Pos:  49.1s    741f (31%) 95.21fps Trem:   0min   9mb  A-V:-0.023 [433:63]
  1 duplicate frame(s)!
  Pos:  49.2s    742f (31%) 95.23fps Trem:   0min   9mb  A-V:-0.025 [433:63]
  1 duplicate frame(s)!
  Pos:  49.2s    743f (31%) 95.22fps Trem:   0min   9mb  A-V:-0.018 [433:63]
  1 duplicate frame(s)!
  Pos:  49.3s    744f (31%) 95.25fps Trem:   0min   9mb  A-V:-0.012 [433:63]
  1 duplicate frame(s)!
  Pos:  49.4s    745f (31%) 95.24fps Trem:   0min   9mb  A-V:-0.015 [433:63]
  1 duplicate frame(s)!
  Pos:  49.4s    746f (32%) 95.24fps Trem:   0min   9mb  A-V:-0.009 [433:63]
  1 duplicate frame(s)!
  Pos:  49.5s    747f (32%) 95.27fps Trem:   0min   9mb  A-V:-0.008 [433:63]
  1 duplicate frame(s)!
  Pos:  49.6s    748f (32%) 95.26fps Trem:   0min   9mb  A-V:-0.001 [433:63]
  1 duplicate frame(s)!
  Pos:  49.6s    749f (32%) 95.28fps Trem:   0min   9mb  A-V:0.002 [433:63]
  1 duplicate frame(s)!
  Pos:  49.7s    750f (32%) 95.26fps Trem:   0min   9mb  A-V:0.008 [433:63]
  1 duplicate frame(s)!
  Pos:  49.8s    751f (32%) 95.28fps Trem:   0min   9mb  A-V:0.011 [433:63]
  1 duplicate frame(s)!
  Pos:  49.8s    752f (32%) 95.29fps Trem:   0min   9mb  A-V:0.005 [433:64]
  1 duplicate frame(s)!
  Pos:  49.9s    753f (32%) 95.27fps Trem:   0min   9mb  A-V:-0.001 [433:64]
  1 duplicate frame(s)!
  Pos:  50.0s    754f (32%) 95.29fps Trem:   0min   9mb  A-V:0.002 [433:64]
  1 duplicate frame(s)!
  Pos:  50.0s    755f (32%) 95.28fps Trem:   0min   9mb  A-V:-0.003 [433:64]
  1 duplicate frame(s)!
  Pos:  50.1s    756f (32%) 95.29fps Trem:   0min   9mb  A-V:-0.010 [438:64]
  1 duplicate frame(s)!
  Pos:  50.2s    757f (32%) 95.26fps Trem:   0min   9mb  A-V:-0.007 [438:64]
  1 duplicate frame(s)!
  Pos:  50.3s    758f (32%) 95.29fps Trem:   0min   9mb  A-V:-0.009 [438:64]
  1 duplicate frame(s)!
  Pos:  50.3s    759f (32%) 95.28fps Trem:   0min   9mb  A-V:-0.015 [438:64]
  1 duplicate frame(s)!
  Pos:  50.4s    760f (32%) 95.27fps Trem:   0min   9mb  A-V:-0.010 [438:64]
  1 duplicate frame(s)!
  Pos:  50.5s    761f (32%) 95.29fps Trem:   0min   9mb  A-V:-0.010 [438:64]
  1 duplicate frame(s)!
  Pos:  50.5s    762f (32%) 95.30fps Trem:   0min   9mb  A-V:-0.016 [438:64]
  1 duplicate frame(s)!
  Pos:  50.6s    763f (32%) 95.30fps Trem:   0min   9mb  A-V:-0.010 [438:64]
  1 duplicate frame(s)!
  Pos:  50.7s    764f (32%) 95.30fps Trem:   0min   9mb  A-V:-0.011 [438:64]
  1 duplicate frame(s)!
  Pos:  50.7s    765f (32%) 95.33fps Trem:   0min   9mb  A-V:-0.017 [438:63]
  1 duplicate frame(s)!
  Pos:  50.8s    766f (32%) 95.32fps Trem:   0min   9mb  A-V:-0.012 [438:64]
  1 duplicate frame(s)!
  Pos:  50.9s    767f (32%) 95.34fps Trem:   0min   9mb  A-V:-0.013 [438:64]
  1 duplicate frame(s)!
  Pos:  50.9s    768f (32%) 95.33fps Trem:   0min   9mb  A-V:-0.020 [438:63]
  1 duplicate frame(s)!
  Pos:  51.0s    769f (32%) 95.31fps Trem:   0min   9mb  A-V:-0.017 [438:63]
  1 duplicate frame(s)!
  Pos:  51.1s    770f (32%) 95.34fps Trem:   0min   9mb  A-V:-0.019 [438:63]
  1 duplicate frame(s)!
  Pos:  51.1s    771f (32%) 95.34fps Trem:   0min   9mb  A-V:-0.012 [438:63]
  1 duplicate frame(s)!
  Pos:  51.2s    772f (32%) 95.36fps Trem:   0min   9mb  A-V:-0.010 [438:63]
  1 duplicate frame(s)!
  Pos:  51.3s    773f (33%) 95.34fps Trem:   0min   9mb  A-V:-0.003 [438:63]
  1 duplicate frame(s)!
  Pos:  51.3s    774f (33%) 95.37fps Trem:   0min   9mb  A-V:0.000 [438:63]
  1 duplicate frame(s)!
  Pos:  51.4s    775f (33%) 95.36fps Trem:   0min   9mb  A-V:-0.006 [438:63]
  1 duplicate frame(s)!
  Pos:  51.5s    776f (33%) 95.34fps Trem:   0min   9mb  A-V:-0.001 [438:64]
  1 duplicate frame(s)!
  Pos:  51.5s    777f (33%) 95.37fps Trem:   0min   9mb  A-V:-0.002 [438:64]
  1 duplicate frame(s)!
  Pos:  51.6s    778f (33%) 95.37fps Trem:   0min   9mb  A-V:-0.008 [438:64]
  1 duplicate frame(s)!
  Pos:  51.7s    779f (33%) 95.37fps Trem:   0min   9mb  A-V:-0.002 [438:64]
  1 duplicate frame(s)!
  Pos:  51.7s    780f (33%) 95.37fps Trem:   0min   9mb  A-V:-0.005 [438:64]
  1 duplicate frame(s)!
  Pos:  51.8s    781f (33%) 95.38fps Trem:   0min   9mb  A-V:0.002 [438:63]
  1 duplicate frame(s)!
  Pos:  51.9s    782f (33%) 95.35fps Trem:   0min   9mb  A-V:-0.001 [439:63]
  1 duplicate frame(s)!
  Pos:  51.9s    783f (33%) 95.36fps Trem:   0min   9mb  A-V:-0.007 [439:64]
  1 duplicate frame(s)!
  Pos:  52.0s    784f (33%) 95.34fps Trem:   0min   9mb  A-V:-0.002 [439:64]
  1 duplicate frame(s)!
  Pos:  52.1s    785f (33%) 95.32fps Trem:   0min   9mb  A-V:-0.006 [439:63]
  1 duplicate frame(s)!
  Pos:  52.1s    786f (33%) 95.34fps Trem:   0min   9mb  A-V:-0.013 [439:63]
  1 duplicate frame(s)!
  Pos:  52.2s    787f (33%) 95.31fps Trem:   0min   9mb  A-V:-0.007 [439:63]
  1 duplicate frame(s)!
  Pos:  52.3s    788f (33%) 95.33fps Trem:   0min   9mb  A-V:-0.006 [439:64]
  1 duplicate frame(s)!
  Pos:  52.3s    789f (33%) 95.31fps Trem:   0min   9mb  A-V:-0.013 [439:64]
  1 duplicate frame(s)!
  Pos:  52.4s    790f (33%) 95.32fps Trem:   0min   9mb  A-V:-0.006 [439:64]
  1 duplicate frame(s)!
  Pos:  52.5s    791f (33%) 95.31fps Trem:   0min   9mb  A-V:-0.007 [439:64]
  1 duplicate frame(s)!
  Pos:  52.5s    792f (33%) 95.30fps Trem:   0min   9mb  A-V:-0.002 [439:63]
  1 duplicate frame(s)!
  Pos:  52.6s    793f (33%) 95.31fps Trem:   0min   9mb  A-V:-0.001 [439:63]
  1 duplicate frame(s)!
  Pos:  52.7s    794f (34%) 95.28fps Trem:   0min   9mb  A-V:0.003 [439:64]
  1 duplicate frame(s)!
  Pos:  52.7s    795f (34%) 95.30fps Trem:   0min   9mb  A-V:0.002 [438:64]
  1 duplicate frame(s)!
  Pos:  52.8s    796f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.004 [438:64]
  1 duplicate frame(s)!
  Pos:  52.9s    797f (34%) 95.30fps Trem:   0min   9mb  A-V:0.002 [438:64]
  1 duplicate frame(s)!
  Pos:  52.9s    798f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.002 [438:64]
  1 duplicate frame(s)!
  Pos:  53.0s    799f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.008 [438:64]
  1 duplicate frame(s)!
  Pos:  53.1s    800f (34%) 95.29fps Trem:   0min   9mb  A-V:-0.015 [438:64]
  1 duplicate frame(s)!
  Pos:  53.1s    801f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.009 [438:64]
  1 duplicate frame(s)!
  Pos:  53.2s    802f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.008 [438:64]
  1 duplicate frame(s)!
  Pos:  53.3s    803f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.014 [438:64]
  1 duplicate frame(s)!
  Pos:  53.3s    804f (34%) 95.29fps Trem:   0min   9mb  A-V:-0.021 [438:64]
  1 duplicate frame(s)!
  Pos:  53.4s    805f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.015 [438:63]
  1 duplicate frame(s)!
  Pos:  53.5s    806f (34%) 95.29fps Trem:   0min   9mb  A-V:-0.010 [438:63]
  1 duplicate frame(s)!
  Pos:  53.5s    807f (34%) 95.29fps Trem:   0min   9mb  A-V:-0.015 [438:63]
  1 duplicate frame(s)!
  Pos:  53.6s    808f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.022 [438:63]
  1 duplicate frame(s)!
  Pos:  53.7s    809f (34%) 95.30fps Trem:   0min   9mb  A-V:-0.015 [438:63]
  1 duplicate frame(s)!
  Pos:  53.7s    810f (34%) 95.29fps Trem:   0min   9mb  A-V:-0.018 [438:63]
  1 duplicate frame(s)!
  Pos:  53.8s    811f (34%) 95.30fps Trem:   0min   9mb  A-V:-0.011 [438:63]
  1 duplicate frame(s)!
  Pos:  53.9s    812f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.012 [438:63]
  1 duplicate frame(s)!
  Pos:  53.9s    813f (34%) 95.30fps Trem:   0min   9mb  A-V:-0.006 [438:63]
  1 duplicate frame(s)!
  Pos:  54.0s    814f (34%) 95.28fps Trem:   0min   9mb  A-V:0.001 [438:63]
  1 duplicate frame(s)!
  Pos:  54.1s    815f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.000 [438:63]
  1 duplicate frame(s)!
  Pos:  54.1s    816f (34%) 95.29fps Trem:   0min   9mb  A-V:-0.006 [438:63]
  1 duplicate frame(s)!
  Pos:  54.2s    817f (34%) 95.28fps Trem:   0min   9mb  A-V:-0.001 [437:63]
  1 duplicate frame(s)!
  Pos:  54.3s    818f (34%) 95.29fps Trem:   0min   9mb  A-V:-0.002 [437:63]
  1 duplicate frame(s)!
  Pos:  54.3s    819f (34%) 95.29fps Trem:   0min   9mb  A-V:-0.009 [437:63]
  1 duplicate frame(s)!
  Pos:  54.4s    820f (34%) 95.30fps Trem:   0min   9mb  A-V:-0.002 [437:63]
  1 duplicate frame(s)!
  Pos:  54.5s    821f (34%) 95.30fps Trem:   0min   9mb  A-V:-0.004 [437:63]
  1 duplicate frame(s)!
  Pos:  54.5s    822f (34%) 95.32fps Trem:   0min   9mb  A-V:0.002 [437:63]
  1 duplicate frame(s)!
  Pos:  54.6s    823f (34%) 95.31fps Trem:   0min   9mb  A-V:0.002 [436:63]
  1 duplicate frame(s)!
  Pos:  54.7s    824f (34%) 95.30fps Trem:   0min   9mb  A-V:-0.005 [436:63]
  1 duplicate frame(s)!
  Pos:  54.7s    825f (35%) 95.31fps Trem:   0min   9mb  A-V:-0.001 [436:63]
  1 duplicate frame(s)!
  Pos:  54.8s    826f (35%) 95.30fps Trem:   0min   9mb  A-V:-0.006 [436:63]
  1 duplicate frame(s)!
  Pos:  54.9s    827f (35%) 95.31fps Trem:   0min   9mb  A-V:-0.012 [436:63]
  1 duplicate frame(s)!
  Pos:  54.9s    828f (35%) 95.30fps Trem:   0min   9mb  A-V:-0.009 [436:63]
  1 duplicate frame(s)!
  Pos:  55.0s    829f (35%) 95.31fps Trem:   0min   9mb  A-V:-0.011 [436:64]
  1 duplicate frame(s)!
  Pos:  55.1s    830f (35%) 95.29fps Trem:   0min   9mb  A-V:-0.004 [435:64]
  1 duplicate frame(s)!
  Pos:  55.1s    831f (35%) 95.29fps Trem:   0min   9mb  A-V:-0.004 [435:64]
  1 duplicate frame(s)!
  Pos:  55.2s    832f (35%) 95.30fps Trem:   0min   9mb  A-V:-0.009 [435:64]
  1 duplicate frame(s)!
  Pos:  55.3s    833f (35%) 95.29fps Trem:   0min   9mb  A-V:-0.004 [435:64]
  1 duplicate frame(s)!
  Pos:  55.3s    834f (35%) 95.29fps Trem:   0min   9mb  A-V:-0.004 [435:64]
  1 duplicate frame(s)!
  Pos:  55.4s    835f (35%) 95.29fps Trem:   0min   9mb  A-V:-0.011 [435:64]
  1 duplicate frame(s)!
  Pos:  55.5s    836f (35%) 95.30fps Trem:   0min   9mb  A-V:-0.018 [435:64]
  1 duplicate frame(s)!
  Pos:  55.5s    837f (35%) 95.29fps Trem:   0min   9mb  A-V:-0.013 [435:63]
  1 duplicate frame(s)!
  Pos:  55.6s    838f (35%) 95.27fps Trem:   0min   9mb  A-V:-0.007 [435:63]
  1 duplicate frame(s)!
  Pos:  55.7s    839f (35%) 95.29fps Trem:   0min   9mb  A-V:-0.002 [435:63]
  1 duplicate frame(s)!
  Pos:  55.7s    840f (35%) 95.28fps Trem:   0min   9mb  A-V:-0.005 [434:63]
  1 duplicate frame(s)!
  Pos:  55.8s    841f (35%) 95.30fps Trem:   0min   9mb  A-V:-0.012 [434:63]
  1 duplicate frame(s)!
  Pos:  55.9s    842f (35%) 95.26fps Trem:   0min   9mb  A-V:-0.005 [434:63]
  1 duplicate frame(s)!
  Pos:  55.9s    843f (35%) 95.29fps Trem:   0min   9mb  A-V:-0.003 [434:63]
  1 duplicate frame(s)!
  Pos:  56.0s    844f (35%) 95.28fps Trem:   0min   9mb  A-V:-0.009 [434:63]
  1 duplicate frame(s)!
  Pos:  56.1s    845f (36%) 95.30fps Trem:   0min   9mb  A-V:-0.003 [434:64]
  1 duplicate frame(s)!
  Pos:  56.1s    846f (36%) 95.30fps Trem:   0min   9mb  A-V:-0.005 [434:64]
  1 duplicate frame(s)!
  Pos:  56.2s    847f (36%) 95.31fps Trem:   0min   9mb  A-V:-0.012 [434:64]
  1 duplicate frame(s)!
  Pos:  56.3s    848f (36%) 95.32fps Trem:   0min   9mb  A-V:-0.006 [434:64]
  1 duplicate frame(s)!
  Pos:  56.3s    849f (36%) 95.33fps Trem:   0min   9mb  A-V:-0.010 [434:64]
  1 duplicate frame(s)!
  Pos:  56.4s    850f (36%) 95.34fps Trem:   0min   9mb  A-V:-0.016 [434:64]
  1 duplicate frame(s)!
  Pos:  56.5s    851f (36%) 95.34fps Trem:   0min   9mb  A-V:-0.010 [434:63]
  1 duplicate frame(s)!
  Pos:  56.5s    852f (36%) 95.37fps Trem:   0min   9mb  A-V:-0.008 [434:63]
  1 duplicate frame(s)!
  Pos:  56.6s    853f (36%) 95.36fps Trem:   0min   9mb  A-V:-0.014 [434:63]
  1 duplicate frame(s)!
  Pos:  56.7s    854f (36%) 95.36fps Trem:   0min   9mb  A-V:-0.021 [434:63]
  1 duplicate frame(s)!
  Pos:  56.7s    855f (36%) 95.37fps Trem:   0min   9mb  A-V:-0.015 [434:63]
  1 duplicate frame(s)!
  Pos:  56.8s    856f (36%) 95.37fps Trem:   0min   9mb  A-V:-0.018 [433:63]
  1 duplicate frame(s)!
  Pos:  56.9s    857f (36%) 95.39fps Trem:   0min   9mb  A-V:-0.025 [434:63]
  1 duplicate frame(s)!
  Pos:  56.9s    858f (36%) 95.38fps Trem:   0min   9mb  A-V:-0.018 [434:63]
  1 duplicate frame(s)!
  Pos:  57.0s    859f (36%) 95.40fps Trem:   0min   9mb  A-V:-0.015 [434:63]
  1 duplicate frame(s)!
  Pos:  57.1s    860f (36%) 95.39fps Trem:   0min   9mb  A-V:-0.008 [434:63]
  1 duplicate frame(s)!
  Pos:  57.1s    861f (36%) 95.40fps Trem:   0min   9mb  A-V:-0.004 [434:63]
  1 duplicate frame(s)!
  Pos:  57.2s    862f (36%) 95.40fps Trem:   0min   9mb  A-V:-0.010 [435:63]
  1 duplicate frame(s)!
  Pos:  57.3s    863f (36%) 95.39fps Trem:   0min   9mb  A-V:-0.017 [435:63]
  1 duplicate frame(s)!
  Pos:  57.3s    864f (36%) 95.42fps Trem:   0min   9mb  A-V:-0.011 [435:63]
  1 duplicate frame(s)!
  Pos:  57.4s    865f (36%) 95.41fps Trem:   0min   9mb  A-V:-0.014 [434:63]
  1 duplicate frame(s)!
  Pos:  57.5s    866f (36%) 95.43fps Trem:   0min   9mb  A-V:-0.020 [434:63]
  1 duplicate frame(s)!
  Pos:  57.5s    867f (36%) 95.42fps Trem:   0min   9mb  A-V:-0.017 [434:63]
  1 duplicate frame(s)!
  Pos:  57.6s    868f (36%) 95.44fps Trem:   0min   9mb  A-V:-0.017 [434:63]
  1 duplicate frame(s)!
  Pos:  57.7s    869f (36%) 95.43fps Trem:   0min   9mb  A-V:-0.024 [434:63]
  1 duplicate frame(s)!
  Pos:  57.7s    870f (37%) 95.42fps Trem:   0min   9mb  A-V:-0.017 [434:63]
  1 duplicate frame(s)!
  Pos:  57.8s    871f (37%) 95.43fps Trem:   0min   9mb  A-V:-0.015 [434:63]
  1 duplicate frame(s)!
  Pos:  57.9s    872f (37%) 95.43fps Trem:   0min   9mb  A-V:-0.009 [434:63]
  1 duplicate frame(s)!
  Pos:  57.9s    873f (37%) 95.44fps Trem:   0min   9mb  A-V:-0.006 [434:63]
  1 duplicate frame(s)!
  Pos:  58.0s    874f (37%) 95.43fps Trem:   0min   9mb  A-V:0.000 [433:63]
  1 duplicate frame(s)!
  Pos:  58.1s    875f (37%) 95.45fps Trem:   0min   9mb  A-V:0.002 [433:63]
  1 duplicate frame(s)!
  Pos:  58.1s    876f (37%) 95.45fps Trem:   0min   9mb  A-V:-0.005 [433:63]
  1 duplicate frame(s)!
  Pos:  58.2s    877f (37%) 95.44fps Trem:   0min   9mb  A-V:-0.001 [433:63]
  1 duplicate frame(s)!
  Pos:  58.3s    878f (37%) 95.46fps Trem:   0min   9mb  A-V:-0.002 [433:63]
  1 duplicate frame(s)!
  Pos:  58.3s    879f (37%) 95.44fps Trem:   0min   9mb  A-V:-0.009 [433:63]
  1 duplicate frame(s)!
  Pos:  58.4s    880f (37%) 95.46fps Trem:   0min   9mb  A-V:-0.003 [433:63]
  1 duplicate frame(s)!
  Pos:  58.5s    881f (37%) 95.43fps Trem:   0min   9mb  A-V:-0.007 [438:64]
  1 duplicate frame(s)!
  Pos:  58.5s    882f (37%) 95.45fps Trem:   0min   9mb  A-V:-0.014 [438:64]
  1 duplicate frame(s)!
  Pos:  58.6s    883f (37%) 95.45fps Trem:   0min   9mb  A-V:-0.007 [437:64]
  1 duplicate frame(s)!
  Pos:  58.7s    884f (37%) 95.47fps Trem:   0min   9mb  A-V:-0.005 [437:64]
  1 duplicate frame(s)!
  Pos:  58.7s    885f (37%) 95.48fps Trem:   0min   9mb  A-V:-0.012 [437:63]
  1 duplicate frame(s)!
  Pos:  58.8s    886f (37%) 95.47fps Trem:   0min   9mb  A-V:-0.007 [437:63]
  1 duplicate frame(s)!
  Pos:  58.9s    887f (37%) 95.49fps Trem:   0min   9mb  A-V:-0.007 [436:63]
  1 duplicate frame(s)!
  Pos:  58.9s    888f (37%) 95.49fps Trem:   0min   9mb  A-V:-0.013 [436:63]
  1 duplicate frame(s)!
  Pos:  59.0s    889f (37%) 95.51fps Trem:   0min   9mb  A-V:-0.007 [436:63]
  1 duplicate frame(s)!
  Pos:  59.1s    890f (37%) 95.50fps Trem:   0min   9mb  A-V:-0.008 [436:64]
  1 duplicate frame(s)!
  Pos:  59.1s    891f (37%) 95.52fps Trem:   0min   9mb  A-V:-0.014 [436:63]
  1 duplicate frame(s)!
  Pos:  59.2s    892f (38%) 95.51fps Trem:   0min   9mb  A-V:-0.010 [436:63]
  1 duplicate frame(s)!
  Pos:  59.3s    893f (38%) 95.51fps Trem:   0min   9mb  A-V:-0.004 [436:63]
  1 duplicate frame(s)!
  Pos:  59.3s    894f (38%) 95.51fps Trem:   0min   9mb  A-V:0.000 [436:63]
  1 duplicate frame(s)!
  Pos:  59.4s    895f (38%) 95.51fps Trem:   0min   9mb  A-V:-0.004 [436:63]
  1 duplicate frame(s)!
  Pos:  59.5s    896f (38%) 95.52fps Trem:   0min   9mb  A-V:-0.011 [436:63]
  1 duplicate frame(s)!
  Pos:  59.5s    897f (38%) 95.52fps Trem:   0min   9mb  A-V:-0.010 [437:63]
  1 duplicate frame(s)!
  Pos:  59.6s    898f (38%) 95.53fps Trem:   0min   9mb  A-V:-0.014 [436:63]
  1 duplicate frame(s)!
  Pos:  59.7s    899f (38%) 95.53fps Trem:   0min   9mb  A-V:-0.007 [436:64]
  1 duplicate frame(s)!
  Pos:  59.7s    900f (38%) 95.54fps Trem:   0min   9mb  A-V:-0.005 [436:63]
  1 duplicate frame(s)!
  Pos:  59.8s    901f (38%) 95.54fps Trem:   0min   9mb  A-V:-0.012 [436:64]
  1 duplicate frame(s)!
  Pos:  59.9s    902f (38%) 95.51fps Trem:   0min   9mb  A-V:-0.019 [437:63]
  1 duplicate frame(s)!
  Pos:  59.9s    903f (38%) 95.52fps Trem:   0min   9mb  A-V:-0.013 [437:63]
  1 duplicate frame(s)!
  Pos:  60.0s    904f (38%) 95.51fps Trem:   0min   9mb  A-V:-0.016 [436:64]
  1 duplicate frame(s)!
  Pos:  60.1s    905f (38%) 95.52fps Trem:   0min   9mb  A-V:-0.022 [436:63]
  1 duplicate frame(s)!
  Pos:  60.1s    906f (38%) 95.52fps Trem:   0min   9mb  A-V:-0.020 [436:63]
  1 duplicate frame(s)!
  Pos:  60.2s    907f (38%) 95.54fps Trem:   0min   9mb  A-V:-0.022 [436:63]
  1 duplicate frame(s)!
  Pos:  60.3s    908f (38%) 95.53fps Trem:   0min   9mb  A-V:-0.015 [436:63]
  1 duplicate frame(s)!
  Pos:  60.3s    909f (38%) 95.52fps Trem:   0min   9mb  A-V:-0.015 [436:63]
  1 duplicate frame(s)!
  Pos:  60.4s    910f (38%) 95.55fps Trem:   0min   9mb  A-V:-0.019 [436:63]
  1 duplicate frame(s)!
  Pos:  60.5s    911f (38%) 95.54fps Trem:   0min   9mb  A-V:-0.012 [436:63]
  1 duplicate frame(s)!
  Pos:  60.5s    912f (38%) 95.57fps Trem:   0min   9mb  A-V:-0.011 [436:63]
  1 duplicate frame(s)!
  Pos:  60.6s    913f (38%) 95.56fps Trem:   0min   9mb  A-V:-0.018 [436:63]
  1 duplicate frame(s)!
  Pos:  60.7s    914f (38%) 95.58fps Trem:   0min   9mb  A-V:-0.024 [436:63]
  1 duplicate frame(s)!
  Pos:  60.7s    915f (38%) 95.56fps Trem:   0min   9mb  A-V:-0.019 [436:63]
  1 duplicate frame(s)!
  Pos:  60.8s    916f (38%) 95.56fps Trem:   0min   9mb  A-V:-0.013 [436:63]
  1 duplicate frame(s)!
  Pos:  60.9s    917f (38%) 95.57fps Trem:   0min   9mb  A-V:-0.009 [436:63]
  1 duplicate frame(s)!
  Pos:  60.9s    918f (38%) 95.57fps Trem:   0min   9mb  A-V:-0.015 [436:64]
  1 duplicate frame(s)!
  Pos:  61.0s    919f (38%) 95.59fps Trem:   0min   9mb  A-V:-0.021 [436:64]
  1 duplicate frame(s)!
  Pos:  61.1s    920f (39%) 95.57fps Trem:   0min   9mb  A-V:-0.018 [436:64]
  1 duplicate frame(s)!
  Pos:  61.1s    921f (39%) 95.60fps Trem:   0min   9mb  A-V:-0.020 [436:64]
  1 duplicate frame(s)!
  Pos:  61.2s    922f (39%) 95.58fps Trem:   0min   9mb  A-V:-0.015 [436:64]
  1 duplicate frame(s)!
  Pos:  61.3s    923f (39%) 95.60fps Trem:   0min   9mb  A-V:-0.016 [436:64]
  1 duplicate frame(s)!
  Pos:  61.3s    924f (39%) 95.58fps Trem:   0min   9mb  A-V:-0.013 [436:64]
  1 duplicate frame(s)!
  Pos:  61.4s    925f (39%) 95.58fps Trem:   0min   9mb  A-V:-0.018 [436:64]
  1 duplicate frame(s)!
  Pos:  61.5s    926f (39%) 95.60fps Trem:   0min   9mb  A-V:-0.025 [437:64]
  1 duplicate frame(s)!
  Pos:  61.5s    927f (39%) 95.59fps Trem:   0min   9mb  A-V:-0.018 [436:64]
  1 duplicate frame(s)!
  Pos:  61.6s    928f (39%) 95.60fps Trem:   0min   9mb  A-V:-0.015 [437:64]
  1 duplicate frame(s)!
  Pos:  61.7s    929f (39%) 95.60fps Trem:   0min   9mb  A-V:-0.021 [436:64]
  1 duplicate frame(s)!
  Pos:  61.7s    930f (39%) 95.60fps Trem:   0min   9mb  A-V:-0.014 [437:64]
  1 duplicate frame(s)!
  Pos:  61.8s    931f (39%) 95.60fps Trem:   0min   9mb  A-V:-0.016 [437:64]
  1 duplicate frame(s)!
  Pos:  61.9s    932f (39%) 95.60fps Trem:   0min   9mb  A-V:-0.023 [436:64]
  1 duplicate frame(s)!
  Pos:  61.9s    933f (39%) 95.61fps Trem:   0min   9mb  A-V:-0.029 [436:64]
  1 duplicate frame(s)!
  Pos:  62.0s    934f (39%) 95.61fps Trem:   0min   9mb  A-V:-0.026 [436:64]
  1 duplicate frame(s)!
  Pos:  62.1s    935f (39%) 95.61fps Trem:   0min   9mb  A-V:-0.027 [436:64]
  1 duplicate frame(s)!
  Pos:  62.1s    936f (39%) 95.61fps Trem:   0min   9mb  A-V:-0.020 [436:64]
  1 duplicate frame(s)!
  Pos:  62.2s    937f (39%) 95.62fps Trem:   0min   9mb  A-V:-0.018 [436:64]
  1 duplicate frame(s)!
  Pos:  62.3s    938f (40%) 95.61fps Trem:   0min   9mb  A-V:-0.012 [436:64]
  1 duplicate frame(s)!
  Pos:  62.3s    939f (40%) 95.62fps Trem:   0min   9mb  A-V:-0.008 [436:64]
  1 duplicate frame(s)!
  Pos:  62.4s    940f (40%) 95.62fps Trem:   0min   9mb  A-V:-0.003 [436:64]
  1 duplicate frame(s)!
  Pos:  62.5s    941f (40%) 95.61fps Trem:   0min   9mb  A-V:-0.007 [436:64]
  1 duplicate frame(s)!
  Pos:  62.5s    942f (40%) 95.62fps Trem:   0min   9mb  A-V:-0.002 [436:64]
  1 duplicate frame(s)!
  Pos:  62.6s    943f (40%) 95.61fps Trem:   0min   9mb  A-V:-0.007 [436:64]
  1 duplicate frame(s)!
  Pos:  62.7s    944f (40%) 95.62fps Trem:   0min   9mb  A-V:-0.013 [436:64]
  1 duplicate frame(s)!
  Pos:  62.7s    945f (40%) 95.62fps Trem:   0min   9mb  A-V:-0.020 [436:64]
  1 duplicate frame(s)!
  Pos:  62.8s    946f (40%) 95.63fps Trem:   0min   9mb  A-V:-0.013 [436:64]
  1 duplicate frame(s)!
  Pos:  62.9s    947f (40%) 95.63fps Trem:   0min   9mb  A-V:-0.014 [436:63]
  1 duplicate frame(s)!
  Pos:  62.9s    948f (40%) 95.61fps Trem:   0min   9mb  A-V:-0.008 [436:63]
  1 duplicate frame(s)!
  Pos:  63.0s    949f (40%) 95.64fps Trem:   0min   9mb  A-V:-0.002 [436:63]
  1 duplicate frame(s)!
  Pos:  63.1s    950f (40%) 95.62fps Trem:   0min   9mb  A-V:-0.006 [436:63]
  1 duplicate frame(s)!
  Pos:  63.1s    951f (40%) 95.65fps Trem:   0min   9mb  A-V:-0.013 [436:63]
  1 duplicate frame(s)!
  Pos:  63.2s    952f (40%) 95.62fps Trem:   0min   9mb  A-V:-0.010 [436:63]
  1 duplicate frame(s)!
  Pos:  63.3s    953f (40%) 95.64fps Trem:   0min   9mb  A-V:-0.011 [436:63]
  1 duplicate frame(s)!
  Pos:  63.3s    954f (40%) 95.63fps Trem:   0min   9mb  A-V:-0.008 [437:63]
  1 duplicate frame(s)!
  Pos:  63.4s    955f (40%) 95.62fps Trem:   0min   9mb  A-V:-0.001 [437:63]
  1 duplicate frame(s)!
  Pos:  63.5s    956f (40%) 95.64fps Trem:   0min   9mb  A-V:0.002 [436:63]
  1 duplicate frame(s)!
  Pos:  63.5s    957f (40%) 95.63fps Trem:   0min   9mb  A-V:-0.004 [436:63]
  1 duplicate frame(s)!
  Pos:  63.6s    958f (40%) 95.65fps Trem:   0min   9mb  A-V:0.001 [437:63]
  1 duplicate frame(s)!
  Pos:  63.7s    959f (40%) 95.63fps Trem:   0min   9mb  A-V:-0.004 [437:63]
  1 duplicate frame(s)!
  Pos:  63.7s    960f (40%) 95.65fps Trem:   0min   9mb  A-V:0.002 [437:63]
  1 duplicate frame(s)!
  Pos:  63.8s    961f (40%) 95.63fps Trem:   0min   9mb  A-V:0.007 [437:63]
  1 duplicate frame(s)!
  Pos:  63.9s    962f (40%) 95.62fps Trem:   0min   9mb  A-V:0.007 [437:63]
  1 duplicate frame(s)!
  Pos:  63.9s    963f (40%) 95.60fps Trem:   0min   9mb  A-V:-0.000 [437:63]
  1 duplicate frame(s)!
  Pos:  64.0s    964f (40%) 95.59fps Trem:   0min   9mb  A-V:0.002 [437:63]
  1 duplicate frame(s)!
  Pos:  64.1s    965f (40%) 95.59fps Trem:   0min   9mb  A-V:-0.000 [437:63]
  1 duplicate frame(s)!
  Pos:  64.1s    966f (40%) 95.57fps Trem:   0min   9mb  A-V:0.004 [437:63]
  1 duplicate frame(s)!
  Pos:  64.2s    967f (40%) 95.58fps Trem:   0min   9mb  A-V:0.004 [437:63]
  1 duplicate frame(s)!
  Pos:  64.3s    968f (40%) 95.56fps Trem:   0min   9mb  A-V:-0.003 [437:63]
  1 duplicate frame(s)!
  Pos:  64.3s    969f (40%) 95.57fps Trem:   0min   9mb  A-V:-0.009 [437:64]
  1 duplicate frame(s)!
  Pos:  64.4s    970f (40%) 95.56fps Trem:   0min   9mb  A-V:-0.008 [437:64]
  1 duplicate frame(s)!
  Pos:  64.5s    971f (41%) 95.53fps Trem:   0min   9mb  A-V:-0.001 [437:64]
  1 duplicate frame(s)!
  Pos:  64.5s    972f (41%) 95.55fps Trem:   0min   9mb  A-V:0.003 [437:64]
  1 duplicate frame(s)!
  Pos:  64.6s    973f (41%) 95.53fps Trem:   0min   9mb  A-V:-0.002 [437:63]
  1 duplicate frame(s)!
  Pos:  64.7s    974f (41%) 95.54fps Trem:   0min   9mb  A-V:-0.008 [437:63]
  1 duplicate frame(s)!
  Pos:  64.7s    975f (41%) 95.53fps Trem:   0min   9mb  A-V:-0.015 [437:63]
  1 duplicate frame(s)!
  Pos:  64.8s    976f (41%) 95.53fps Trem:   0min   9mb  A-V:-0.008 [437:63]
  1 duplicate frame(s)!
  Pos:  64.9s    977f (41%) 95.52fps Trem:   0min   9mb  A-V:-0.010 [437:63]
  1 duplicate frame(s)!
  Pos:  64.9s    978f (41%) 95.53fps Trem:   0min   9mb  A-V:-0.016 [437:63]
  1 duplicate frame(s)!
  Pos:  65.0s    979f (41%) 95.51fps Trem:   0min   9mb  A-V:-0.009 [437:63]
  1 duplicate frame(s)!
  Pos:  65.1s    980f (41%) 95.50fps Trem:   0min   9mb  A-V:-0.010 [437:63]
  1 duplicate frame(s)!
  Pos:  65.1s    981f (41%) 95.48fps Trem:   0min   9mb  A-V:-0.014 [437:63]
  1 duplicate frame(s)!
  Pos:  65.2s    982f (41%) 95.44fps Trem:   0min   9mb  A-V:-0.008 [437:63]
  1 duplicate frame(s)!
  Pos:  65.3s    983f (41%) 95.44fps Trem:   0min   9mb  A-V:-0.006 [437:63]
  1 duplicate frame(s)!
  Pos:  65.3s    984f (41%) 95.41fps Trem:   0min   9mb  A-V:-0.013 [437:63]
  1 duplicate frame(s)!
  Pos:  65.4s    985f (41%) 95.42fps Trem:   0min   9mb  A-V:-0.019 [437:63]
  1 duplicate frame(s)!
  Pos:  65.5s    987f (41%) 95.40fps Trem:   0min   9mb  A-V:-0.013 [437:63]
  2 duplicate frame(s)!
  Pos:  65.6s    988f (41%) 95.39fps Trem:   0min   9mb  A-V:-0.013 [437:63]
  1 duplicate frame(s)!
  Pos:  65.7s    990f (41%) 95.39fps Trem:   0min   9mb  A-V:-0.010 [438:63]
  2 duplicate frame(s)!
  Pos:  65.8s    991f (41%) 95.37fps Trem:   0min   9mb  A-V:-0.014 [438:63]
  1 duplicate frame(s)!
  Pos:  65.9s    993f (42%) 95.37fps Trem:   0min   9mb  A-V:-0.009 [438:63]
  1 duplicate frame(s)!
  Pos:  66.0s    994f (42%) 95.38fps Trem:   0min   9mb  A-V:-0.015 [438:63]
  2 duplicate frame(s)!
  Pos:  66.1s    996f (42%) 95.36fps Trem:   0min   9mb  A-V:-0.021 [438:63]
  1 duplicate frame(s)!
  Pos:  66.2s    997f (42%) 95.40fps Trem:   0min   9mb  A-V:-0.021 [438:63]
  1 duplicate frame(s)!
  Pos:  66.2s    998f (42%) 95.37fps Trem:   0min   9mb  A-V:-0.028 [438:63]
  1 duplicate frame(s)!
  Pos:  66.3s    999f (42%) 95.36fps Trem:   0min   9mb  A-V:-0.025 [438:63]
  1 duplicate frame(s)!
  Pos:  66.4s   1000f (42%) 95.37fps Trem:   0min   9mb  A-V:-0.026 [438:63]
  1 duplicate frame(s)!
  Pos:  66.4s   1001f (42%) 95.35fps Trem:   0min   9mb  A-V:-0.019 [438:63]
  1 duplicate frame(s)!
  Pos:  66.5s   1002f (42%) 95.36fps Trem:   0min   9mb  A-V:-0.017 [438:63]
  1 duplicate frame(s)!
  Pos:  66.6s   1003f (42%) 95.35fps Trem:   0min   9mb  A-V:-0.010 [437:63]
  1 duplicate frame(s)!
  Pos:  66.6s   1004f (42%) 95.36fps Trem:   0min   9mb  A-V:-0.006 [438:63]
  1 duplicate frame(s)!
  Pos:  66.7s   1005f (42%) 95.35fps Trem:   0min   9mb  A-V:-0.011 [438:63]
  1 duplicate frame(s)!
  Pos:  66.8s   1006f (42%) 95.34fps Trem:   0min   9mb  A-V:-0.017 [441:63]
  1 duplicate frame(s)!
  Pos:  66.8s   1007f (42%) 95.32fps Trem:   0min   9mb  A-V:-0.011 [440:63]
  1 duplicate frame(s)!
  Pos:  66.9s   1008f (42%) 95.31fps Trem:   0min   9mb  A-V:-0.013 [440:63]
  1 duplicate frame(s)!
  Pos:  67.0s   1009f (42%) 95.32fps Trem:   0min   9mb  A-V:-0.020 [440:63]
  1 duplicate frame(s)!
  Pos:  67.0s   1010f (42%) 95.31fps Trem:   0min   9mb  A-V:-0.015 [440:63]
  1 duplicate frame(s)!
  Pos:  67.1s   1011f (42%) 95.32fps Trem:   0min   9mb  A-V:-0.009 [440:63]
  1 duplicate frame(s)!
  Pos:  67.2s   1012f (42%) 95.29fps Trem:   0min   9mb  A-V:-0.008 [440:64]
  1 duplicate frame(s)!
  Pos:  67.2s   1013f (42%) 95.29fps Trem:   0min   9mb  A-V:-0.012 [440:64]
  1 duplicate frame(s)!
  Pos:  67.3s   1014f (42%) 95.27fps Trem:   0min   9mb  A-V:-0.018 [440:64]
  1 duplicate frame(s)!
  Pos:  67.4s   1015f (43%) 95.26fps Trem:   0min   9mb  A-V:-0.016 [440:64]
  1 duplicate frame(s)!
  Pos:  67.4s   1016f (43%) 95.26fps Trem:   0min   9mb  A-V:-0.018 [440:64]
  1 duplicate frame(s)!
  Pos:  67.5s   1017f (43%) 95.27fps Trem:   0min   9mb  A-V:-0.024 [439:64]
  1 duplicate frame(s)!
  Pos:  67.6s   1018f (43%) 95.26fps Trem:   0min   9mb  A-V:-0.031 [439:64]
  1 duplicate frame(s)!
  Pos:  67.6s   1019f (43%) 95.24fps Trem:   0min   9mb  A-V:-0.025 [439:64]
  1 duplicate frame(s)!
  Pos:  67.7s   1020f (43%) 95.26fps Trem:   0min   9mb  A-V:-0.024 [439:64]
  1 duplicate frame(s)!
  Pos:  67.8s   1021f (43%) 95.24fps Trem:   0min   9mb  A-V:-0.030 [439:64]
  1 duplicate frame(s)!
  Pos:  67.8s   1022f (43%) 95.21fps Trem:   0min   9mb  A-V:-0.026 [439:64]
  1 duplicate frame(s)!
  Pos:  67.9s   1023f (43%) 95.22fps Trem:   0min   9mb  A-V:-0.027 [439:64]
  1 duplicate frame(s)!
  Pos:  68.0s   1024f (43%) 95.19fps Trem:   0min   9mb  A-V:-0.023 [439:64]
  1 duplicate frame(s)!
  Pos:  68.0s   1025f (43%) 95.21fps Trem:   0min   9mb  A-V:-0.023 [439:64]
  1 duplicate frame(s)!
  Pos:  68.1s   1026f (43%) 95.19fps Trem:   0min   9mb  A-V:-0.018 [438:64]
  1 duplicate frame(s)!
  Pos:  68.2s   1027f (43%) 95.18fps Trem:   0min   9mb  A-V:-0.017 [438:64]
  1 duplicate frame(s)!
  Pos:  68.2s   1028f (43%) 95.18fps Trem:   0min   9mb  A-V:-0.024 [438:64]
  1 duplicate frame(s)!
  Pos:  68.3s   1029f (43%) 95.18fps Trem:   0min   9mb  A-V:-0.031 [438:64]
  1 duplicate frame(s)!
  Pos:  68.4s   1030f (43%) 95.15fps Trem:   0min   9mb  A-V:-0.029 [438:64]
  1 duplicate frame(s)!
  Pos:  68.4s   1031f (43%) 95.14fps Trem:   0min   9mb  A-V:-0.036 [438:64]
  1 duplicate frame(s)!
  Pos:  68.5s   1032f (43%) 95.14fps Trem:   0min   9mb  A-V:-0.042 [438:64]
  1 duplicate frame(s)!
  Pos:  68.6s   1033f (43%) 95.13fps Trem:   0min   9mb  A-V:-0.036 [438:64]
  1 duplicate frame(s)!
  Pos:  68.6s   1034f (43%) 95.14fps Trem:   0min   9mb  A-V:-0.034 [438:64]
  1 duplicate frame(s)!
  Pos:  68.7s   1035f (43%) 95.12fps Trem:   0min   9mb  A-V:-0.027 [438:64]
  1 duplicate frame(s)!
  Pos:  68.8s   1036f (43%) 95.13fps Trem:   0min   9mb  A-V:-0.025 [438:64]
  1 duplicate frame(s)!
  Pos:  68.8s   1037f (43%) 95.09fps Trem:   0min   9mb  A-V:-0.018 [438:64]
  1 duplicate frame(s)!
  Pos:  68.9s   1038f (43%) 95.06fps Trem:   0min   9mb  A-V:-0.020 [438:64]
  1 duplicate frame(s)!
  Pos:  69.0s   1039f (43%) 95.06fps Trem:   0min   9mb  A-V:-0.025 [438:64]
  1 duplicate frame(s)!
  Pos:  69.0s   1040f (43%) 95.04fps Trem:   0min   9mb  A-V:-0.019 [438:64]
  1 duplicate frame(s)!
  Pos:  69.1s   1041f (43%) 95.05fps Trem:   0min   9mb  A-V:-0.016 [438:64]
  1 duplicate frame(s)!
  Pos:  69.2s   1042f (43%) 95.01fps Trem:   0min   9mb  A-V:-0.022 [438:63]
  1 duplicate frame(s)!
  Pos:  69.2s   1043f (43%) 95.02fps Trem:   0min   9mb  A-V:-0.029 [437:63]
  1 duplicate frame(s)!
  Pos:  69.3s   1044f (43%) 95.00fps Trem:   0min   9mb  A-V:-0.023 [437:63]
  1 duplicate frame(s)!
  Pos:  69.4s   1045f (43%) 95.02fps Trem:   0min   9mb  A-V:-0.021 [437:63]
  1 duplicate frame(s)!
  Pos:  69.4s   1046f (44%) 95.00fps Trem:   0min   9mb  A-V:-0.014 [437:63]
  1 duplicate frame(s)!
  Pos:  69.5s   1047f (44%) 94.98fps Trem:   0min   9mb  A-V:-0.017 [437:63]
  1 duplicate frame(s)!
  Pos:  69.6s   1048f (44%) 94.99fps Trem:   0min   9mb  A-V:-0.023 [437:63]
  1 duplicate frame(s)!
  Pos:  69.6s   1049f (44%) 94.98fps Trem:   0min   9mb  A-V:-0.018 [437:63]
  1 duplicate frame(s)!
  Pos:  69.7s   1050f (44%) 94.99fps Trem:   0min   9mb  A-V:-0.018 [437:63]
  1 duplicate frame(s)!
  Pos:  69.8s   1051f (44%) 94.98fps Trem:   0min   9mb  A-V:-0.011 [437:63]
  1 duplicate frame(s)!
  Pos:  69.8s   1052f (44%) 94.98fps Trem:   0min   9mb  A-V:-0.008 [437:63]
  1 duplicate frame(s)!
  Pos:  69.9s   1053f (44%) 94.98fps Trem:   0min   9mb  A-V:-0.013 [436:63]
  1 duplicate frame(s)!
  Pos:  70.0s   1054f (44%) 94.95fps Trem:   0min   9mb  A-V:-0.011 [436:63]
  1 duplicate frame(s)!
  Pos:  70.0s   1055f (44%) 94.97fps Trem:   0min   9mb  A-V:-0.014 [436:63]
  1 duplicate frame(s)!
  Pos:  70.1s   1056f (44%) 94.96fps Trem:   0min   9mb  A-V:-0.021 [436:63]
  1 duplicate frame(s)!
  Pos:  70.2s   1057f (44%) 94.96fps Trem:   0min   9mb  A-V:-0.014 [436:63]
  1 duplicate frame(s)!
  Pos:  70.2s   1058f (44%) 94.96fps Trem:   0min   9mb  A-V:-0.014 [436:63]
  1 duplicate frame(s)!
  Pos:  70.3s   1059f (44%) 94.97fps Trem:   0min   9mb  A-V:-0.018 [436:63]
  1 duplicate frame(s)!
  Pos:  70.4s   1060f (44%) 94.96fps Trem:   0min   9mb  A-V:-0.013 [436:63]
  1 duplicate frame(s)!
  Pos:  70.4s   1061f (44%) 94.94fps Trem:   0min   9mb  A-V:-0.016 [436:63]
  1 duplicate frame(s)!
  Pos:  70.5s   1062f (44%) 94.95fps Trem:   0min   9mb  A-V:-0.010 [436:63]
  1 duplicate frame(s)!
  Pos:  70.6s   1063f (44%) 94.94fps Trem:   0min   9mb  A-V:-0.012 [436:63]
  1 duplicate frame(s)!
  Pos:  70.6s   1064f (44%) 94.94fps Trem:   0min   9mb  A-V:-0.006 [436:63]
  1 duplicate frame(s)!
  Pos:  70.7s   1065f (44%) 94.93fps Trem:   0min   9mb  A-V:-0.009 [436:63]
  1 duplicate frame(s)!
  Pos:  70.8s   1066f (44%) 94.94fps Trem:   0min   9mb  A-V:-0.015 [435:63]
  1 duplicate frame(s)!
  Pos:  70.8s   1067f (45%) 94.91fps Trem:   0min   9mb  A-V:-0.012 [435:63]
  1 duplicate frame(s)!
  Pos:  70.9s   1068f (45%) 94.92fps Trem:   0min   9mb  A-V:-0.013 [435:63]
  1 duplicate frame(s)!
  Pos:  71.0s   1069f (45%) 94.90fps Trem:   0min   9mb  A-V:-0.019 [435:63]
  1 duplicate frame(s)!
  Pos:  71.0s   1070f (45%) 94.88fps Trem:   0min   9mb  A-V:-0.013 [435:63]
  1 duplicate frame(s)!
  Pos:  71.1s   1071f (45%) 94.89fps Trem:   0min   9mb  A-V:-0.012 [435:63]
  1 duplicate frame(s)!
  Pos:  71.2s   1072f (45%) 94.87fps Trem:   0min   9mb  A-V:-0.019 [435:63]
  1 duplicate frame(s)!
  Pos:  71.2s   1073f (45%) 94.87fps Trem:   0min   9mb  A-V:-0.026 [435:63]
  1 duplicate frame(s)!
  Pos:  71.3s   1074f (45%) 94.86fps Trem:   0min   9mb  A-V:-0.020 [435:63]
  1 duplicate frame(s)!
  Pos:  71.4s   1075f (45%) 94.87fps Trem:   0min   9mb  A-V:-0.020 [435:63]
  1 duplicate frame(s)!
  Pos:  71.4s   1076f (45%) 94.87fps Trem:   0min   9mb  A-V:-0.026 [434:63]
  1 duplicate frame(s)!
  Pos:  71.5s   1077f (45%) 94.85fps Trem:   0min   9mb  A-V:-0.025 [434:63]
  1 duplicate frame(s)!
  Pos:  71.6s   1078f (45%) 94.86fps Trem:   0min   9mb  A-V:-0.028 [434:63]
  1 duplicate frame(s)!
  Pos:  71.6s   1079f (45%) 94.83fps Trem:   0min   9mb  A-V:-0.021 [434:63]
  1 duplicate frame(s)!
  Pos:  71.7s   1080f (45%) 94.84fps Trem:   0min   9mb  A-V:-0.017 [434:63]
  1 duplicate frame(s)!
  Pos:  71.8s   1081f (45%) 94.81fps Trem:   0min   9mb  A-V:-0.021 [434:63]
  1 duplicate frame(s)!
  Pos:  71.8s   1082f (45%) 94.79fps Trem:   0min   9mb  A-V:-0.014 [434:63]
  1 duplicate frame(s)!
  Pos:  71.9s   1083f (45%) 94.78fps Trem:   0min   9mb  A-V:-0.013 [434:63]
  1 duplicate frame(s)!
  Pos:  72.0s   1084f (45%) 94.79fps Trem:   0min   9mb  A-V:-0.016 [434:63]
  1 duplicate frame(s)!
  Pos:  72.0s   1085f (46%) 94.74fps Trem:   0min   9mb  A-V:-0.011 [434:63]
  1 duplicate frame(s)!
  Pos:  72.1s   1086f (46%) 94.67fps Trem:   0min   9mb  A-V:-0.015 [434:63]
  1 duplicate frame(s)!
  Pos:  72.2s   1087f (46%) 94.65fps Trem:   0min   9mb  A-V:-0.009 [434:63]
  1 duplicate frame(s)!
  Pos:  72.2s   1088f (46%) 94.64fps Trem:   0min   9mb  A-V:-0.010 [434:63]
  1 duplicate frame(s)!
  Pos:  72.3s   1089f (46%) 94.65fps Trem:   0min   9mb  A-V:-0.015 [434:63]
  1 duplicate frame(s)!
  Pos:  72.4s   1090f (46%) 94.57fps Trem:   0min   9mb  A-V:-0.011 [434:63]
  1 duplicate frame(s)!
  Pos:  72.4s   1091f (46%) 94.59fps Trem:   0min   9mb  A-V:-0.013 [434:63]
  1 duplicate frame(s)!
  Pos:  72.5s   1092f (46%) 94.57fps Trem:   0min   9mb  A-V:-0.019 [434:63]
  1 duplicate frame(s)!
  Pos:  72.6s   1093f (46%) 94.52fps Trem:   0min   9mb  A-V:-0.018 [434:63]
  1 duplicate frame(s)!
  Pos:  72.6s   1094f (46%) 94.53fps Trem:   0min   9mb  A-V:-0.022 [434:63]
  1 duplicate frame(s)!
  Pos:  72.7s   1095f (46%) 94.50fps Trem:   0min   9mb  A-V:-0.028 [434:64]
  1 duplicate frame(s)!
  Pos:  72.8s   1096f (46%) 94.52fps Trem:   0min   9mb  A-V:-0.035 [434:64]
  1 duplicate frame(s)!
  Pos:  72.8s   1097f (46%) 94.50fps Trem:   0min   9mb  A-V:-0.028 [434:63]
  1 duplicate frame(s)!
  Pos:  72.9s   1098f (46%) 94.52fps Trem:   0min   9mb  A-V:-0.026 [434:63]
  1 duplicate frame(s)!
  Pos:  73.0s   1099f (46%) 94.52fps Trem:   0min   9mb  A-V:-0.033 [434:63]
  1 duplicate frame(s)!
  Pos:  73.0s   1100f (46%) 94.49fps Trem:   0min   9mb  A-V:-0.031 [434:63]
  1 duplicate frame(s)!
  Pos:  73.1s   1101f (46%) 94.35fps Trem:   0min   9mb  A-V:-0.034 [434:63]
  1 duplicate frame(s)!
  Pos:  73.2s   1102f (46%) 94.24fps Trem:   0min   9mb  A-V:-0.040 [434:63]
  1 duplicate frame(s)!
  Pos:  73.2s   1103f (46%) 94.26fps Trem:   0min   9mb  A-V:-0.034 [434:63]
  1 duplicate frame(s)!
  Pos:  73.3s   1104f (46%) 94.25fps Trem:   0min   9mb  A-V:-0.033 [434:63]
  1 duplicate frame(s)!
  Pos:  73.4s   1105f (46%) 94.24fps Trem:   0min   9mb  A-V:-0.037 [434:63]
  1 duplicate frame(s)!
  Pos:  73.4s   1106f (47%) 94.22fps Trem:   0min   9mb  A-V:-0.030 [434:63]
  1 duplicate frame(s)!
  Pos:  73.5s   1107f (47%) 94.23fps Trem:   0min   9mb  A-V:-0.028 [434:63]
  1 duplicate frame(s)!
  Pos:  73.6s   1108f (47%) 94.20fps Trem:   0min   9mb  A-V:-0.035 [434:63]
  1 duplicate frame(s)!
  Pos:  73.6s   1109f (47%) 94.17fps Trem:   0min   9mb  A-V:-0.032 [434:63]
  1 duplicate frame(s)!
  Pos:  73.7s   1110f (47%) 94.19fps Trem:   0min   9mb  A-V:-0.034 [433:63]
  1 duplicate frame(s)!
  Pos:  73.8s   1111f (47%) 94.14fps Trem:   0min   9mb  A-V:-0.027 [434:63]
  1 duplicate frame(s)!
  Pos:  73.8s   1112f (47%) 94.13fps Trem:   0min   9mb  A-V:-0.024 [434:63]
  1 duplicate frame(s)!
  Pos:  73.9s   1113f (47%) 94.11fps Trem:   0min   9mb  A-V:-0.030 [434:63]
  1 duplicate frame(s)!
  Pos:  74.0s   1114f (47%) 94.12fps Trem:   0min   9mb  A-V:-0.036 [434:63]
  1 duplicate frame(s)!
  Pos:  74.0s   1115f (47%) 94.10fps Trem:   0min   9mb  A-V:-0.030 [434:63]
  1 duplicate frame(s)!
  Pos:  74.1s   1116f (47%) 94.03fps Trem:   0min   9mb  A-V:-0.033 [433:63]
  1 duplicate frame(s)!
  Pos:  74.2s   1117f (47%) 94.02fps Trem:   0min   9mb  A-V:-0.040 [434:63]
  1 duplicate frame(s)!
  Pos:  74.2s   1118f (47%) 93.17fps Trem:   0min   9mb  A-V:-0.033 [434:63]
  1 duplicate frame(s)!
  Pos:  74.3s   1119f (47%) 93.16fps Trem:   0min   9mb  A-V:-0.028 [434:63]
  1 duplicate frame(s)!
  Pos:  74.4s   1120f (47%) 93.14fps Trem:   0min   9mb  A-V:-0.033 [433:63]
  1 duplicate frame(s)!
  Pos:  74.4s   1121f (47%) 93.12fps Trem:   0min   9mb  A-V:-0.026 [433:63]
  1 duplicate frame(s)!
  Pos:  74.5s   1122f (47%) 93.10fps Trem:   0min   9mb  A-V:-0.025 [433:63]
  1 duplicate frame(s)!
  Pos:  74.6s   1123f (47%) 93.08fps Trem:   0min   9mb  A-V:-0.028 [433:63]
  1 duplicate frame(s)!
  Pos:  74.6s   1124f (47%) 93.06fps Trem:   0min   9mb  A-V:-0.025 [433:63]
  1 duplicate frame(s)!
  Pos:  74.7s   1125f (47%) 93.04fps Trem:   0min   9mb  A-V:-0.031 [433:63]
  1 duplicate frame(s)!
  Pos:  74.8s   1126f (47%) 93.04fps Trem:   0min   9mb  A-V:-0.024 [433:63]
  1 duplicate frame(s)!
  Pos:  74.8s   1127f (47%) 93.03fps Trem:   0min   9mb  A-V:-0.024 [433:63]
  1 duplicate frame(s)!
  Pos:  74.9s   1128f (47%) 93.02fps Trem:   0min   9mb  A-V:-0.028 [434:64]
  1 duplicate frame(s)!
  Pos:  75.0s   1129f (47%) 93.00fps Trem:   0min   9mb  A-V:-0.022 [433:64]
  1 duplicate frame(s)!
  Pos:  75.0s   1130f (47%) 93.01fps Trem:   0min   9mb  A-V:-0.015 [433:63]
  1 duplicate frame(s)!
  Pos:  75.1s   1131f (47%) 92.99fps Trem:   0min   9mb  A-V:-0.018 [437:64]
  1 duplicate frame(s)!
  Pos:  75.2s   1132f (47%) 92.95fps Trem:   0min   9mb  A-V:-0.017 [437:64]
  1 duplicate frame(s)!
  Pos:  75.2s   1133f (47%) 92.97fps Trem:   0min   9mb  A-V:-0.019 [437:64]
  1 duplicate frame(s)!
  Pos:  75.3s   1134f (47%) 92.72fps Trem:   0min   9mb  A-V:-0.012 [436:64]
  1 duplicate frame(s)!
  Pos:  75.4s   1135f (47%) 92.71fps Trem:   0min   9mb  A-V:-0.009 [436:63]
  1 duplicate frame(s)!
  Pos:  75.4s   1136f (47%) 92.63fps Trem:   0min   9mb  A-V:-0.002 [436:63]
  1 duplicate frame(s)!
  Pos:  75.5s   1137f (47%) 92.63fps Trem:   0min   9mb  A-V:0.001 [436:64]
  1 duplicate frame(s)!
  Pos:  75.6s   1138f (47%) 92.60fps Trem:   0min   9mb  A-V:-0.005 [436:64]
  1 duplicate frame(s)!
  Pos:  75.6s   1139f (48%) 92.50fps Trem:   0min   9mb  A-V:-0.001 [436:64]
  1 duplicate frame(s)!
  Pos:  75.7s   1140f (48%) 92.45fps Trem:   0min   9mb  A-V:-0.001 [436:64]
  1 duplicate frame(s)!
  Pos:  75.8s   1141f (48%) 92.35fps Trem:   0min   9mb  A-V:-0.007 [436:64]
  1 duplicate frame(s)!
  Pos:  75.8s   1142f (48%) 92.33fps Trem:   0min   9mb  A-V:-0.001 [436:64]
  1 duplicate frame(s)!
  Pos:  75.9s   1143f (48%) 92.27fps Trem:   0min   9mb  A-V:-0.003 [436:64]
  1 duplicate frame(s)!
  Pos:  76.0s   1144f (48%) 92.21fps Trem:   0min   9mb  A-V:0.004 [436:63]
  1 duplicate frame(s)!
  Pos:  76.0s   1145f (48%) 92.14fps Trem:   0min   9mb  A-V:0.002 [436:63]
  1 duplicate frame(s)!
  Pos:  76.1s   1146f (48%) 92.14fps Trem:   0min   9mb  A-V:-0.005 [436:63]
  1 duplicate frame(s)!
  Pos:  76.2s   1147f (48%) 92.10fps Trem:   0min   9mb  A-V:-0.001 [436:64]
  1 duplicate frame(s)!
  Pos:  76.2s   1148f (48%) 92.04fps Trem:   0min   9mb  A-V:-0.007 [436:64]
  1 duplicate frame(s)!
  Pos:  76.3s   1149f (48%) 92.04fps Trem:   0min   9mb  A-V:-0.000 [436:64]
  1 duplicate frame(s)!
  Pos:  76.4s   1150f (48%) 92.02fps Trem:   0min   9mb  A-V:-0.003 [436:64]
  1 duplicate frame(s)!
  Pos:  76.4s   1151f (48%) 92.04fps Trem:   0min   9mb  A-V:-0.009 [436:63]
  1 duplicate frame(s)!
  Pos:  76.5s   1152f (48%) 92.02fps Trem:   0min   9mb  A-V:-0.005 [436:64]
  1 duplicate frame(s)!
  Pos:  76.6s   1153f (48%) 92.03fps Trem:   0min   9mb  A-V:-0.005 [436:63]
  1 duplicate frame(s)!
  Pos:  76.6s   1154f (48%) 92.02fps Trem:   0min   9mb  A-V:-0.002 [436:64]
  1 duplicate frame(s)!
  Pos:  76.7s   1155f (48%) 92.02fps Trem:   0min   9mb  A-V:-0.008 [436:64]
  1 duplicate frame(s)!
  Pos:  76.8s   1156f (48%) 92.03fps Trem:   0min   9mb  A-V:-0.015 [436:64]
  1 duplicate frame(s)!
  Pos:  76.8s   1157f (48%) 92.02fps Trem:   0min   9mb  A-V:-0.012 [436:64]
  1 duplicate frame(s)!
  Pos:  76.9s   1158f (48%) 92.04fps Trem:   0min   9mb  A-V:-0.015 [436:64]
  1 duplicate frame(s)!
  Pos:  77.0s   1159f (48%) 92.03fps Trem:   0min   9mb  A-V:-0.008 [436:63]
  1 duplicate frame(s)!
  Pos:  77.0s   1160f (48%) 92.03fps Trem:   0min   9mb  A-V:-0.006 [435:63]
  1 duplicate frame(s)!
  Pos:  77.1s   1161f (48%) 92.03fps Trem:   0min   9mb  A-V:0.001 [435:63]
  1 duplicate frame(s)!
  Pos:  77.2s   1162f (48%) 92.03fps Trem:   0min   9mb  A-V:0.004 [436:63]
  1 duplicate frame(s)!
  Pos:  77.2s   1163f (48%) 92.03fps Trem:   0min   9mb  A-V:-0.001 [436:63]
  1 duplicate frame(s)!
  Pos:  77.3s   1164f (49%) 92.02fps Trem:   0min   9mb  A-V:0.004 [436:63]
  1 duplicate frame(s)!
  Pos:  77.4s   1165f (49%) 92.01fps Trem:   0min   9mb  A-V:0.004 [435:64]
  1 duplicate frame(s)!
  Pos:  77.4s   1166f (49%) 92.01fps Trem:   0min   9mb  A-V:-0.003 [436:64]
  1 duplicate frame(s)!
  Pos:  77.5s   1167f (49%) 92.02fps Trem:   0min   9mb  A-V:0.004 [435:63]
  1 duplicate frame(s)!
  Pos:  77.6s   1168f (49%) 92.02fps Trem:   0min   9mb  A-V:0.002 [435:63]
  1 duplicate frame(s)!
  Pos:  77.6s   1169f (49%) 92.03fps Trem:   0min   9mb  A-V:-0.005 [435:63]
  1 duplicate frame(s)!
  Pos:  77.7s   1170f (49%) 92.02fps Trem:   0min   9mb  A-V:-0.002 [435:63]
  1 duplicate frame(s)!
  Pos:  77.8s   1171f (49%) 92.02fps Trem:   0min   9mb  A-V:-0.007 [435:63]
  1 duplicate frame(s)!
  Pos:  77.8s   1172f (49%) 92.03fps Trem:   0min   9mb  A-V:-0.014 [435:63]
  1 duplicate frame(s)!
  Pos:  77.9s   1173f (49%) 92.02fps Trem:   0min   9mb  A-V:-0.007 [435:63]
  1 duplicate frame(s)!
  Pos:  78.0s   1174f (49%) 92.04fps Trem:   0min   9mb  A-V:-0.005 [435:63]
  1 duplicate frame(s)!
  Pos:  78.0s   1175f (49%) 92.03fps Trem:   0min   9mb  A-V:-0.012 [435:63]
  1 duplicate frame(s)!
  Pos:  78.1s   1176f (49%) 92.04fps Trem:   0min   9mb  A-V:-0.005 [435:63]
  1 duplicate frame(s)!
  Pos:  78.2s   1177f (49%) 92.03fps Trem:   0min   9mb  A-V:-0.006 [435:63]
  1 duplicate frame(s)!
  Pos:  78.2s   1178f (49%) 92.01fps Trem:   0min   9mb  A-V:-0.002 [435:63]
  1 duplicate frame(s)!
  Pos:  78.3s   1179f (49%) 92.02fps Trem:   0min   9mb  A-V:-0.002 [435:63]
  1 duplicate frame(s)!
  Pos:  78.4s   1180f (49%) 92.03fps Trem:   0min   9mb  A-V:-0.008 [435:63]
  1 duplicate frame(s)!
  Pos:  78.4s   1181f (49%) 92.04fps Trem:   0min   9mb  A-V:-0.015 [435:63]
  1 duplicate frame(s)!
  Pos:  78.5s   1182f (49%) 92.03fps Trem:   0min   9mb  A-V:-0.011 [435:63]
  1 duplicate frame(s)!
  Pos:  78.6s   1183f (49%) 92.06fps Trem:   0min   9mb  A-V:-0.012 [435:63]
  1 duplicate frame(s)!
  Pos:  78.6s   1184f (49%) 92.05fps Trem:   0min   9mb  A-V:-0.019 [435:63]
  1 duplicate frame(s)!
  Pos:  78.7s   1185f (49%) 92.06fps Trem:   0min   9mb  A-V:-0.012 [435:63]
  1 duplicate frame(s)!
  Pos:  78.8s   1186f (49%) 92.07fps Trem:   0min   9mb  A-V:-0.011 [434:63]
  1 duplicate frame(s)!
  Pos:  78.8s   1187f (49%) 92.07fps Trem:   0min   9mb  A-V:-0.017 [434:63]
  1 duplicate frame(s)!
  Pos:  78.9s   1188f (50%) 92.08fps Trem:   0min   9mb  A-V:-0.011 [434:63]
  1 duplicate frame(s)!
  Pos:  79.0s   1189f (50%) 92.07fps Trem:   0min   9mb  A-V:-0.013 [434:63]
  1 duplicate frame(s)!
  Pos:  79.0s   1190f (50%) 92.09fps Trem:   0min   9mb  A-V:-0.007 [434:63]
  1 duplicate frame(s)!
  Pos:  79.1s   1191f (50%) 92.09fps Trem:   0min   9mb  A-V:-0.010 [434:63]
  1 duplicate frame(s)!
  Pos:  79.2s   1192f (50%) 92.10fps Trem:   0min   9mb  A-V:-0.003 [434:63]
  1 duplicate frame(s)!
  Pos:  79.2s   1193f (50%) 92.10fps Trem:   0min   9mb  A-V:-0.004 [434:63]
  1 duplicate frame(s)!
  Pos:  79.3s   1194f (50%) 92.09fps Trem:   0min   9mb  A-V:-0.004 [434:63]
  1 duplicate frame(s)!
  Pos:  79.4s   1195f (50%) 92.10fps Trem:   0min   9mb  A-V:-0.007 [434:63]
  1 duplicate frame(s)!
  Pos:  79.4s   1196f (50%) 92.10fps Trem:   0min   9mb  A-V:-0.014 [434:63]
  1 duplicate frame(s)!
  Pos:  79.5s   1197f (50%) 92.11fps Trem:   0min   9mb  A-V:-0.008 [434:63]
  1 duplicate frame(s)!
  Pos:  79.6s   1198f (50%) 92.10fps Trem:   0min   9mb  A-V:-0.011 [434:63]
  1 duplicate frame(s)!
  Pos:  79.6s   1199f (50%) 92.12fps Trem:   0min   9mb  A-V:-0.018 [434:63]
  1 duplicate frame(s)!
  Pos:  79.7s   1200f (50%) 92.12fps Trem:   0min   9mb  A-V:-0.011 [434:63]
  1 duplicate frame(s)!
  Pos:  79.8s   1201f (50%) 92.14fps Trem:   0min   9mb  A-V:-0.008 [434:63]
  1 duplicate frame(s)!
  Pos:  79.8s   1202f (50%) 92.12fps Trem:   0min   9mb  A-V:-0.014 [434:63]
  1 duplicate frame(s)!
  Pos:  79.9s   1203f (50%) 92.11fps Trem:   0min   9mb  A-V:-0.020 [434:63]
  1 duplicate frame(s)!
  Pos:  80.0s   1204f (50%) 92.12fps Trem:   0min   9mb  A-V:-0.014 [433:63]
  1 duplicate frame(s)!
  Pos:  80.0s   1205f (50%) 92.12fps Trem:   0min   9mb  A-V:-0.015 [433:63]
  1 duplicate frame(s)!
  Pos:  80.1s   1206f (50%) 92.13fps Trem:   0min   9mb  A-V:-0.021 [433:63]
  1 duplicate frame(s)!
  Pos:  80.2s   1207f (50%) 92.12fps Trem:   0min   9mb  A-V:-0.017 [433:63]
  1 duplicate frame(s)!
  Pos:  80.2s   1208f (50%) 92.14fps Trem:   0min   9mb  A-V:-0.019 [433:63]
  1 duplicate frame(s)!
  Pos:  80.3s   1209f (50%) 92.14fps Trem:   0min   9mb  A-V:-0.013 [433:63]
  1 duplicate frame(s)!
  Pos:  80.4s   1210f (50%) 92.13fps Trem:   0min   9mb  A-V:-0.016 [433:63]
  1 duplicate frame(s)!
  Pos:  80.4s   1211f (50%) 92.15fps Trem:   0min   9mb  A-V:-0.023 [433:63]
  1 duplicate frame(s)!
  Pos:  80.5s   1212f (51%) 92.13fps Trem:   0min   9mb  A-V:-0.021 [433:63]
  1 duplicate frame(s)!
  Pos:  80.6s   1213f (51%) 92.15fps Trem:   0min   9mb  A-V:-0.023 [433:63]
  1 duplicate frame(s)!
  Pos:  80.6s   1214f (51%) 92.14fps Trem:   0min   9mb  A-V:-0.017 [433:63]
  1 duplicate frame(s)!
  Pos:  80.7s   1215f (51%) 92.16fps Trem:   0min   9mb  A-V:-0.012 [432:63]
  1 duplicate frame(s)!
  Pos:  80.8s   1216f (51%) 92.16fps Trem:   0min   9mb  A-V:-0.017 [432:63]
  1 duplicate frame(s)!
  Pos:  80.8s   1217f (51%) 92.14fps Trem:   0min   9mb  A-V:-0.011 [432:63]
  1 duplicate frame(s)!
  Pos:  80.9s   1218f (51%) 92.16fps Trem:   0min   9mb  A-V:-0.011 [432:63]
  1 duplicate frame(s)!
  Pos:  81.0s   1219f (51%) 92.15fps Trem:   0min   9mb  A-V:-0.017 [432:63]
  1 duplicate frame(s)!
  Pos:  81.0s   1220f (51%) 92.17fps Trem:   0min   9mb  A-V:-0.011 [432:63]
  1 duplicate frame(s)!
  Pos:  81.1s   1221f (51%) 92.15fps Trem:   0min   9mb  A-V:-0.015 [432:63]
  1 duplicate frame(s)!
  Pos:  81.2s   1222f (51%) 92.16fps Trem:   0min   9mb  A-V:-0.021 [432:63]
  1 duplicate frame(s)!
  Pos:  81.2s   1223f (51%) 92.15fps Trem:   0min   9mb  A-V:-0.016 [432:63]
  1 duplicate frame(s)!
  Pos:  81.3s   1224f (51%) 92.16fps Trem:   0min   9mb  A-V:-0.015 [432:63]
  1 duplicate frame(s)!
  Pos:  81.4s   1225f (51%) 92.15fps Trem:   0min   9mb  A-V:-0.022 [432:63]
  1 duplicate frame(s)!
  Pos:  81.4s   1226f (51%) 92.14fps Trem:   0min   9mb  A-V:-0.021 [432:63]
  1 duplicate frame(s)!
  Pos:  81.5s   1227f (51%) 92.14fps Trem:   0min   9mb  A-V:-0.025 [432:63]
  1 duplicate frame(s)!
  Pos:  81.6s   1228f (51%) 92.14fps Trem:   0min   9mb  A-V:-0.020 [432:63]
  1 duplicate frame(s)!
  Pos:  81.6s   1229f (51%) 92.15fps Trem:   0min   9mb  A-V:-0.021 [432:63]
  1 duplicate frame(s)!
  Pos:  81.7s   1230f (51%) 92.15fps Trem:   0min   9mb  A-V:-0.027 [432:64]
  1 duplicate frame(s)!
  Pos:  81.8s   1231f (52%) 92.15fps Trem:   0min   9mb  A-V:-0.021 [432:64]
  1 duplicate frame(s)!
  Pos:  81.8s   1232f (52%) 92.15fps Trem:   0min   9mb  A-V:-0.020 [431:64]
  1 duplicate frame(s)!
  Pos:  81.9s   1233f (52%) 92.15fps Trem:   0min   9mb  A-V:-0.026 [431:63]
  1 duplicate frame(s)!
  Pos:  82.0s   1234f (52%) 92.16fps Trem:   0min   9mb  A-V:-0.033 [431:63]
  1 duplicate frame(s)!
  Pos:  82.0s   1235f (52%) 92.15fps Trem:   0min   9mb  A-V:-0.030 [431:63]
  1 duplicate frame(s)!
  Pos:  82.1s   1236f (52%) 92.16fps Trem:   0min   9mb  A-V:-0.032 [431:63]
  1 duplicate frame(s)!
  Pos:  82.2s   1237f (52%) 92.14fps Trem:   0min   9mb  A-V:-0.026 [431:63]
  1 duplicate frame(s)!
  Pos:  82.2s   1238f (52%) 92.15fps Trem:   0min   9mb  A-V:-0.023 [431:63]
  1 duplicate frame(s)!
  Pos:  82.3s   1239f (52%) 92.15fps Trem:   0min   9mb  A-V:-0.028 [431:63]
  1 duplicate frame(s)!
  Pos:  82.4s   1240f (52%) 92.16fps Trem:   0min   9mb  A-V:-0.035 [431:63]
  1 duplicate frame(s)!
  Pos:  82.4s   1241f (52%) 92.15fps Trem:   0min   9mb  A-V:-0.028 [431:63]
  1 duplicate frame(s)!
  Pos:  82.5s   1242f (52%) 92.15fps Trem:   0min   9mb  A-V:-0.030 [431:63]
  1 duplicate frame(s)!
  Pos:  82.6s   1243f (52%) 92.16fps Trem:   0min   9mb  A-V:-0.036 [431:63]
  1 duplicate frame(s)!
  Pos:  82.6s   1244f (52%) 92.15fps Trem:   0min   9mb  A-V:-0.030 [430:63]
  1 duplicate frame(s)!
  Pos:  82.7s   1245f (52%) 92.17fps Trem:   0min   9mb  A-V:-0.029 [430:63]
  1 duplicate frame(s)!
  Pos:  82.8s   1246f (52%) 92.16fps Trem:   0min   9mb  A-V:-0.023 [430:63]
  1 duplicate frame(s)!
  Pos:  82.8s   1247f (52%) 92.17fps Trem:   0min   9mb  A-V:-0.019 [430:63]
  1 duplicate frame(s)!
  Pos:  82.9s   1248f (52%) 92.17fps Trem:   0min   9mb  A-V:-0.024 [430:63]
  1 duplicate frame(s)!
  Pos:  83.0s   1249f (52%) 92.16fps Trem:   0min   9mb  A-V:-0.031 [430:63]
  1 duplicate frame(s)!
  Pos:  83.0s   1250f (52%) 92.17fps Trem:   0min   9mb  A-V:-0.024 [430:63]
  1 duplicate frame(s)!
  Pos:  83.1s   1251f (52%) 92.17fps Trem:   0min   9mb  A-V:-0.025 [430:63]
  1 duplicate frame(s)!
  Pos:  83.2s   1252f (52%) 92.18fps Trem:   0min   9mb  A-V:-0.030 [430:63]
  1 duplicate frame(s)!
  Pos:  83.2s   1253f (52%) 92.18fps Trem:   0min   9mb  A-V:-0.037 [430:63]
  1 duplicate frame(s)!
  Pos:  83.3s   1254f (52%) 92.19fps Trem:   0min   9mb  A-V:-0.030 [430:63]
  1 duplicate frame(s)!
  Pos:  83.4s   1255f (52%) 92.18fps Trem:   0min   9mb  A-V:-0.028 [430:63]
  1 duplicate frame(s)!
  Pos:  83.5s   1256f (52%) 92.16fps Trem:   0min   9mb  A-V:-0.035 [433:63]
  1 duplicate frame(s)!
  Pos:  83.5s   1257f (52%) 92.17fps Trem:   0min   9mb  A-V:-0.029 [432:63]
  1 duplicate frame(s)!
  Pos:  83.6s   1258f (52%) 92.17fps Trem:   0min   9mb  A-V:-0.031 [432:63]
  1 duplicate frame(s)!
  Pos:  83.7s   1259f (52%) 92.17fps Trem:   0min   9mb  A-V:-0.038 [432:63]
  1 duplicate frame(s)!
  Pos:  83.7s   1260f (53%) 92.17fps Trem:   0min   9mb  A-V:-0.034 [432:63]
  1 duplicate frame(s)!
  Pos:  83.8s   1261f (53%) 92.17fps Trem:   0min   9mb  A-V:-0.035 [432:63]
  1 duplicate frame(s)!
  Pos:  83.9s   1262f (53%) 92.15fps Trem:   0min   9mb  A-V:-0.028 [432:63]
  1 duplicate frame(s)!
  Pos:  83.9s   1263f (53%) 92.16fps Trem:   0min   9mb  A-V:-0.023 [432:63]
  1 duplicate frame(s)!
  Pos:  84.0s   1264f (53%) 92.16fps Trem:   0min   9mb  A-V:-0.027 [432:63]
  1 duplicate frame(s)!
  Pos:  84.1s   1265f (53%) 92.15fps Trem:   0min   9mb  A-V:-0.024 [432:63]
  1 duplicate frame(s)!
  Pos:  84.1s   1266f (53%) 92.17fps Trem:   0min   9mb  A-V:-0.027 [431:63]
  1 duplicate frame(s)!
  Pos:  84.2s   1267f (53%) 92.15fps Trem:   0min   9mb  A-V:-0.020 [431:63]
  1 duplicate frame(s)!
  Pos:  84.3s   1268f (53%) 92.16fps Trem:   0min   9mb  A-V:-0.018 [431:63]
  1 duplicate frame(s)!
  Pos:  84.3s   1269f (53%) 92.16fps Trem:   0min   9mb  A-V:-0.025 [431:63]
  1 duplicate frame(s)!
  Pos:  84.4s   1270f (53%) 92.18fps Trem:   0min   9mb  A-V:-0.018 [431:63]
  1 duplicate frame(s)!
  Pos:  84.5s   1271f (53%) 92.16fps Trem:   0min   9mb  A-V:-0.018 [431:63]
  1 duplicate frame(s)!
  Pos:  84.5s   1272f (53%) 92.16fps Trem:   0min   9mb  A-V:-0.014 [431:63]
  1 duplicate frame(s)!
  Pos:  84.6s   1273f (53%) 92.17fps Trem:   0min   9mb  A-V:-0.014 [431:63]
  1 duplicate frame(s)!
  Pos:  84.7s   1274f (53%) 92.17fps Trem:   0min   9mb  A-V:-0.021 [431:63]
  1 duplicate frame(s)!
  Pos:  84.7s   1275f (53%) 92.18fps Trem:   0min   9mb  A-V:-0.028 [431:63]
  1 duplicate frame(s)!
  Pos:  84.8s   1276f (53%) 92.18fps Trem:   0min   9mb  A-V:-0.025 [431:63]
  1 duplicate frame(s)!
  Pos:  84.9s   1277f (53%) 92.19fps Trem:   0min   9mb  A-V:-0.026 [431:63]
  1 duplicate frame(s)!
  Pos:  84.9s   1278f (53%) 92.17fps Trem:   0min   9mb  A-V:-0.020 [431:63]
  1 duplicate frame(s)!
  Pos:  85.0s   1279f (53%) 92.19fps Trem:   0min   9mb  A-V:-0.019 [431:63]
  1 duplicate frame(s)!
  Pos:  85.1s   1280f (53%) 92.19fps Trem:   0min   9mb  A-V:-0.026 [431:63]
  1 duplicate frame(s)!
  Pos:  85.1s   1281f (53%) 92.18fps Trem:   0min   9mb  A-V:-0.025 [431:64]
  1 duplicate frame(s)!
  Pos:  85.2s   1282f (53%) 92.19fps Trem:   0min   9mb  A-V:-0.028 [431:64]
  1 duplicate frame(s)!
  Pos:  85.3s   1283f (53%) 92.18fps Trem:   0min   9mb  A-V:-0.022 [431:63]
  1 duplicate frame(s)!
  Pos:  85.3s   1284f (53%) 92.19fps Trem:   0min   9mb  A-V:-0.017 [431:63]
  1 duplicate frame(s)!
  Pos:  85.4s   1285f (53%) 92.19fps Trem:   0min   9mb  A-V:-0.022 [431:63]
  1 duplicate frame(s)!
  Pos:  85.5s   1286f (53%) 92.19fps Trem:   0min   9mb  A-V:-0.015 [431:63]
  1 duplicate frame(s)!
  Pos:  85.5s   1287f (53%) 92.18fps Trem:   0min   9mb  A-V:-0.014 [431:64]
  1 duplicate frame(s)!
  Pos:  85.6s   1288f (54%) 92.17fps Trem:   0min   9mb  A-V:-0.010 [431:64]
  1 duplicate frame(s)!
  Pos:  85.7s   1289f (54%) 92.18fps Trem:   0min   9mb  A-V:-0.011 [431:64]
  1 duplicate frame(s)!
  Pos:  85.7s   1290f (54%) 92.18fps Trem:   0min   9mb  A-V:-0.006 [431:64]
  1 duplicate frame(s)!
  Pos:  85.8s   1291f (54%) 92.18fps Trem:   0min   9mb  A-V:-0.006 [431:64]
  1 duplicate frame(s)!
  Pos:  85.9s   1292f (54%) 92.18fps Trem:   0min   9mb  A-V:-0.013 [431:64]
  1 duplicate frame(s)!
  Pos:  85.9s   1293f (54%) 92.19fps Trem:   0min   9mb  A-V:-0.019 [431:64]
  1 duplicate frame(s)!
  Pos:  86.0s   1294f (54%) 92.18fps Trem:   0min   9mb  A-V:-0.016 [431:64]
  1 duplicate frame(s)!
  Pos:  86.1s   1295f (54%) 92.17fps Trem:   0min   9mb  A-V:-0.021 [431:64]
  1 duplicate frame(s)!
  Pos:  86.1s   1296f (54%) 92.18fps Trem:   0min   9mb  A-V:-0.028 [430:64]
  1 duplicate frame(s)!
  Pos:  86.2s   1297f (54%) 92.18fps Trem:   0min   9mb  A-V:-0.024 [430:64]
  1 duplicate frame(s)!
  Pos:  86.3s   1298f (54%) 92.19fps Trem:   0min   9mb  A-V:-0.025 [430:64]
  1 duplicate frame(s)!
  Pos:  86.3s   1299f (54%) 92.19fps Trem:   0min   9mb  A-V:-0.032 [430:64]
  1 duplicate frame(s)!
  Pos:  86.4s   1300f (54%) 92.19fps Trem:   0min   9mb  A-V:-0.025 [430:64]
  1 duplicate frame(s)!
  Pos:  86.5s   1301f (54%) 92.19fps Trem:   0min   9mb  A-V:-0.025 [430:64]
  1 duplicate frame(s)!
  Pos:  86.5s   1302f (54%) 92.20fps Trem:   0min   9mb  A-V:-0.019 [430:64]
  1 duplicate frame(s)!
  Pos:  86.6s   1303f (54%) 92.19fps Trem:   0min   9mb  A-V:-0.019 [430:64]
  1 duplicate frame(s)!
  Pos:  86.7s   1304f (54%) 92.19fps Trem:   0min   9mb  A-V:-0.026 [430:64]
  1 duplicate frame(s)!
  Pos:  86.7s   1305f (54%) 92.19fps Trem:   0min   9mb  A-V:-0.019 [430:64]
  1 duplicate frame(s)!
  Pos:  86.8s   1306f (54%) 92.19fps Trem:   0min   9mb  A-V:-0.021 [430:64]
  1 duplicate frame(s)!
  Pos:  86.9s   1307f (54%) 92.20fps Trem:   0min   9mb  A-V:-0.026 [430:64]
  1 duplicate frame(s)!
  Pos:  86.9s   1308f (55%) 92.17fps Trem:   0min   9mb  A-V:-0.021 [430:64]
  1 duplicate frame(s)!
  Pos:  87.0s   1309f (55%) 92.16fps Trem:   0min   9mb  A-V:-0.020 [430:64]
  1 duplicate frame(s)!
  Pos:  87.1s   1310f (55%) 92.15fps Trem:   0min   9mb  A-V:-0.017 [430:64]
  1 duplicate frame(s)!
  Pos:  87.1s   1311f (55%) 92.15fps Trem:   0min   9mb  A-V:-0.022 [430:64]
  1 duplicate frame(s)!
  Pos:  87.2s   1312f (55%) 92.15fps Trem:   0min   9mb  A-V:-0.029 [430:63]
  1 duplicate frame(s)!
  Pos:  87.3s   1313f (55%) 92.14fps Trem:   0min   9mb  A-V:-0.026 [430:63]
  1 duplicate frame(s)!
  Pos:  87.3s   1314f (55%) 92.13fps Trem:   0min   9mb  A-V:-0.028 [430:63]
  1 duplicate frame(s)!
  Pos:  87.4s   1315f (55%) 92.11fps Trem:   0min   9mb  A-V:-0.034 [430:64]
  1 duplicate frame(s)!
  Pos:  87.5s   1316f (55%) 92.07fps Trem:   0min   9mb  A-V:-0.028 [430:63]
  1 duplicate frame(s)!
  Pos:  87.5s   1317f (55%) 92.05fps Trem:   0min   9mb  A-V:-0.026 [430:63]
  1 duplicate frame(s)!
  Pos:  87.6s   1318f (55%) 92.05fps Trem:   0min   9mb  A-V:-0.029 [430:63]
  1 duplicate frame(s)!
  Pos:  87.7s   1319f (55%) 92.04fps Trem:   0min   9mb  A-V:-0.036 [430:63]
  1 duplicate frame(s)!
  Pos:  87.7s   1320f (55%) 92.04fps Trem:   0min   9mb  A-V:-0.033 [430:63]
  1 duplicate frame(s)!
  Pos:  87.8s   1321f (55%) 92.05fps Trem:   0min   9mb  A-V:-0.035 [430:63]
  1 duplicate frame(s)!
  Pos:  87.9s   1322f (55%) 92.02fps Trem:   0min   9mb  A-V:-0.028 [430:63]
  1 duplicate frame(s)!
  Pos:  87.9s   1323f (55%) 92.03fps Trem:   0min   9mb  A-V:-0.024 [430:63]
  1 duplicate frame(s)!
  Pos:  88.0s   1324f (55%) 92.02fps Trem:   0min   9mb  A-V:-0.029 [430:63]
  1 duplicate frame(s)!
  Pos:  88.1s   1325f (55%) 92.03fps Trem:   0min   9mb  A-V:-0.036 [430:63]
  1 duplicate frame(s)!
  Pos:  88.1s   1326f (55%) 92.02fps Trem:   0min   9mb  A-V:-0.030 [430:63]
  1 duplicate frame(s)!
  Pos:  88.2s   1327f (55%) 92.00fps Trem:   0min   9mb  A-V:-0.034 [430:63]
  1 duplicate frame(s)!
  Pos:  88.3s   1328f (55%) 92.02fps Trem:   0min   9mb  A-V:-0.041 [430:63]
  1 duplicate frame(s)!
  Pos:  88.3s   1329f (56%) 92.01fps Trem:   0min   9mb  A-V:-0.037 [430:63]
  1 duplicate frame(s)!
  Pos:  88.4s   1330f (56%) 92.02fps Trem:   0min   9mb  A-V:-0.037 [430:63]
  1 duplicate frame(s)!
  Pos:  88.5s   1331f (56%) 92.02fps Trem:   0min   9mb  A-V:-0.032 [430:63]
  1 duplicate frame(s)!
  Pos:  88.5s   1332f (56%) 92.03fps Trem:   0min   9mb  A-V:-0.032 [430:63]
  1 duplicate frame(s)!
  Pos:  88.6s   1333f (56%) 92.03fps Trem:   0min   9mb  A-V:-0.038 [430:63]
  1 duplicate frame(s)!
  Pos:  88.7s   1334f (56%) 92.03fps Trem:   0min   9mb  A-V:-0.032 [430:63]
  1 duplicate frame(s)!
  Pos:  88.7s   1335f (56%) 92.04fps Trem:   0min   9mb  A-V:-0.029 [430:63]
  1 duplicate frame(s)!
  Pos:  88.8s   1336f (56%) 92.03fps Trem:   0min   9mb  A-V:-0.035 [430:63]
  1 duplicate frame(s)!
  Pos:  88.9s   1337f (56%) 92.04fps Trem:   0min   9mb  A-V:-0.028 [430:63]
  1 duplicate frame(s)!
  Pos:  88.9s   1338f (56%) 92.03fps Trem:   0min   9mb  A-V:-0.029 [430:63]
  1 duplicate frame(s)!
  Pos:  89.0s   1339f (56%) 92.05fps Trem:   0min   9mb  A-V:-0.033 [429:63]
  1 duplicate frame(s)!
  Pos:  89.1s   1340f (56%) 92.04fps Trem:   0min   9mb  A-V:-0.026 [430:63]
  1 duplicate frame(s)!
  Pos:  89.1s   1341f (56%) 92.06fps Trem:   0min   9mb  A-V:-0.020 [430:63]
  1 duplicate frame(s)!
  Pos:  89.2s   1342f (56%) 92.05fps Trem:   0min   9mb  A-V:-0.024 [429:63]
  1 duplicate frame(s)!
  Pos:  89.3s   1343f (56%) 92.04fps Trem:   0min   9mb  A-V:-0.019 [430:63]
  1 duplicate frame(s)!
  Pos:  89.3s   1344f (56%) 92.05fps Trem:   0min   9mb  A-V:-0.018 [429:63]
  1 duplicate frame(s)!
  Pos:  89.4s   1345f (56%) 92.05fps Trem:   0min   9mb  A-V:-0.025 [429:63]
  1 duplicate frame(s)!
  Pos:  89.5s   1346f (56%) 92.06fps Trem:   0min   9mb  A-V:-0.018 [429:63]
  1 duplicate frame(s)!
  Pos:  89.5s   1347f (56%) 92.05fps Trem:   0min   9mb  A-V:-0.019 [430:63]
  1 duplicate frame(s)!
  Pos:  89.6s   1348f (57%) 92.05fps Trem:   0min   9mb  A-V:-0.013 [429:63]
  1 duplicate frame(s)!
  Pos:  89.7s   1349f (57%) 92.04fps Trem:   0min   9mb  A-V:-0.013 [429:63]
  1 duplicate frame(s)!
  Pos:  89.7s   1350f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.019 [429:63]
  1 duplicate frame(s)!
  Pos:  89.8s   1351f (57%) 92.04fps Trem:   0min   9mb  A-V:-0.026 [429:63]
  1 duplicate frame(s)!
  Pos:  89.9s   1352f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.024 [429:63]
  1 duplicate frame(s)!
  Pos:  89.9s   1353f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.026 [429:63]
  1 duplicate frame(s)!
  Pos:  90.0s   1354f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.032 [429:63]
  1 duplicate frame(s)!
  Pos:  90.1s   1355f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.026 [429:63]
  1 duplicate frame(s)!
  Pos:  90.1s   1356f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.025 [429:63]
  1 duplicate frame(s)!
  Pos:  90.2s   1357f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.018 [429:63]
  1 duplicate frame(s)!
  Pos:  90.3s   1358f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.018 [429:64]
  1 duplicate frame(s)!
  Pos:  90.3s   1359f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.013 [429:64]
  1 duplicate frame(s)!
  Pos:  90.4s   1360f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.013 [429:64]
  1 duplicate frame(s)!
  Pos:  90.5s   1361f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.020 [429:64]
  1 duplicate frame(s)!
  Pos:  90.5s   1362f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.013 [429:64]
  1 duplicate frame(s)!
  Pos:  90.6s   1363f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.014 [429:64]
  1 duplicate frame(s)!
  Pos:  90.7s   1364f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.019 [429:64]
  1 duplicate frame(s)!
  Pos:  90.7s   1365f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.014 [429:64]
  1 duplicate frame(s)!
  Pos:  90.8s   1366f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.019 [429:64]
  1 duplicate frame(s)!
  Pos:  90.9s   1367f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.025 [429:64]
  1 duplicate frame(s)!
  Pos:  90.9s   1368f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.023 [429:64]
  1 duplicate frame(s)!
  Pos:  91.0s   1369f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.025 [429:64]
  1 duplicate frame(s)!
  Pos:  91.1s   1370f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.018 [429:64]
  1 duplicate frame(s)!
  Pos:  91.1s   1371f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.015 [429:64]
  1 duplicate frame(s)!
  Pos:  91.2s   1372f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.021 [429:64]
  1 duplicate frame(s)!
  Pos:  91.3s   1373f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.016 [429:64]
  1 duplicate frame(s)!
  Pos:  91.3s   1374f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.015 [429:64]
  1 duplicate frame(s)!
  Pos:  91.4s   1375f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.022 [429:64]
  1 duplicate frame(s)!
  Pos:  91.5s   1376f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.015 [429:64]
  1 duplicate frame(s)!
  Pos:  91.5s   1377f (57%) 92.01fps Trem:   0min   9mb  A-V:-0.017 [429:64]
  1 duplicate frame(s)!
  Pos:  91.6s   1378f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.023 [429:64]
  1 duplicate frame(s)!
  Pos:  91.7s   1379f (57%) 92.02fps Trem:   0min   9mb  A-V:-0.019 [429:64]
  1 duplicate frame(s)!
  Pos:  91.7s   1380f (57%) 92.03fps Trem:   0min   9mb  A-V:-0.019 [429:64]
  1 duplicate frame(s)!
  Pos:  91.8s   1381f (57%) 92.01fps Trem:   0min   9mb  A-V:-0.015 [431:64]
  1 duplicate frame(s)!
  Pos:  91.9s   1382f (57%) 92.00fps Trem:   0min   9mb  A-V:-0.019 [431:64]
  1 duplicate frame(s)!
  Pos:  91.9s   1383f (58%) 92.00fps Trem:   0min   9mb  A-V:-0.014 [431:64]
  1 duplicate frame(s)!
  Pos:  92.0s   1384f (58%) 92.00fps Trem:   0min   9mb  A-V:-0.018 [431:64]
  1 duplicate frame(s)!
  Pos:  92.1s   1385f (58%) 92.01fps Trem:   0min   9mb  A-V:-0.025 [431:64]
  1 duplicate frame(s)!
  Pos:  92.1s   1386f (58%) 92.01fps Trem:   0min   9mb  A-V:-0.021 [431:64]
  1 duplicate frame(s)!
  Pos:  92.2s   1387f (58%) 92.02fps Trem:   0min   9mb  A-V:-0.022 [431:64]
  1 duplicate frame(s)!
  Pos:  92.3s   1388f (58%) 92.03fps Trem:   0min   9mb  A-V:-0.029 [431:64]
  1 duplicate frame(s)!
  Pos:  92.3s   1389f (58%) 92.03fps Trem:   0min   9mb  A-V:-0.023 [431:64]
  1 duplicate frame(s)!
  Pos:  92.4s   1390f (58%) 92.05fps Trem:   0min   9mb  A-V:-0.022 [431:64]
  1 duplicate frame(s)!
  Pos:  92.5s   1391f (58%) 92.05fps Trem:   0min   9mb  A-V:-0.029 [431:63]
  1 duplicate frame(s)!
  Pos:  92.5s   1392f (58%) 92.06fps Trem:   0min   9mb  A-V:-0.022 [431:63]
  1 duplicate frame(s)!
  Pos:  92.6s   1393f (58%) 92.06fps Trem:   0min   9mb  A-V:-0.025 [431:63]
  1 duplicate frame(s)!
  Pos:  92.7s   1394f (58%) 92.07fps Trem:   0min   9mb  A-V:-0.032 [431:63]
  1 duplicate frame(s)!
  Pos:  92.7s   1395f (58%) 92.06fps Trem:   0min   9mb  A-V:-0.025 [431:63]
  1 duplicate frame(s)!
  Pos:  92.8s   1396f (58%) 92.08fps Trem:   0min   9mb  A-V:-0.022 [430:63]
  1 duplicate frame(s)!
  Pos:  92.9s   1397f (58%) 92.08fps Trem:   0min   9mb  A-V:-0.027 [430:63]
  1 duplicate frame(s)!
  Pos:  92.9s   1398f (58%) 92.08fps Trem:   0min   9mb  A-V:-0.034 [430:63]
  1 duplicate frame(s)!
  Pos:  93.0s   1399f (58%) 92.09fps Trem:   0min   9mb  A-V:-0.027 [430:63]
  1 duplicate frame(s)!
  Pos:  93.1s   1400f (58%) 92.09fps Trem:   0min   9mb  A-V:-0.029 [430:63]
  1 duplicate frame(s)!
  Pos:  93.1s   1401f (58%) 92.09fps Trem:   0min   9mb  A-V:-0.022 [430:63]
  1 duplicate frame(s)!
  Pos:  93.2s   1402f (58%) 92.09fps Trem:   0min   9mb  A-V:-0.022 [430:63]
  1 duplicate frame(s)!
  Pos:  93.3s   1403f (59%) 92.10fps Trem:   0min   9mb  A-V:-0.016 [430:63]
  1 duplicate frame(s)!
  Pos:  93.3s   1404f (59%) 92.10fps Trem:   0min   9mb  A-V:-0.015 [430:63]
  1 duplicate frame(s)!
  Pos:  93.4s   1405f (59%) 92.09fps Trem:   0min   9mb  A-V:-0.022 [430:63]
  1 duplicate frame(s)!
  Pos:  93.5s   1406f (59%) 92.11fps Trem:   0min   9mb  A-V:-0.029 [430:63]
  1 duplicate frame(s)!
  Pos:  93.5s   1407f (59%) 92.11fps Trem:   0min   9mb  A-V:-0.027 [430:63]
  1 duplicate frame(s)!
  Pos:  93.6s   1408f (59%) 92.12fps Trem:   0min   9mb  A-V:-0.030 [430:63]
  1 duplicate frame(s)!
  Pos:  93.7s   1409f (59%) 92.12fps Trem:   0min   9mb  A-V:-0.024 [429:63]
  1 duplicate frame(s)!
  Pos:  93.7s   1410f (59%) 92.13fps Trem:   0min   9mb  A-V:-0.019 [429:63]
  1 duplicate frame(s)!
  Pos:  93.8s   1411f (59%) 92.13fps Trem:   0min   9mb  A-V:-0.024 [429:63]
  1 duplicate frame(s)!
  Pos:  93.9s   1412f (59%) 92.13fps Trem:   0min   9mb  A-V:-0.018 [429:63]
  1 duplicate frame(s)!
  Pos:  93.9s   1413f (59%) 92.14fps Trem:   0min   9mb  A-V:-0.018 [429:63]
  1 duplicate frame(s)!
  Pos:  94.0s   1414f (59%) 92.14fps Trem:   0min   9mb  A-V:-0.024 [429:63]
  1 duplicate frame(s)!
  Pos:  94.1s   1415f (59%) 92.14fps Trem:   0min   9mb  A-V:-0.017 [429:63]
  1 duplicate frame(s)!
  Pos:  94.1s   1416f (59%) 92.14fps Trem:   0min   9mb  A-V:-0.020 [429:63]
  1 duplicate frame(s)!
  Pos:  94.2s   1417f (59%) 92.16fps Trem:   0min   9mb  A-V:-0.026 [429:63]
  1 duplicate frame(s)!
  Pos:  94.3s   1418f (59%) 92.16fps Trem:   0min   9mb  A-V:-0.021 [429:63]
  1 duplicate frame(s)!
  Pos:  94.3s   1419f (59%) 92.17fps Trem:   0min   9mb  A-V:-0.021 [429:63]
  1 duplicate frame(s)!
  Pos:  94.4s   1420f (59%) 92.15fps Trem:   0min   9mb  A-V:-0.015 [429:63]
  1 duplicate frame(s)!
  Pos:  94.5s   1421f (59%) 92.15fps Trem:   0min   9mb  A-V:-0.014 [429:63]
  1 duplicate frame(s)!
  Pos:  94.5s   1422f (59%) 92.16fps Trem:   0min   9mb  A-V:-0.018 [429:63]
  1 duplicate frame(s)!
  Pos:  94.6s   1423f (59%) 92.15fps Trem:   0min   9mb  A-V:-0.018 [429:63]
  1 duplicate frame(s)!
  Pos:  94.7s   1424f (59%) 92.16fps Trem:   0min   9mb  A-V:-0.022 [429:63]
  1 duplicate frame(s)!
  Pos:  94.7s   1425f (59%) 92.15fps Trem:   0min   9mb  A-V:-0.018 [429:63]
  1 duplicate frame(s)!
  Pos:  94.8s   1426f (59%) 92.15fps Trem:   0min   9mb  A-V:-0.019 [428:63]
  1 duplicate frame(s)!
  Pos:  94.9s   1427f (59%) 92.15fps Trem:   0min   9mb  A-V:-0.012 [428:63]
  1 duplicate frame(s)!
  Pos:  94.9s   1428f (59%) 92.15fps Trem:   0min   9mb  A-V:-0.014 [428:63]
  1 duplicate frame(s)!
  Pos:  95.0s   1429f (60%) 92.16fps Trem:   0min   9mb  A-V:-0.007 [428:63]
  1 duplicate frame(s)!
  Pos:  95.1s   1430f (60%) 92.16fps Trem:   0min   9mb  A-V:-0.007 [428:63]
  1 duplicate frame(s)!
  Pos:  95.1s   1431f (60%) 92.17fps Trem:   0min   9mb  A-V:-0.011 [428:63]
  1 duplicate frame(s)!
  Pos:  95.2s   1432f (60%) 92.17fps Trem:   0min   9mb  A-V:-0.006 [428:63]
  1 duplicate frame(s)!
  Pos:  95.3s   1433f (60%) 92.18fps Trem:   0min   9mb  A-V:-0.006 [428:63]
  1 duplicate frame(s)!
  Pos:  95.3s   1434f (60%) 92.18fps Trem:   0min   9mb  A-V:-0.013 [428:63]
  1 duplicate frame(s)!
  Pos:  95.4s   1435f (60%) 92.19fps Trem:   0min   9mb  A-V:-0.006 [428:63]
  1 duplicate frame(s)!
  Pos:  95.5s   1436f (60%) 92.19fps Trem:   0min   9mb  A-V:-0.007 [428:63]
  1 duplicate frame(s)!
  Pos:  95.5s   1437f (60%) 92.19fps Trem:   0min   9mb  A-V:-0.014 [428:63]
  1 duplicate frame(s)!
  Pos:  95.6s   1438f (60%) 92.20fps Trem:   0min   9mb  A-V:-0.008 [427:63]
  1 duplicate frame(s)!
  Pos:  95.7s   1439f (60%) 92.20fps Trem:   0min   9mb  A-V:-0.011 [427:63]
  1 duplicate frame(s)!
  Pos:  95.7s   1440f (60%) 92.21fps Trem:   0min   9mb  A-V:-0.018 [427:63]
  1 duplicate frame(s)!
  Pos:  95.8s   1441f (60%) 92.20fps Trem:   0min   9mb  A-V:-0.015 [427:63]
  1 duplicate frame(s)!
  Pos:  95.9s   1442f (60%) 92.20fps Trem:   0min   9mb  A-V:-0.017 [427:63]
  1 duplicate frame(s)!
  Pos:  95.9s   1443f (60%) 92.20fps Trem:   0min   9mb  A-V:-0.023 [427:64]
  1 duplicate frame(s)!
  Pos:  96.0s   1444f (60%) 92.20fps Trem:   0min   9mb  A-V:-0.017 [427:63]
  1 duplicate frame(s)!
  Pos:  96.1s   1445f (60%) 92.21fps Trem:   0min   9mb  A-V:-0.015 [427:63]
  1 duplicate frame(s)!
  Pos:  96.1s   1446f (60%) 92.21fps Trem:   0min   9mb  A-V:-0.011 [427:63]
  1 duplicate frame(s)!
  Pos:  96.2s   1447f (60%) 92.22fps Trem:   0min   9mb  A-V:-0.011 [427:63]
  1 duplicate frame(s)!
  Pos:  96.3s   1448f (60%) 92.22fps Trem:   0min   9mb  A-V:-0.018 [427:63]
  1 duplicate frame(s)!
  Pos:  96.3s   1449f (60%) 92.23fps Trem:   0min   9mb  A-V:-0.024 [427:63]
  1 duplicate frame(s)!
  Pos:  96.4s   1450f (60%) 92.23fps Trem:   0min   9mb  A-V:-0.019 [427:63]
  1 duplicate frame(s)!
  Pos:  96.5s   1451f (60%) 92.23fps Trem:   0min   9mb  A-V:-0.023 [427:63]
  1 duplicate frame(s)!
  Pos:  96.5s   1452f (61%) 92.23fps Trem:   0min   9mb  A-V:-0.016 [427:63]
  1 duplicate frame(s)!
  Pos:  96.6s   1453f (61%) 92.24fps Trem:   0min   9mb  A-V:-0.016 [427:63]
  1 duplicate frame(s)!
  Pos:  96.7s   1454f (61%) 92.25fps Trem:   0min   9mb  A-V:-0.019 [427:63]
  1 duplicate frame(s)!
  Pos:  96.7s   1455f (61%) 92.23fps Trem:   0min   9mb  A-V:-0.013 [427:64]
  1 duplicate frame(s)!
  Pos:  96.8s   1456f (61%) 92.25fps Trem:   0min   9mb  A-V:-0.010 [427:63]
  1 duplicate frame(s)!
  Pos:  96.9s   1457f (61%) 92.25fps Trem:   0min   9mb  A-V:-0.017 [427:63]
  1 duplicate frame(s)!
  Pos:  96.9s   1458f (61%) 92.26fps Trem:   0min   9mb  A-V:-0.010 [426:63]
  1 duplicate frame(s)!
  Pos:  97.0s   1459f (61%) 92.26fps Trem:   0min   9mb  A-V:-0.010 [426:63]
  1 duplicate frame(s)!
  Pos:  97.1s   1460f (61%) 92.26fps Trem:   0min   9mb  A-V:-0.017 [426:63]
  1 duplicate frame(s)!
  Pos:  97.1s   1461f (61%) 92.27fps Trem:   0min   9mb  A-V:-0.023 [426:63]
  1 duplicate frame(s)!
  Pos:  97.2s   1462f (61%) 92.26fps Trem:   0min   9mb  A-V:-0.021 [426:63]
  1 duplicate frame(s)!
  Pos:  97.3s   1463f (61%) 92.27fps Trem:   0min   9mb  A-V:-0.023 [426:63]
  1 duplicate frame(s)!
  Pos:  97.3s   1464f (61%) 92.27fps Trem:   0min   9mb  A-V:-0.029 [426:63]
  1 duplicate frame(s)!
  Pos:  97.4s   1465f (61%) 92.28fps Trem:   0min   9mb  A-V:-0.023 [426:63]
  1 duplicate frame(s)!
  Pos:  97.5s   1466f (61%) 92.28fps Trem:   0min   9mb  A-V:-0.024 [426:63]
  1 duplicate frame(s)!
  Pos:  97.5s   1467f (61%) 92.27fps Trem:   0min   9mb  A-V:-0.018 [426:63]
  1 duplicate frame(s)!
  Pos:  97.6s   1468f (61%) 92.29fps Trem:   0min   9mb  A-V:-0.012 [426:63]
  1 duplicate frame(s)!
  Pos:  97.7s   1469f (61%) 92.29fps Trem:   0min   9mb  A-V:-0.016 [426:63]
  1 duplicate frame(s)!
  Pos:  97.7s   1470f (61%) 92.30fps Trem:   0min   9mb  A-V:-0.022 [426:63]
  1 duplicate frame(s)!
  Pos:  97.8s   1471f (61%) 92.30fps Trem:   0min   9mb  A-V:-0.016 [426:63]
  1 duplicate frame(s)!
  Pos:  97.9s   1472f (61%) 92.31fps Trem:   0min   9mb  A-V:-0.015 [426:63]
  1 duplicate frame(s)!
  Pos:  97.9s   1473f (62%) 92.30fps Trem:   0min   9mb  A-V:-0.008 [426:63]
  1 duplicate frame(s)!
  Pos:  98.0s   1474f (62%) 92.32fps Trem:   0min   9mb  A-V:-0.005 [426:63]
  1 duplicate frame(s)!
  Pos:  98.1s   1475f (62%) 92.31fps Trem:   0min   9mb  A-V:-0.011 [426:63]
  1 duplicate frame(s)!
  Pos:  98.1s   1476f (62%) 92.31fps Trem:   0min   9mb  A-V:-0.018 [426:63]
  1 duplicate frame(s)!
  Pos:  98.2s   1477f (62%) 92.31fps Trem:   0min   9mb  A-V:-0.012 [426:63]
  1 duplicate frame(s)!
  Pos:  98.3s   1478f (62%) 92.31fps Trem:   0min   9mb  A-V:-0.015 [426:63]
  1 duplicate frame(s)!
  Pos:  98.3s   1479f (62%) 92.32fps Trem:   0min   9mb  A-V:-0.021 [426:63]
  1 duplicate frame(s)!
  Pos:  98.4s   1480f (62%) 92.32fps Trem:   0min   9mb  A-V:-0.018 [426:63]
  1 duplicate frame(s)!
  Pos:  98.5s   1481f (62%) 92.33fps Trem:   0min   9mb  A-V:-0.019 [426:63]
  1 duplicate frame(s)!
  Pos:  98.5s   1482f (62%) 92.32fps Trem:   0min   9mb  A-V:-0.012 [426:63]
  1 duplicate frame(s)!
  Pos:  98.6s   1483f (62%) 92.32fps Trem:   0min   9mb  A-V:-0.014 [426:63]
  1 duplicate frame(s)!
  Pos:  98.7s   1484f (62%) 92.34fps Trem:   0min   9mb  A-V:-0.020 [426:63]
  1 duplicate frame(s)!
  Pos:  98.7s   1485f (62%) 92.34fps Trem:   0min   9mb  A-V:-0.026 [426:63]
  1 duplicate frame(s)!
  Pos:  98.8s   1486f (62%) 92.36fps Trem:   0min   9mb  A-V:-0.033 [426:63]
  1 duplicate frame(s)!
  Pos:  98.9s   1488f (62%) 92.34fps Trem:   0min   9mb  A-V:-0.029 [426:63]
  2 duplicate frame(s)!
  Pos:  99.0s   1489f (62%) 92.31fps Trem:   0min   9mb  A-V:-0.034 [426:63]
  1 duplicate frame(s)!
  Pos:  99.1s   1491f (62%) 92.28fps Trem:   0min   9mb  A-V:-0.036 [426:63]
  1 duplicate frame(s)!
  Pos:  99.2s   1492f (62%) 92.29fps Trem:   0min   9mb  A-V:-0.029 [426:63]
  2 duplicate frame(s)!
  Pos:  99.3s   1494f (62%) 91.94fps Trem:   0min   9mb  A-V:-0.016 [426:63]
  1 duplicate frame(s)!
  Pos:  99.4s   1495f (62%) 91.93fps Trem:   0min   9mb  A-V:-0.014 [426:63]
  2 duplicate frame(s)!
  Pos:  99.5s   1497f (62%) 91.78fps Trem:   0min   9mb  A-V:-0.015 [426:63]
  1 duplicate frame(s)!
  Pos:  99.6s   1498f (62%) 91.67fps Trem:   0min   9mb  A-V:-0.017 [425:63]
  1 duplicate frame(s)!
  Pos:  99.6s   1499f (62%) 91.65fps Trem:   0min   9mb  A-V:-0.024 [426:63]
  1 duplicate frame(s)!
  Pos:  99.7s   1500f (62%) 91.64fps Trem:   0min   9mb  A-V:-0.017 [425:63]
  1 duplicate frame(s)!
  Pos:  99.8s   1501f (62%) 91.63fps Trem:   0min   9mb  A-V:-0.016 [425:63]
  1 duplicate frame(s)!
  Pos:  99.8s   1502f (62%) 91.64fps Trem:   0min   9mb  A-V:-0.020 [426:63]
  1 duplicate frame(s)!
  Pos:  99.9s   1503f (62%) 91.64fps Trem:   0min   9mb  A-V:-0.014 [425:63]
  1 duplicate frame(s)!
  Pos: 100.0s   1504f (62%) 91.61fps Trem:   0min   9mb  A-V:-0.017 [425:63]
  1 duplicate frame(s)!
  Pos: 100.0s   1505f (62%) 91.62fps Trem:   0min   9mb  A-V:-0.011 [425:63]
  1 duplicate frame(s)!
  Pos: 100.1s   1506f (62%) 91.62fps Trem:   0min   9mb  A-V:-0.012 [425:63]
  1 duplicate frame(s)!
  Pos: 100.2s   1507f (62%) 91.63fps Trem:   0min   9mb  A-V:-0.018 [428:63]
  1 duplicate frame(s)!
  Pos: 100.2s   1508f (63%) 91.62fps Trem:   0min   9mb  A-V:-0.012 [428:64]
  1 duplicate frame(s)!
  Pos: 100.3s   1509f (63%) 91.64fps Trem:   0min   9mb  A-V:-0.010 [428:64]
  1 duplicate frame(s)!
  Pos: 100.4s   1510f (63%) 91.64fps Trem:   0min   9mb  A-V:-0.017 [428:63]
  1 duplicate frame(s)!
  Pos: 100.4s   1511f (63%) 91.64fps Trem:   0min   9mb  A-V:-0.015 [428:63]
  1 duplicate frame(s)!
  Pos: 100.5s   1512f (63%) 91.65fps Trem:   0min   9mb  A-V:-0.017 [428:63]
  1 duplicate frame(s)!
  Pos: 100.6s   1513f (63%) 91.66fps Trem:   0min   9mb  A-V:-0.024 [428:63]
  1 duplicate frame(s)!
  Pos: 100.6s   1514f (63%) 91.67fps Trem:   0min   9mb  A-V:-0.017 [428:63]
  1 duplicate frame(s)!
  Pos: 100.7s   1515f (63%) 91.67fps Trem:   0min   9mb  A-V:-0.017 [428:63]
  1 duplicate frame(s)!
  Pos: 100.8s   1516f (63%) 91.68fps Trem:   0min   9mb  A-V:-0.022 [428:63]
  1 duplicate frame(s)!
  Pos: 100.8s   1517f (63%) 91.68fps Trem:   0min   9mb  A-V:-0.016 [427:63]
  1 duplicate frame(s)!
  Pos: 100.9s   1518f (63%) 91.68fps Trem:   0min   9mb  A-V:-0.019 [427:63]
  1 duplicate frame(s)!
  Pos: 101.0s   1519f (63%) 91.70fps Trem:   0min   9mb  A-V:-0.025 [427:63]
  1 duplicate frame(s)!
  Pos: 101.0s   1520f (63%) 91.70fps Trem:   0min   9mb  A-V:-0.021 [427:63]
  1 duplicate frame(s)!
  Pos: 101.1s   1521f (64%) 91.70fps Trem:   0min   9mb  A-V:-0.014 [427:63]
  1 duplicate frame(s)!
  Pos: 101.2s   1522f (64%) 91.71fps Trem:   0min   9mb  A-V:-0.016 [427:63]
  1 duplicate frame(s)!
  Pos: 101.2s   1523f (64%) 91.72fps Trem:   0min   9mb  A-V:-0.022 [427:63]
  1 duplicate frame(s)!
  Pos: 101.3s   1524f (64%) 91.71fps Trem:   0min   9mb  A-V:-0.029 [427:64]
  1 duplicate frame(s)!
  Pos: 101.4s   1525f (64%) 91.72fps Trem:   0min   9mb  A-V:-0.022 [427:64]
  1 duplicate frame(s)!
  Pos: 101.4s   1526f (64%) 91.72fps Trem:   0min   9mb  A-V:-0.024 [427:64]
  1 duplicate frame(s)!
  Pos: 101.5s   1527f (64%) 91.72fps Trem:   0min   9mb  A-V:-0.031 [427:64]
  1 duplicate frame(s)!
  Pos: 101.6s   1528f (64%) 91.73fps Trem:   0min   9mb  A-V:-0.037 [427:64]
  1 duplicate frame(s)!
  Pos: 101.6s   1529f (64%) 91.73fps Trem:   0min   9mb  A-V:-0.031 [427:64]
  1 duplicate frame(s)!
  Pos: 101.7s   1530f (64%) 91.74fps Trem:   0min   9mb  A-V:-0.029 [427:64]
  1 duplicate frame(s)!
  Pos: 101.8s   1531f (64%) 91.74fps Trem:   0min   9mb  A-V:-0.024 [427:63]
  1 duplicate frame(s)!
  Pos: 101.8s   1532f (64%) 91.75fps Trem:   0min   9mb  A-V:-0.023 [427:63]
  1 duplicate frame(s)!
  Pos: 101.9s   1533f (64%) 91.75fps Trem:   0min   9mb  A-V:-0.029 [427:63]
  1 duplicate frame(s)!
  Pos: 102.0s   1534f (64%) 91.75fps Trem:   0min   9mb  A-V:-0.027 [427:63]
  1 duplicate frame(s)!
  Pos: 102.0s   1535f (64%) 91.76fps Trem:   0min   9mb  A-V:-0.030 [427:63]
  1 duplicate frame(s)!
  Pos: 102.1s   1536f (64%) 91.76fps Trem:   0min   9mb  A-V:-0.023 [427:63]
  1 duplicate frame(s)!
  Pos: 102.2s   1537f (64%) 91.77fps Trem:   0min   9mb  A-V:-0.020 [427:63]
  1 duplicate frame(s)!
  Pos: 102.2s   1538f (64%) 91.77fps Trem:   0min   9mb  A-V:-0.026 [427:63]
  1 duplicate frame(s)!
  Pos: 102.3s   1539f (64%) 91.78fps Trem:   0min   9mb  A-V:-0.020 [427:63]
  1 duplicate frame(s)!
  Pos: 102.4s   1540f (64%) 91.78fps Trem:   0min   9mb  A-V:-0.020 [427:63]
  1 duplicate frame(s)!
  Pos: 102.4s   1541f (64%) 91.79fps Trem:   0min   9mb  A-V:-0.024 [427:63]
  1 duplicate frame(s)!
  Pos: 102.5s   1542f (64%) 91.79fps Trem:   0min   9mb  A-V:-0.018 [427:63]
  1 duplicate frame(s)!
  Pos: 102.6s   1543f (64%) 91.79fps Trem:   0min   9mb  A-V:-0.022 [427:63]
  1 duplicate frame(s)!
  Pos: 102.6s   1544f (64%) 91.80fps Trem:   0min   9mb  A-V:-0.015 [427:63]
  1 duplicate frame(s)!
  Pos: 102.7s   1545f (64%) 91.80fps Trem:   0min   9mb  A-V:-0.015 [427:63]
  1 duplicate frame(s)!
  Pos: 102.8s   1546f (65%) 91.81fps Trem:   0min   9mb  A-V:-0.009 [427:63]
  1 duplicate frame(s)!
  Pos: 102.8s   1547f (65%) 91.81fps Trem:   0min   9mb  A-V:-0.010 [427:63]
  1 duplicate frame(s)!
  Pos: 102.9s   1548f (65%) 91.82fps Trem:   0min   9mb  A-V:-0.016 [427:63]
  1 duplicate frame(s)!
  Pos: 103.0s   1549f (65%) 91.81fps Trem:   0min   9mb  A-V:-0.010 [427:63]
  1 duplicate frame(s)!
  Pos: 103.0s   1550f (65%) 91.81fps Trem:   0min   9mb  A-V:-0.012 [427:63]
  1 duplicate frame(s)!
  Pos: 103.1s   1551f (65%) 91.83fps Trem:   0min   9mb  A-V:-0.019 [427:63]
  1 duplicate frame(s)!
  Pos: 103.2s   1552f (65%) 91.82fps Trem:   0min   9mb  A-V:-0.016 [427:63]
  1 duplicate frame(s)!
  Pos: 103.2s   1553f (65%) 91.84fps Trem:   0min   9mb  A-V:-0.017 [427:63]
  1 duplicate frame(s)!
  Pos: 103.3s   1554f (65%) 91.84fps Trem:   0min   9mb  A-V:-0.013 [427:63]
  1 duplicate frame(s)!
  Pos: 103.4s   1555f (65%) 91.85fps Trem:   0min   9mb  A-V:-0.013 [427:63]
  1 duplicate frame(s)!
  Pos: 103.4s   1556f (65%) 91.85fps Trem:   0min   9mb  A-V:-0.020 [426:63]
  1 duplicate frame(s)!
  Pos: 103.5s   1557f (65%) 91.84fps Trem:   0min   9mb  A-V:-0.017 [427:63]
  1 duplicate frame(s)!
  Pos: 103.6s   1558f (65%) 91.85fps Trem:   0min   9mb  A-V:-0.019 [426:63]
  1 duplicate frame(s)!
  Pos: 103.6s   1559f (65%) 91.85fps Trem:   0min   9mb  A-V:-0.013 [426:63]
  1 duplicate frame(s)!
  Pos: 103.7s   1560f (65%) 91.86fps Trem:   0min   9mb  A-V:-0.011 [426:63]
  1 duplicate frame(s)!
  Pos: 103.8s   1561f (65%) 91.86fps Trem:   0min   9mb  A-V:-0.018 [426:63]
  1 duplicate frame(s)!
  Pos: 103.8s   1562f (65%) 91.86fps Trem:   0min   9mb  A-V:-0.025 [426:63]
  1 duplicate frame(s)!
  Pos: 103.9s   1563f (65%) 91.85fps Trem:   0min   9mb  A-V:-0.020 [426:63]
  1 duplicate frame(s)!
  Pos: 104.0s   1564f (65%) 91.86fps Trem:   0min   9mb  A-V:-0.021 [426:63]
  1 duplicate frame(s)!
  Pos: 104.0s   1565f (65%) 91.86fps Trem:   0min   9mb  A-V:-0.027 [426:63]
  1 duplicate frame(s)!
  Pos: 104.1s   1566f (65%) 91.85fps Trem:   0min   9mb  A-V:-0.021 [426:63]
  1 duplicate frame(s)!
  Pos: 104.2s   1567f (65%) 91.86fps Trem:   0min   9mb  A-V:-0.018 [426:63]
  1 duplicate frame(s)!
  Pos: 104.2s   1568f (65%) 91.86fps Trem:   0min   9mb  A-V:-0.011 [426:63]
  1 duplicate frame(s)!
  Pos: 104.3s   1569f (65%) 91.87fps Trem:   0min   9mb  A-V:-0.007 [426:63]
  1 duplicate frame(s)!
  Pos: 104.4s   1570f (65%) 91.87fps Trem:   0min   9mb  A-V:-0.012 [426:63]
  1 duplicate frame(s)!
  Pos: 104.4s   1571f (65%) 91.88fps Trem:   0min   9mb  A-V:-0.005 [426:63]
  1 duplicate frame(s)!
  Pos: 104.5s   1572f (65%) 91.88fps Trem:   0min   9mb  A-V:-0.006 [426:63]
  1 duplicate frame(s)!
  Pos: 104.6s   1573f (65%) 91.87fps Trem:   0min   9mb  A-V:-0.001 [426:63]
  1 duplicate frame(s)!
  Pos: 104.6s   1574f (65%) 91.88fps Trem:   0min   9mb  A-V:-0.000 [426:63]
  1 duplicate frame(s)!
  Pos: 104.7s   1575f (65%) 91.88fps Trem:   0min   9mb  A-V:-0.007 [426:63]
  1 duplicate frame(s)!
  Pos: 104.8s   1576f (65%) 91.88fps Trem:   0min   9mb  A-V:-0.000 [426:63]
  1 duplicate frame(s)!
  Pos: 104.8s   1577f (65%) 91.88fps Trem:   0min   9mb  A-V:-0.002 [426:63]
  1 duplicate frame(s)!
  Pos: 104.9s   1578f (65%) 91.89fps Trem:   0min   9mb  A-V:-0.008 [426:63]
  1 duplicate frame(s)!
  Pos: 105.0s   1579f (66%) 91.88fps Trem:   0min   9mb  A-V:-0.004 [426:63]
  1 duplicate frame(s)!
  Pos: 105.0s   1580f (66%) 91.89fps Trem:   0min   9mb  A-V:-0.005 [425:63]
  1 duplicate frame(s)!
  Pos: 105.1s   1581f (66%) 91.89fps Trem:   0min   9mb  A-V:-0.001 [425:63]
  1 duplicate frame(s)!
  Pos: 105.2s   1582f (66%) 91.89fps Trem:   0min   9mb  A-V:-0.006 [425:63]
  1 duplicate frame(s)!
  Pos: 105.2s   1583f (66%) 91.90fps Trem:   0min   9mb  A-V:-0.013 [425:63]
  1 duplicate frame(s)!
  Pos: 105.3s   1584f (66%) 91.89fps Trem:   0min   9mb  A-V:-0.009 [425:63]
  1 duplicate frame(s)!
  Pos: 105.4s   1585f (66%) 91.89fps Trem:   0min   9mb  A-V:-0.010 [425:64]
  1 duplicate frame(s)!
  Pos: 105.4s   1586f (66%) 91.89fps Trem:   0min   9mb  A-V:-0.004 [425:64]
  1 duplicate frame(s)!
  Pos: 105.5s   1587f (66%) 91.90fps Trem:   0min   9mb  A-V:0.001 [425:64]
  1 duplicate frame(s)!
  Pos: 105.6s   1588f (66%) 91.90fps Trem:   0min   9mb  A-V:-0.003 [425:64]
  1 duplicate frame(s)!
  Pos: 105.6s   1589f (66%) 91.90fps Trem:   0min   9mb  A-V:-0.002 [425:64]
  1 duplicate frame(s)!
  Pos: 105.7s   1590f (66%) 91.90fps Trem:   0min   9mb  A-V:-0.005 [425:64]
  1 duplicate frame(s)!
  Pos: 105.8s   1591f (66%) 91.90fps Trem:   0min   9mb  A-V:-0.012 [425:64]
  1 duplicate frame(s)!
  Pos: 105.8s   1592f (67%) 91.90fps Trem:   0min   9mb  A-V:-0.005 [425:64]
  1 duplicate frame(s)!
  Pos: 105.9s   1593f (67%) 91.90fps Trem:   0min   9mb  A-V:-0.007 [425:64]
  1 duplicate frame(s)!
  Pos: 106.0s   1594f (67%) 91.91fps Trem:   0min   9mb  A-V:-0.013 [425:64]
  1 duplicate frame(s)!
  Pos: 106.0s   1595f (67%) 91.90fps Trem:   0min   9mb  A-V:-0.007 [425:64]
  1 duplicate frame(s)!
  Pos: 106.1s   1596f (67%) 91.90fps Trem:   0min   9mb  A-V:-0.010 [425:63]
  1 duplicate frame(s)!
  Pos: 106.2s   1597f (67%) 91.91fps Trem:   0min   9mb  A-V:-0.017 [425:63]
  1 duplicate frame(s)!
  Pos: 106.2s   1598f (67%) 91.90fps Trem:   0min   9mb  A-V:-0.024 [424:63]
  1 duplicate frame(s)!
  Pos: 106.3s   1599f (67%) 91.91fps Trem:   0min   9mb  A-V:-0.017 [424:63]
  1 duplicate frame(s)!
  Pos: 106.4s   1600f (67%) 91.91fps Trem:   0min   9mb  A-V:-0.010 [424:63]
  1 duplicate frame(s)!
  Pos: 106.4s   1601f (67%) 91.92fps Trem:   0min   9mb  A-V:-0.007 [424:63]
  1 duplicate frame(s)!
  Pos: 106.5s   1602f (67%) 91.92fps Trem:   0min   9mb  A-V:-0.012 [424:63]
  1 duplicate frame(s)!
  Pos: 106.6s   1603f (67%) 91.92fps Trem:   0min   9mb  A-V:-0.018 [424:63]
  1 duplicate frame(s)!
  Pos: 106.6s   1604f (67%) 91.91fps Trem:   0min   9mb  A-V:-0.018 [424:63]
  1 duplicate frame(s)!
  Pos: 106.7s   1605f (67%) 91.91fps Trem:   0min   9mb  A-V:-0.025 [424:63]
  1 duplicate frame(s)!
  Pos: 106.8s   1606f (67%) 91.92fps Trem:   0min   9mb  A-V:-0.032 [424:63]
  1 duplicate frame(s)!
  Pos: 106.8s   1607f (67%) 91.91fps Trem:   0min   9mb  A-V:-0.026 [424:63]
  1 duplicate frame(s)!
  Pos: 106.9s   1608f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.026 [424:63]
  1 duplicate frame(s)!
  Pos: 107.0s   1609f (67%) 91.92fps Trem:   0min   9mb  A-V:-0.020 [424:63]
  1 duplicate frame(s)!
  Pos: 107.0s   1610f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.019 [424:63]
  1 duplicate frame(s)!
  Pos: 107.1s   1611f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.026 [424:63]
  1 duplicate frame(s)!
  Pos: 107.2s   1612f (67%) 91.92fps Trem:   0min   9mb  A-V:-0.023 [424:63]
  1 duplicate frame(s)!
  Pos: 107.2s   1613f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.025 [424:63]
  1 duplicate frame(s)!
  Pos: 107.3s   1614f (67%) 91.92fps Trem:   0min   9mb  A-V:-0.023 [424:63]
  1 duplicate frame(s)!
  Pos: 107.4s   1615f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.025 [424:63]
  1 duplicate frame(s)!
  Pos: 107.4s   1616f (67%) 91.92fps Trem:   0min   9mb  A-V:-0.018 [424:63]
  1 duplicate frame(s)!
  Pos: 107.5s   1617f (67%) 91.94fps Trem:   0min   9mb  A-V:-0.014 [424:63]
  1 duplicate frame(s)!
  Pos: 107.6s   1618f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.018 [424:63]
  1 duplicate frame(s)!
  Pos: 107.6s   1619f (67%) 91.94fps Trem:   0min   9mb  A-V:-0.025 [424:63]
  1 duplicate frame(s)!
  Pos: 107.7s   1620f (67%) 91.94fps Trem:   0min   9mb  A-V:-0.023 [424:63]
  1 duplicate frame(s)!
  Pos: 107.8s   1621f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.029 [423:63]
  1 duplicate frame(s)!
  Pos: 107.8s   1622f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.036 [424:63]
  1 duplicate frame(s)!
  Pos: 107.9s   1623f (67%) 91.92fps Trem:   0min   9mb  A-V:-0.030 [423:63]
  1 duplicate frame(s)!
  Pos: 108.0s   1624f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.029 [423:63]
  1 duplicate frame(s)!
  Pos: 108.0s   1625f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.023 [423:63]
  1 duplicate frame(s)!
  Pos: 108.1s   1626f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.022 [423:63]
  1 duplicate frame(s)!
  Pos: 108.2s   1627f (67%) 91.93fps Trem:   0min   9mb  A-V:-0.028 [423:63]
  1 duplicate frame(s)!
  Pos: 108.2s   1628f (68%) 91.92fps Trem:   0min   9mb  A-V:-0.022 [423:63]
  1 duplicate frame(s)!
  Pos: 108.3s   1629f (68%) 91.93fps Trem:   0min   9mb  A-V:-0.019 [423:63]
  1 duplicate frame(s)!
  Pos: 108.4s   1630f (68%) 91.93fps Trem:   0min   9mb  A-V:-0.026 [423:63]
  1 duplicate frame(s)!
  Pos: 108.4s   1631f (68%) 91.93fps Trem:   0min   9mb  A-V:-0.019 [423:63]
  1 duplicate frame(s)!
  Pos: 108.5s   1632f (68%) 91.92fps Trem:   0min   9mb  A-V:-0.020 [425:63]
  1 duplicate frame(s)!
  Pos: 108.6s   1633f (68%) 91.93fps Trem:   0min   9mb  A-V:-0.024 [425:63]
  1 duplicate frame(s)!
  Pos: 108.6s   1634f (68%) 91.93fps Trem:   0min   9mb  A-V:-0.018 [425:63]
  1 duplicate frame(s)!
  Pos: 108.7s   1635f (68%) 91.93fps Trem:   0min   9mb  A-V:-0.020 [425:63]
  1 duplicate frame(s)!
  Pos: 108.8s   1636f (68%) 91.93fps Trem:   0min   9mb  A-V:-0.027 [425:63]
  1 duplicate frame(s)!
  Pos: 108.8s   1637f (68%) 91.93fps Trem:   0min   9mb  A-V:-0.020 [425:63]
  1 duplicate frame(s)!
  Pos: 108.9s   1638f (68%) 91.93fps Trem:   0min   9mb  A-V:-0.016 [425:63]
  1 duplicate frame(s)!
  Pos: 109.0s   1639f (68%) 91.94fps Trem:   0min   9mb  A-V:-0.021 [425:63]
  1 duplicate frame(s)!
  Pos: 109.0s   1640f (68%) 91.94fps Trem:   0min   9mb  A-V:-0.014 [424:63]
  1 duplicate frame(s)!
  Pos: 109.1s   1641f (68%) 91.94fps Trem:   0min   9mb  A-V:-0.015 [424:63]
  1 duplicate frame(s)!
  Pos: 109.2s   1642f (68%) 91.95fps Trem:   0min   9mb  A-V:-0.020 [424:63]
  1 duplicate frame(s)!
  Pos: 109.2s   1643f (68%) 91.94fps Trem:   0min   9mb  A-V:-0.013 [424:63]
  1 duplicate frame(s)!
  Pos: 109.3s   1644f (68%) 91.94fps Trem:   0min   9mb  A-V:-0.016 [424:63]
  1 duplicate frame(s)!
  Pos: 109.4s   1645f (69%) 91.95fps Trem:   0min   9mb  A-V:-0.010 [424:63]
  1 duplicate frame(s)!
  Pos: 109.4s   1646f (69%) 91.95fps Trem:   0min   9mb  A-V:-0.014 [424:63]
  1 duplicate frame(s)!
  Pos: 109.5s   1647f (69%) 91.95fps Trem:   0min   9mb  A-V:-0.020 [424:63]
  1 duplicate frame(s)!
  Pos: 109.6s   1648f (69%) 91.95fps Trem:   0min   9mb  A-V:-0.015 [424:63]
  1 duplicate frame(s)!
  Pos: 109.6s   1649f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.015 [424:63]
  1 duplicate frame(s)!
  Pos: 109.7s   1650f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.021 [424:63]
  1 duplicate frame(s)!
  Pos: 109.8s   1651f (69%) 91.95fps Trem:   0min   9mb  A-V:-0.021 [424:63]
  1 duplicate frame(s)!
  Pos: 109.8s   1652f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.025 [424:63]
  1 duplicate frame(s)!
  Pos: 109.9s   1653f (69%) 91.95fps Trem:   0min   9mb  A-V:-0.018 [424:63]
  1 duplicate frame(s)!
  Pos: 110.0s   1654f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.015 [424:63]
  1 duplicate frame(s)!
  Pos: 110.0s   1655f (69%) 91.95fps Trem:   0min   9mb  A-V:-0.021 [424:63]
  1 duplicate frame(s)!
  Pos: 110.1s   1656f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.014 [424:63]
  1 duplicate frame(s)!
  Pos: 110.2s   1657f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.015 [424:63]
  1 duplicate frame(s)!
  Pos: 110.2s   1658f (69%) 91.97fps Trem:   0min   9mb  A-V:-0.019 [423:63]
  1 duplicate frame(s)!
  Pos: 110.3s   1659f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.013 [423:63]
  1 duplicate frame(s)!
  Pos: 110.4s   1660f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.016 [424:63]
  1 duplicate frame(s)!
  Pos: 110.4s   1661f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.010 [423:63]
  1 duplicate frame(s)!
  Pos: 110.5s   1662f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.011 [423:63]
  1 duplicate frame(s)!
  Pos: 110.6s   1663f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.016 [423:63]
  1 duplicate frame(s)!
  Pos: 110.6s   1664f (69%) 91.95fps Trem:   0min   9mb  A-V:-0.010 [423:63]
  1 duplicate frame(s)!
  Pos: 110.7s   1665f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.007 [423:63]
  1 duplicate frame(s)!
  Pos: 110.8s   1666f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.013 [423:63]
  1 duplicate frame(s)!
  Pos: 110.8s   1667f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.020 [423:63]
  1 duplicate frame(s)!
  Pos: 110.9s   1668f (69%) 91.97fps Trem:   0min   9mb  A-V:-0.027 [423:63]
  1 duplicate frame(s)!
  Pos: 111.0s   1669f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.024 [423:63]
  1 duplicate frame(s)!
  Pos: 111.0s   1670f (69%) 91.97fps Trem:   0min   9mb  A-V:-0.026 [423:63]
  1 duplicate frame(s)!
  Pos: 111.1s   1671f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.020 [423:63]
  1 duplicate frame(s)!
  Pos: 111.2s   1672f (69%) 91.96fps Trem:   0min   9mb  A-V:-0.016 [423:63]
  1 duplicate frame(s)!
  Pos: 111.2s   1673f (69%) 91.95fps Trem:   0min   9mb  A-V:-0.022 [423:63]
  1 duplicate frame(s)!
  Pos: 111.3s   1674f (70%) 91.94fps Trem:   0min   9mb  A-V:-0.015 [423:63]
  1 duplicate frame(s)!
  Pos: 111.4s   1675f (70%) 91.95fps Trem:   0min   9mb  A-V:-0.013 [423:63]
  1 duplicate frame(s)!
  Pos: 111.4s   1676f (70%) 91.95fps Trem:   0min   9mb  A-V:-0.020 [423:63]
  1 duplicate frame(s)!
  Pos: 111.5s   1677f (70%) 91.94fps Trem:   0min   9mb  A-V:-0.027 [423:63]
  1 duplicate frame(s)!
  Pos: 111.6s   1678f (70%) 91.92fps Trem:   0min   9mb  A-V:-0.020 [423:63]
  1 duplicate frame(s)!
  Pos: 111.6s   1679f (70%) 91.92fps Trem:   0min   9mb  A-V:-0.015 [423:63]
  1 duplicate frame(s)!
  Pos: 111.7s   1680f (70%) 91.91fps Trem:   0min   9mb  A-V:-0.020 [423:63]
  1 duplicate frame(s)!
  Pos: 111.8s   1681f (70%) 91.90fps Trem:   0min   9mb  A-V:-0.026 [423:63]
  1 duplicate frame(s)!
  Pos: 111.8s   1682f (70%) 91.86fps Trem:   0min   9mb  A-V:-0.021 [423:63]
  1 duplicate frame(s)!
  Pos: 111.9s   1683f (70%) 91.85fps Trem:   0min   9mb  A-V:-0.025 [423:63]
  1 duplicate frame(s)!
  Pos: 112.0s   1684f (70%) 91.86fps Trem:   0min   9mb  A-V:-0.018 [423:63]
  1 duplicate frame(s)!
  Pos: 112.0s   1685f (70%) 91.85fps Trem:   0min   9mb  A-V:-0.020 [423:63]
  1 duplicate frame(s)!
  Pos: 112.1s   1686f (70%) 91.86fps Trem:   0min   9mb  A-V:-0.026 [423:63]
  1 duplicate frame(s)!
  Pos: 112.2s   1687f (70%) 91.85fps Trem:   0min   9mb  A-V:-0.023 [423:63]
  1 duplicate frame(s)!
  Pos: 112.2s   1688f (70%) 91.86fps Trem:   0min   9mb  A-V:-0.024 [423:63]
  1 duplicate frame(s)!
  Pos: 112.3s   1689f (70%) 91.86fps Trem:   0min   9mb  A-V:-0.018 [423:63]
  1 duplicate frame(s)!
  Pos: 112.4s   1690f (70%) 91.85fps Trem:   0min   9mb  A-V:-0.021 [423:63]
  1 duplicate frame(s)!
  Pos: 112.4s   1691f (71%) 91.87fps Trem:   0min   9mb  A-V:-0.015 [423:63]
  1 duplicate frame(s)!
  Pos: 112.5s   1692f (71%) 91.86fps Trem:   0min   9mb  A-V:-0.018 [423:63]
  1 duplicate frame(s)!
  Pos: 112.6s   1693f (71%) 91.88fps Trem:   0min   9mb  A-V:-0.024 [423:63]
  1 duplicate frame(s)!
  Pos: 112.6s   1694f (71%) 91.88fps Trem:   0min   9mb  A-V:-0.020 [423:64]
  1 duplicate frame(s)!
  Pos: 112.7s   1695f (71%) 91.88fps Trem:   0min   9mb  A-V:-0.013 [423:64]
  1 duplicate frame(s)!
  Pos: 112.8s   1696f (71%) 91.88fps Trem:   0min   9mb  A-V:-0.013 [423:64]
  1 duplicate frame(s)!
  Pos: 112.8s   1697f (71%) 91.89fps Trem:   0min   9mb  A-V:-0.007 [423:64]
  1 duplicate frame(s)!
  Pos: 112.9s   1698f (71%) 91.88fps Trem:   0min   9mb  A-V:-0.007 [423:64]
  1 duplicate frame(s)!
  Pos: 113.0s   1699f (71%) 91.89fps Trem:   0min   9mb  A-V:-0.014 [423:64]
  1 duplicate frame(s)!
  Pos: 113.0s   1700f (71%) 91.90fps Trem:   0min   9mb  A-V:-0.020 [423:64]
  1 duplicate frame(s)!
  Pos: 113.1s   1701f (71%) 91.90fps Trem:   0min   9mb  A-V:-0.014 [423:64]
  1 duplicate frame(s)!
  Pos: 113.2s   1702f (71%) 91.91fps Trem:   0min   9mb  A-V:-0.011 [423:64]
  1 duplicate frame(s)!
  Pos: 113.2s   1703f (71%) 91.90fps Trem:   0min   9mb  A-V:-0.004 [423:64]
  1 duplicate frame(s)!
  Pos: 113.3s   1704f (71%) 91.91fps Trem:   0min   9mb  A-V:-0.000 [423:64]
  1 duplicate frame(s)!
  Pos: 113.4s   1705f (71%) 91.91fps Trem:   0min   9mb  A-V:-0.006 [423:64]
  1 duplicate frame(s)!
  Pos: 113.4s   1706f (71%) 91.90fps Trem:   0min   9mb  A-V:-0.001 [423:64]
  1 duplicate frame(s)!
  Pos: 113.5s   1707f (71%) 91.92fps Trem:   0min   9mb  A-V:-0.001 [423:64]
  1 duplicate frame(s)!
  Pos: 113.6s   1708f (71%) 91.92fps Trem:   0min   9mb  A-V:-0.008 [423:64]
  1 duplicate frame(s)!
  Pos: 113.6s   1709f (71%) 91.93fps Trem:   0min   9mb  A-V:-0.002 [422:64]
  1 duplicate frame(s)!
  Pos: 113.7s   1710f (71%) 91.93fps Trem:   0min   9mb  A-V:-0.006 [423:63]
  1 duplicate frame(s)!
  Pos: 113.8s   1711f (71%) 91.93fps Trem:   0min   9mb  A-V:-0.013 [422:63]
  1 duplicate frame(s)!
  Pos: 113.8s   1712f (72%) 91.93fps Trem:   0min   9mb  A-V:-0.009 [422:63]
  1 duplicate frame(s)!
  Pos: 113.9s   1713f (72%) 91.92fps Trem:   0min   9mb  A-V:-0.014 [422:63]
  1 duplicate frame(s)!
  Pos: 114.0s   1714f (72%) 91.93fps Trem:   0min   9mb  A-V:-0.009 [422:63]
  1 duplicate frame(s)!
  Pos: 114.0s   1715f (72%) 91.93fps Trem:   0min   9mb  A-V:-0.014 [422:64]
  1 duplicate frame(s)!
  Pos: 114.1s   1716f (72%) 91.94fps Trem:   0min   9mb  A-V:-0.021 [422:64]
  1 duplicate frame(s)!
  Pos: 114.2s   1717f (72%) 91.94fps Trem:   0min   9mb  A-V:-0.016 [422:64]
  1 duplicate frame(s)!
  Pos: 114.2s   1718f (72%) 91.95fps Trem:   0min   9mb  A-V:-0.017 [422:64]
  1 duplicate frame(s)!
  Pos: 114.3s   1719f (72%) 91.94fps Trem:   0min   9mb  A-V:-0.010 [422:64]
  1 duplicate frame(s)!
  Pos: 114.4s   1720f (72%) 91.95fps Trem:   0min   9mb  A-V:-0.008 [422:64]
  1 duplicate frame(s)!
  Pos: 114.4s   1721f (72%) 91.95fps Trem:   0min   9mb  A-V:-0.014 [422:64]
  1 duplicate frame(s)!
  Pos: 114.5s   1722f (72%) 91.95fps Trem:   0min   9mb  A-V:-0.021 [422:64]
  1 duplicate frame(s)!
  Pos: 114.6s   1723f (72%) 91.96fps Trem:   0min   9mb  A-V:-0.027 [422:64]
  1 duplicate frame(s)!
  Pos: 114.6s   1724f (72%) 91.95fps Trem:   0min   9mb  A-V:-0.023 [422:63]
  1 duplicate frame(s)!
  Pos: 114.7s   1725f (72%) 91.96fps Trem:   0min   9mb  A-V:-0.023 [422:63]
  1 duplicate frame(s)!
  Pos: 114.8s   1726f (72%) 91.96fps Trem:   0min   9mb  A-V:-0.029 [422:63]
  1 duplicate frame(s)!
  Pos: 114.8s   1727f (72%) 91.96fps Trem:   0min   9mb  A-V:-0.023 [422:63]
  1 duplicate frame(s)!
  Pos: 114.9s   1728f (72%) 91.96fps Trem:   0min   9mb  A-V:-0.021 [422:63]
  1 duplicate frame(s)!
  Pos: 115.0s   1729f (72%) 91.95fps Trem:   0min   9mb  A-V:-0.028 [422:63]
  1 duplicate frame(s)!
  Pos: 115.0s   1730f (72%) 91.97fps Trem:   0min   9mb  A-V:-0.034 [422:63]
  1 duplicate frame(s)!
  Pos: 115.1s   1731f (72%) 91.96fps Trem:   0min   9mb  A-V:-0.030 [422:63]
  1 duplicate frame(s)!
  Pos: 115.2s   1732f (72%) 91.97fps Trem:   0min   9mb  A-V:-0.031 [422:63]
  1 duplicate frame(s)!
  Pos: 115.2s   1733f (72%) 91.97fps Trem:   0min   9mb  A-V:-0.027 [422:63]
  1 duplicate frame(s)!
  Pos: 115.3s   1734f (72%) 91.97fps Trem:   0min   9mb  A-V:-0.029 [422:63]
  1 duplicate frame(s)!
  Pos: 115.4s   1735f (72%) 91.97fps Trem:   0min   9mb  A-V:-0.022 [422:63]
  1 duplicate frame(s)!
  Pos: 115.4s   1736f (72%) 91.98fps Trem:   0min   9mb  A-V:-0.017 [422:63]
  1 duplicate frame(s)!
  Pos: 115.5s   1737f (72%) 91.98fps Trem:   0min   9mb  A-V:-0.021 [422:63]
  1 duplicate frame(s)!
  Pos: 115.6s   1738f (72%) 91.97fps Trem:   0min   9mb  A-V:-0.014 [422:63]
  1 duplicate frame(s)!
  Pos: 115.6s   1739f (72%) 91.98fps Trem:   0min   9mb  A-V:-0.013 [422:63]
  1 duplicate frame(s)!
  Pos: 115.7s   1740f (72%) 91.98fps Trem:   0min   9mb  A-V:-0.006 [422:63]
  1 duplicate frame(s)!
  Pos: 115.8s   1741f (72%) 91.99fps Trem:   0min   9mb  A-V:-0.004 [422:63]
  1 duplicate frame(s)!
  Pos: 115.8s   1742f (72%) 91.97fps Trem:   0min   9mb  A-V:0.003 [422:63]
  1 duplicate frame(s)!
  Pos: 115.9s   1743f (72%) 91.98fps Trem:   0min   9mb  A-V:0.005 [422:63]
  1 duplicate frame(s)!
  Pos: 116.0s   1744f (72%) 91.98fps Trem:   0min   9mb  A-V:-0.002 [422:63]
  1 duplicate frame(s)!
  Pos: 116.0s   1745f (72%) 91.97fps Trem:   0min   9mb  A-V:-0.009 [422:63]
  1 duplicate frame(s)!
  Pos: 116.1s   1746f (73%) 91.98fps Trem:   0min   9mb  A-V:-0.005 [422:63]
  1 duplicate frame(s)!
  Pos: 116.2s   1747f (73%) 91.99fps Trem:   0min   9mb  A-V:-0.010 [422:63]
  1 duplicate frame(s)!
  Pos: 116.2s   1748f (73%) 92.00fps Trem:   0min   9mb  A-V:-0.016 [422:63]
  1 duplicate frame(s)!
  Pos: 116.3s   1749f (73%) 91.99fps Trem:   0min   9mb  A-V:-0.014 [422:63]
  1 duplicate frame(s)!
  Pos: 116.4s   1750f (73%) 92.00fps Trem:   0min   9mb  A-V:-0.017 [422:63]
  1 duplicate frame(s)!
  Pos: 116.4s   1751f (73%) 92.00fps Trem:   0min   9mb  A-V:-0.010 [422:63]
  1 duplicate frame(s)!
  Pos: 116.5s   1752f (73%) 92.00fps Trem:   0min   9mb  A-V:-0.010 [422:63]
  1 duplicate frame(s)!
  Pos: 116.6s   1753f (73%) 92.02fps Trem:   0min   9mb  A-V:-0.015 [422:63]
  1 duplicate frame(s)!
  Pos: 116.6s   1754f (73%) 92.01fps Trem:   0min   9mb  A-V:-0.008 [422:63]
  1 duplicate frame(s)!
  Pos: 116.7s   1755f (73%) 92.02fps Trem:   0min   9mb  A-V:-0.007 [422:63]
  1 duplicate frame(s)!
  Pos: 116.8s   1756f (73%) 92.02fps Trem:   0min   9mb  A-V:-0.013 [422:63]
  1 duplicate frame(s)!
  Pos: 116.9s   1757f (73%) 92.02fps Trem:   0min   9mb  A-V:-0.006 [424:63]
  1 duplicate frame(s)!
  Pos: 116.9s   1758f (73%) 92.03fps Trem:   0min   9mb  A-V:-0.008 [424:63]
  1 duplicate frame(s)!
  Pos: 117.0s   1759f (73%) 92.04fps Trem:   0min   9mb  A-V:-0.014 [424:63]
  1 duplicate frame(s)!
  Pos: 117.1s   1760f (73%) 92.04fps Trem:   0min   9mb  A-V:-0.011 [424:63]
  1 duplicate frame(s)!
  Pos: 117.1s   1761f (73%) 92.04fps Trem:   0min   9mb  A-V:-0.016 [424:63]
  1 duplicate frame(s)!
  Pos: 117.2s   1762f (73%) 92.05fps Trem:   0min   9mb  A-V:-0.023 [424:63]
  1 duplicate frame(s)!
  Pos: 117.3s   1763f (73%) 92.05fps Trem:   0min   9mb  A-V:-0.016 [423:63]
  1 duplicate frame(s)!
  Pos: 117.3s   1764f (73%) 92.06fps Trem:   0min   9mb  A-V:-0.013 [423:63]
  1 duplicate frame(s)!
  Pos: 117.4s   1765f (74%) 92.06fps Trem:   0min   9mb  A-V:-0.009 [423:63]
  1 duplicate frame(s)!
  Pos: 117.5s   1766f (74%) 92.07fps Trem:   0min   9mb  A-V:-0.010 [423:63]
  1 duplicate frame(s)!
  Pos: 117.5s   1767f (74%) 92.06fps Trem:   0min   9mb  A-V:-0.004 [423:63]
  1 duplicate frame(s)!
  Pos: 117.6s   1768f (74%) 92.06fps Trem:   0min   9mb  A-V:-0.004 [423:63]
  1 duplicate frame(s)!
  Pos: 117.7s   1769f (74%) 92.07fps Trem:   0min   9mb  A-V:-0.009 [423:63]
  1 duplicate frame(s)!
  Pos: 117.7s   1770f (74%) 92.07fps Trem:   0min   9mb  A-V:-0.016 [423:64]
  1 duplicate frame(s)!
  Pos: 117.8s   1771f (74%) 92.08fps Trem:   0min   9mb  A-V:-0.009 [423:64]
  1 duplicate frame(s)!
  Pos: 117.9s   1772f (74%) 92.08fps Trem:   0min   9mb  A-V:-0.003 [423:64]
  1 duplicate frame(s)!
  Pos: 117.9s   1773f (74%) 92.09fps Trem:   0min   9mb  A-V:-0.000 [423:64]
  1 duplicate frame(s)!
  Pos: 118.0s   1774f (74%) 92.09fps Trem:   0min   9mb  A-V:-0.007 [423:64]
  1 duplicate frame(s)!
  Pos: 118.1s   1775f (74%) 92.10fps Trem:   0min   9mb  A-V:-0.013 [423:64]
  1 duplicate frame(s)!
  Pos: 118.1s   1776f (74%) 92.10fps Trem:   0min   9mb  A-V:-0.008 [423:64]
  1 duplicate frame(s)!
  Pos: 118.2s   1777f (74%) 92.10fps Trem:   0min   9mb  A-V:-0.012 [423:64]
  1 duplicate frame(s)!
  Pos: 118.3s   1778f (74%) 92.11fps Trem:   0min   9mb  A-V:-0.019 [423:64]
  1 duplicate frame(s)!
  Pos: 118.3s   1779f (74%) 92.11fps Trem:   0min   9mb  A-V:-0.017 [423:64]
  1 duplicate frame(s)!
  Pos: 118.4s   1780f (74%) 92.12fps Trem:   0min   9mb  A-V:-0.020 [423:64]
  1 duplicate frame(s)!
  Pos: 118.5s   1781f (74%) 92.13fps Trem:   0min   9mb  A-V:-0.027 [423:64]
  1 duplicate frame(s)!
  Pos: 118.5s   1782f (74%) 92.14fps Trem:   0min   9mb  A-V:-0.020 [423:64]
  1 duplicate frame(s)!
  Pos: 118.6s   1783f (74%) 92.14fps Trem:   0min   9mb  A-V:-0.021 [423:64]
  1 duplicate frame(s)!
  Pos: 118.7s   1784f (74%) 92.14fps Trem:   0min   9mb  A-V:-0.028 [423:64]
  1 duplicate frame(s)!
  Pos: 118.7s   1785f (74%) 92.15fps Trem:   0min   9mb  A-V:-0.035 [422:64]
  1 duplicate frame(s)!
  Pos: 118.8s   1786f (74%) 92.15fps Trem:   0min   9mb  A-V:-0.031 [422:63]
  1 duplicate frame(s)!
  Pos: 118.9s   1787f (74%) 92.16fps Trem:   0min   9mb  A-V:-0.032 [422:64]
  1 duplicate frame(s)!
  Pos: 118.9s   1788f (74%) 92.16fps Trem:   0min   9mb  A-V:-0.027 [422:64]
  1 duplicate frame(s)!
  Pos: 119.0s   1789f (74%) 92.17fps Trem:   0min   9mb  A-V:-0.027 [422:64]
  1 duplicate frame(s)!
  Pos: 119.1s   1790f (74%) 92.17fps Trem:   0min   9mb  A-V:-0.033 [422:64]
  1 duplicate frame(s)!
  Pos: 119.1s   1791f (74%) 92.17fps Trem:   0min   9mb  A-V:-0.027 [422:64]
  1 duplicate frame(s)!
  Pos: 119.2s   1792f (74%) 92.19fps Trem:   0min   9mb  A-V:-0.024 [422:64]
  1 duplicate frame(s)!
  Pos: 119.3s   1793f (74%) 92.19fps Trem:   0min   9mb  A-V:-0.030 [422:63]
  1 duplicate frame(s)!
  Pos: 119.3s   1794f (75%) 92.19fps Trem:   0min   9mb  A-V:-0.024 [422:63]
  1 duplicate frame(s)!
  Pos: 119.4s   1795f (75%) 92.19fps Trem:   0min   9mb  A-V:-0.024 [422:63]
  1 duplicate frame(s)!
  Pos: 119.5s   1796f (75%) 92.21fps Trem:   0min   9mb  A-V:-0.029 [422:63]
  1 duplicate frame(s)!
  Pos: 119.5s   1797f (75%) 92.20fps Trem:   0min   9mb  A-V:-0.024 [422:63]
  1 duplicate frame(s)!
  Pos: 119.6s   1798f (75%) 92.21fps Trem:   0min   9mb  A-V:-0.024 [422:63]
  1 duplicate frame(s)!
  Pos: 119.7s   1799f (75%) 92.21fps Trem:   0min   9mb  A-V:-0.017 [422:63]
  1 duplicate frame(s)!
  Pos: 119.7s   1800f (75%) 92.21fps Trem:   0min   9mb  A-V:-0.017 [422:63]
  1 duplicate frame(s)!
  Pos: 119.8s   1801f (75%) 92.22fps Trem:   0min   9mb  A-V:-0.020 [422:63]
  1 duplicate frame(s)!
  Pos: 119.9s   1802f (75%) 92.21fps Trem:   0min   9mb  A-V:-0.019 [422:63]
  1 duplicate frame(s)!
  Pos: 119.9s   1803f (75%) 92.23fps Trem:   0min   9mb  A-V:-0.022 [422:63]
  1 duplicate frame(s)!
  Pos: 120.0s   1804f (75%) 92.22fps Trem:   0min   9mb  A-V:-0.018 [422:63]
  1 duplicate frame(s)!
  Pos: 120.1s   1805f (75%) 92.23fps Trem:   0min   9mb  A-V:-0.019 [422:63]
  1 duplicate frame(s)!
  Pos: 120.1s   1806f (75%) 92.23fps Trem:   0min   9mb  A-V:-0.013 [422:63]
  1 duplicate frame(s)!
  Pos: 120.2s   1807f (75%) 92.23fps Trem:   0min   9mb  A-V:-0.013 [422:64]
  1 duplicate frame(s)!
  Pos: 120.3s   1808f (75%) 92.24fps Trem:   0min   9mb  A-V:-0.017 [422:64]
  1 duplicate frame(s)!
  Pos: 120.3s   1809f (75%) 92.23fps Trem:   0min   9mb  A-V:-0.010 [422:64]
  1 duplicate frame(s)!
  Pos: 120.4s   1810f (75%) 92.24fps Trem:   0min   9mb  A-V:-0.009 [422:64]
  1 duplicate frame(s)!
  Pos: 120.5s   1811f (75%) 92.24fps Trem:   0min   9mb  A-V:-0.015 [421:64]
  1 duplicate frame(s)!
  Pos: 120.5s   1812f (75%) 92.26fps Trem:   0min   9mb  A-V:-0.022 [421:64]
  1 duplicate frame(s)!
  Pos: 120.6s   1813f (75%) 92.25fps Trem:   0min   9mb  A-V:-0.019 [421:64]
  1 duplicate frame(s)!
  Pos: 120.7s   1814f (75%) 92.26fps Trem:   0min   9mb  A-V:-0.020 [421:64]
  1 duplicate frame(s)!
  Pos: 120.7s   1815f (75%) 92.26fps Trem:   0min   9mb  A-V:-0.016 [421:63]
  1 duplicate frame(s)!
  Pos: 120.8s   1816f (75%) 92.26fps Trem:   0min   9mb  A-V:-0.021 [421:63]
  1 duplicate frame(s)!
  Pos: 120.9s   1817f (75%) 92.28fps Trem:   0min   9mb  A-V:-0.028 [421:63]
  1 duplicate frame(s)!
  Pos: 120.9s   1818f (75%) 92.27fps Trem:   0min   9mb  A-V:-0.025 [421:63]
  1 duplicate frame(s)!
  Pos: 121.0s   1819f (75%) 92.28fps Trem:   0min   9mb  A-V:-0.026 [421:63]
  1 duplicate frame(s)!
  Pos: 121.1s   1820f (76%) 92.28fps Trem:   0min   9mb  A-V:-0.019 [421:63]
  1 duplicate frame(s)!
  Pos: 121.1s   1821f (76%) 92.29fps Trem:   0min   9mb  A-V:-0.015 [421:63]
  1 duplicate frame(s)!
  Pos: 121.2s   1822f (76%) 92.29fps Trem:   0min   9mb  A-V:-0.008 [421:63]
  1 duplicate frame(s)!
  Pos: 121.3s   1823f (76%) 92.29fps Trem:   0min   9mb  A-V:-0.009 [421:63]
  1 duplicate frame(s)!
  Pos: 121.3s   1824f (76%) 92.30fps Trem:   0min   9mb  A-V:-0.013 [421:63]
  1 duplicate frame(s)!
  Pos: 121.4s   1825f (76%) 92.30fps Trem:   0min   9mb  A-V:-0.020 [421:64]
  1 duplicate frame(s)!
  Pos: 121.5s   1826f (76%) 92.31fps Trem:   0min   9mb  A-V:-0.013 [421:64]
  1 duplicate frame(s)!
  Pos: 121.5s   1827f (76%) 92.30fps Trem:   0min   9mb  A-V:-0.006 [421:64]
  1 duplicate frame(s)!
  Pos: 121.6s   1828f (76%) 92.31fps Trem:   0min   9mb  A-V:-0.004 [421:63]
  1 duplicate frame(s)!
  Pos: 121.7s   1829f (76%) 92.31fps Trem:   0min   9mb  A-V:-0.010 [421:64]
  1 duplicate frame(s)!
  Pos: 121.7s   1830f (76%) 92.31fps Trem:   0min   9mb  A-V:-0.006 [421:64]
  1 duplicate frame(s)!
  Pos: 121.8s   1831f (76%) 92.32fps Trem:   0min   9mb  A-V:-0.006 [421:64]
  1 duplicate frame(s)!
  Pos: 121.9s   1832f (76%) 92.32fps Trem:   0min   9mb  A-V:-0.013 [421:64]
  1 duplicate frame(s)!
  Pos: 121.9s   1833f (76%) 92.33fps Trem:   0min   9mb  A-V:-0.007 [420:64]
  1 duplicate frame(s)!
  Pos: 122.0s   1834f (76%) 92.33fps Trem:   0min   9mb  A-V:-0.009 [420:64]
  1 duplicate frame(s)!
  Pos: 122.1s   1835f (76%) 92.34fps Trem:   0min   9mb  A-V:-0.016 [420:64]
  1 duplicate frame(s)!
  Pos: 122.1s   1836f (77%) 92.33fps Trem:   0min   9mb  A-V:-0.014 [420:64]
  1 duplicate frame(s)!
  Pos: 122.2s   1837f (77%) 92.34fps Trem:   0min   9mb  A-V:-0.016 [420:64]
  1 duplicate frame(s)!
  Pos: 122.3s   1838f (77%) 92.34fps Trem:   0min   9mb  A-V:-0.023 [420:64]
  1 duplicate frame(s)!
  Pos: 122.3s   1839f (77%) 92.34fps Trem:   0min   9mb  A-V:-0.030 [420:64]
  1 duplicate frame(s)!
  Pos: 122.4s   1840f (77%) 92.35fps Trem:   0min   9mb  A-V:-0.024 [420:64]
  1 duplicate frame(s)!
  Pos: 122.5s   1841f (77%) 92.35fps Trem:   0min   9mb  A-V:-0.027 [420:63]
  1 duplicate frame(s)!
  Pos: 122.5s   1842f (77%) 92.36fps Trem:   0min   9mb  A-V:-0.034 [420:63]
  1 duplicate frame(s)!
  Pos: 122.6s   1843f (77%) 92.36fps Trem:   0min   9mb  A-V:-0.030 [420:63]
  1 duplicate frame(s)!
  Pos: 122.7s   1844f (77%) 92.37fps Trem:   0min   9mb  A-V:-0.031 [420:63]
  1 duplicate frame(s)!
  Pos: 122.7s   1845f (77%) 92.37fps Trem:   0min   9mb  A-V:-0.038 [420:63]
  1 duplicate frame(s)!
  Pos: 122.8s   1846f (77%) 92.36fps Trem:   0min   9mb  A-V:-0.031 [420:63]
  1 duplicate frame(s)!
  Pos: 122.9s   1847f (77%) 92.37fps Trem:   0min   9mb  A-V:-0.029 [420:63]
  1 duplicate frame(s)!
  Pos: 122.9s   1848f (77%) 92.37fps Trem:   0min   9mb  A-V:-0.036 [420:63]
  1 duplicate frame(s)!
  Pos: 123.0s   1849f (77%) 92.38fps Trem:   0min   9mb  A-V:-0.029 [420:63]
  1 duplicate frame(s)!
  Pos: 123.1s   1850f (77%) 92.38fps Trem:   0min   9mb  A-V:-0.030 [420:63]
  1 duplicate frame(s)!
  Pos: 123.1s   1851f (77%) 92.38fps Trem:   0min   9mb  A-V:-0.035 [420:63]
  1 duplicate frame(s)!
  Pos: 123.2s   1852f (77%) 92.38fps Trem:   0min   9mb  A-V:-0.030 [420:63]
  1 duplicate frame(s)!
  Pos: 123.3s   1853f (77%) 92.39fps Trem:   0min   9mb  A-V:-0.029 [420:63]
  1 duplicate frame(s)!
  Pos: 123.3s   1854f (77%) 92.39fps Trem:   0min   9mb  A-V:-0.036 [420:63]
  1 duplicate frame(s)!
  Pos: 123.4s   1855f (77%) 92.39fps Trem:   0min   9mb  A-V:-0.029 [420:63]
  1 duplicate frame(s)!
  Pos: 123.5s   1856f (77%) 92.40fps Trem:   0min   9mb  A-V:-0.027 [420:63]
  1 duplicate frame(s)!
  Pos: 123.5s   1857f (77%) 92.40fps Trem:   0min   9mb  A-V:-0.033 [420:63]
  1 duplicate frame(s)!
  Pos: 123.6s   1858f (77%) 92.41fps Trem:   0min   9mb  A-V:-0.040 [420:63]
  1 duplicate frame(s)!
  Pos: 123.7s   1859f (77%) 92.41fps Trem:   0min   9mb  A-V:-0.033 [420:63]
  1 duplicate frame(s)!
  Pos: 123.7s   1860f (77%) 92.42fps Trem:   0min   9mb  A-V:-0.032 [420:63]
  1 duplicate frame(s)!
  Pos: 123.8s   1861f (77%) 92.41fps Trem:   0min   9mb  A-V:-0.025 [420:63]
  1 duplicate frame(s)!
  Pos: 123.9s   1862f (77%) 92.40fps Trem:   0min   9mb  A-V:-0.025 [420:63]
  1 duplicate frame(s)!
  Pos: 123.9s   1863f (77%) 92.41fps Trem:   0min   9mb  A-V:-0.030 [420:63]
  1 duplicate frame(s)!
  Pos: 124.0s   1864f (78%) 92.40fps Trem:   0min   9mb  A-V:-0.023 [420:63]
  1 duplicate frame(s)!
  Pos: 124.1s   1865f (78%) 92.40fps Trem:   0min   9mb  A-V:-0.019 [420:63]
  1 duplicate frame(s)!
  Pos: 124.1s   1866f (78%) 92.40fps Trem:   0min   9mb  A-V:-0.025 [420:63]
  1 duplicate frame(s)!
  Pos: 124.2s   1867f (78%) 92.40fps Trem:   0min   9mb  A-V:-0.018 [419:63]
  1 duplicate frame(s)!
  Pos: 124.3s   1868f (78%) 92.38fps Trem:   0min   9mb  A-V:-0.019 [419:63]
  1 duplicate frame(s)!
  Pos: 124.3s   1869f (78%) 92.37fps Trem:   0min   9mb  A-V:-0.026 [419:63]
  1 duplicate frame(s)!
  Pos: 124.4s   1870f (78%) 92.38fps Trem:   0min   9mb  A-V:-0.019 [419:63]
  1 duplicate frame(s)!
  Pos: 124.5s   1871f (78%) 92.38fps Trem:   0min   9mb  A-V:-0.017 [419:63]
  1 duplicate frame(s)!
  Pos: 124.5s   1872f (78%) 92.39fps Trem:   0min   9mb  A-V:-0.019 [419:63]
  1 duplicate frame(s)!
  Pos: 124.6s   1873f (78%) 92.38fps Trem:   0min   9mb  A-V:-0.026 [419:63]
  1 duplicate frame(s)!
  Pos: 124.7s   1874f (78%) 92.39fps Trem:   0min   9mb  A-V:-0.019 [419:63]
  1 duplicate frame(s)!
  Pos: 124.7s   1875f (78%) 92.36fps Trem:   0min   9mb  A-V:-0.019 [419:63]
  1 duplicate frame(s)!
  Pos: 124.8s   1876f (78%) 92.36fps Trem:   0min   9mb  A-V:-0.024 [419:63]
  1 duplicate frame(s)!
  Pos: 124.9s   1877f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.017 [419:63]
  1 duplicate frame(s)!
  Pos: 124.9s   1878f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.016 [419:63]
  1 duplicate frame(s)!
  Pos: 125.0s   1879f (78%) 92.36fps Trem:   0min   9mb  A-V:-0.020 [419:63]
  1 duplicate frame(s)!
  Pos: 125.1s   1880f (78%) 92.36fps Trem:   0min   9mb  A-V:-0.027 [419:63]
  1 duplicate frame(s)!
  Pos: 125.1s   1881f (78%) 92.36fps Trem:   0min   9mb  A-V:-0.020 [419:63]
  1 duplicate frame(s)!
  Pos: 125.2s   1882f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.021 [421:63]
  1 duplicate frame(s)!
  Pos: 125.3s   1883f (78%) 92.36fps Trem:   0min   9mb  A-V:-0.025 [421:63]
  1 duplicate frame(s)!
  Pos: 125.3s   1884f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.019 [421:63]
  1 duplicate frame(s)!
  Pos: 125.4s   1885f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.018 [421:63]
  1 duplicate frame(s)!
  Pos: 125.5s   1886f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.021 [421:63]
  1 duplicate frame(s)!
  Pos: 125.5s   1887f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.015 [421:63]
  1 duplicate frame(s)!
  Pos: 125.6s   1888f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.014 [421:63]
  1 duplicate frame(s)!
  Pos: 125.7s   1889f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.007 [421:63]
  1 duplicate frame(s)!
  Pos: 125.7s   1890f (78%) 92.35fps Trem:   0min   9mb  A-V:-0.004 [421:63]
  1 duplicate frame(s)!
  Pos: 125.8s   1891f (79%) 92.34fps Trem:   0min   9mb  A-V:0.002 [421:63]
  1 duplicate frame(s)!
  Pos: 125.9s   1892f (79%) 92.35fps Trem:   0min   9mb  A-V:0.004 [421:63]
  1 duplicate frame(s)!
  Pos: 125.9s   1893f (79%) 92.34fps Trem:   0min   9mb  A-V:0.011 [421:64]
  1 duplicate frame(s)!
  Pos: 126.0s   1894f (79%) 92.34fps Trem:   0min   9mb  A-V:0.009 [421:64]
  1 duplicate frame(s)!
  Pos: 126.1s   1895f (79%) 92.34fps Trem:   0min   9mb  A-V:0.004 [421:64]
  1 duplicate frame(s)!
  Pos: 126.1s   1896f (79%) 92.33fps Trem:   0min   9mb  A-V:0.002 [421:64]
  1 duplicate frame(s)!
  Pos: 126.2s   1897f (79%) 92.34fps Trem:   0min   9mb  A-V:-0.003 [421:64]
  1 duplicate frame(s)!
  Pos: 126.3s   1898f (79%) 92.34fps Trem:   0min   9mb  A-V:-0.001 [421:64]
  1 duplicate frame(s)!
  Pos: 126.3s   1899f (79%) 92.35fps Trem:   0min   9mb  A-V:-0.003 [421:64]
  1 duplicate frame(s)!
  Pos: 126.4s   1900f (79%) 92.34fps Trem:   0min   9mb  A-V:-0.000 [421:64]
  1 duplicate frame(s)!
  Pos: 126.5s   1901f (79%) 92.33fps Trem:   0min   9mb  A-V:0.006 [421:64]
  1 duplicate frame(s)!
  Pos: 126.5s   1902f (79%) 92.34fps Trem:   0min   9mb  A-V:0.010 [421:64]
  1 duplicate frame(s)!
  Pos: 126.6s   1903f (79%) 92.33fps Trem:   0min   9mb  A-V:0.005 [421:64]
  1 duplicate frame(s)!
  Pos: 126.7s   1904f (79%) 92.34fps Trem:   0min   9mb  A-V:-0.002 [421:64]
  1 duplicate frame(s)!
  Pos: 126.7s   1905f (79%) 92.33fps Trem:   0min   9mb  A-V:-0.000 [421:64]
  1 duplicate frame(s)!
  Pos: 126.8s   1906f (79%) 92.34fps Trem:   0min   9mb  A-V:-0.003 [421:64]
  1 duplicate frame(s)!
  Pos: 126.9s   1907f (79%) 92.33fps Trem:   0min   9mb  A-V:-0.001 [421:64]
  1 duplicate frame(s)!
  Pos: 126.9s   1908f (79%) 92.33fps Trem:   0min   9mb  A-V:-0.008 [421:64]
  1 duplicate frame(s)!
  Pos: 127.0s   1909f (79%) 92.34fps Trem:   0min   9mb  A-V:-0.014 [421:64]
  1 duplicate frame(s)!
  Pos: 127.1s   1910f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.009 [421:64]
  1 duplicate frame(s)!
  Pos: 127.1s   1911f (80%) 92.34fps Trem:   0min   9mb  A-V:-0.009 [421:64]
  1 duplicate frame(s)!
  Pos: 127.2s   1912f (80%) 92.34fps Trem:   0min   9mb  A-V:-0.015 [421:64]
  1 duplicate frame(s)!
  Pos: 127.3s   1913f (80%) 92.34fps Trem:   0min   9mb  A-V:-0.022 [421:64]
  1 duplicate frame(s)!
  Pos: 127.3s   1914f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.018 [421:64]
  1 duplicate frame(s)!
  Pos: 127.4s   1915f (80%) 92.34fps Trem:   0min   9mb  A-V:-0.019 [421:64]
  1 duplicate frame(s)!
  Pos: 127.5s   1916f (80%) 92.34fps Trem:   0min   9mb  A-V:-0.012 [421:64]
  1 duplicate frame(s)!
  Pos: 127.5s   1917f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.012 [421:64]
  1 duplicate frame(s)!
  Pos: 127.6s   1918f (80%) 92.34fps Trem:   0min   9mb  A-V:-0.017 [421:64]
  1 duplicate frame(s)!
  Pos: 127.7s   1919f (80%) 92.34fps Trem:   0min   9mb  A-V:-0.023 [421:64]
  1 duplicate frame(s)!
  Pos: 127.7s   1920f (80%) 92.34fps Trem:   0min   9mb  A-V:-0.017 [421:64]
  1 duplicate frame(s)!
  Pos: 127.8s   1921f (80%) 92.34fps Trem:   0min   9mb  A-V:-0.019 [421:64]
  1 duplicate frame(s)!
  Pos: 127.9s   1922f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.012 [421:64]
  1 duplicate frame(s)!
  Pos: 127.9s   1923f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.014 [421:64]
  1 duplicate frame(s)!
  Pos: 128.0s   1924f (80%) 92.32fps Trem:   0min   9mb  A-V:-0.007 [421:64]
  1 duplicate frame(s)!
  Pos: 128.1s   1925f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.004 [421:64]
  1 duplicate frame(s)!
  Pos: 128.1s   1926f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.011 [421:64]
  1 duplicate frame(s)!
  Pos: 128.2s   1927f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.017 [421:64]
  1 duplicate frame(s)!
  Pos: 128.3s   1928f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.016 [420:64]
  1 duplicate frame(s)!
  Pos: 128.3s   1929f (80%) 92.33fps Trem:   0min   9mb  A-V:-0.020 [420:64]
  1 duplicate frame(s)!
  Pos: 128.4s   1930f (81%) 92.33fps Trem:   0min   9mb  A-V:-0.013 [420:64]
  1 duplicate frame(s)!
  Pos: 128.5s   1931f (81%) 92.34fps Trem:   0min   9mb  A-V:-0.010 [420:64]
  1 duplicate frame(s)!
  Pos: 128.5s   1932f (81%) 92.33fps Trem:   0min   9mb  A-V:-0.016 [420:63]
  1 duplicate frame(s)!
  Pos: 128.6s   1933f (81%) 92.32fps Trem:   0min   9mb  A-V:-0.011 [420:63]
  1 duplicate frame(s)!
  Pos: 128.7s   1934f (81%) 92.33fps Trem:   0min   9mb  A-V:-0.010 [420:63]
  1 duplicate frame(s)!
  Pos: 128.7s   1935f (81%) 92.33fps Trem:   0min   9mb  A-V:-0.017 [420:63]
  1 duplicate frame(s)!
  Pos: 128.8s   1936f (81%) 92.33fps Trem:   0min   9mb  A-V:-0.012 [421:63]
  1 duplicate frame(s)!
  Pos: 128.9s   1937f (81%) 92.33fps Trem:   0min   9mb  A-V:-0.015 [420:63]
  1 duplicate frame(s)!
  Pos: 128.9s   1938f (81%) 92.33fps Trem:   0min   9mb  A-V:-0.009 [420:63]
  1 duplicate frame(s)!
  Pos: 129.0s   1939f (81%) 92.33fps Trem:   0min   9mb  A-V:-0.010 [420:63]
  1 duplicate frame(s)!
  Pos: 129.1s   1940f (81%) 92.33fps Trem:   0min   9mb  A-V:-0.004 [420:63]
  1 duplicate frame(s)!
  Pos: 129.1s   1941f (81%) 92.34fps Trem:   0min   9mb  A-V:-0.001 [420:63]
  1 duplicate frame(s)!
  Pos: 129.2s   1942f (81%) 92.34fps Trem:   0min   9mb  A-V:-0.007 [420:63]
  1 duplicate frame(s)!
  Pos: 129.3s   1943f (81%) 92.35fps Trem:   0min   9mb  A-V:-0.014 [420:63]
  1 duplicate frame(s)!
  Pos: 129.3s   1944f (81%) 92.34fps Trem:   0min   9mb  A-V:-0.012 [420:63]
  1 duplicate frame(s)!
  Pos: 129.4s   1945f (81%) 92.35fps Trem:   0min   9mb  A-V:-0.015 [420:63]
  1 duplicate frame(s)!
  Pos: 129.5s   1946f (81%) 92.35fps Trem:   0min   9mb  A-V:-0.012 [420:63]
  1 duplicate frame(s)!
  Pos: 129.5s   1947f (81%) 92.35fps Trem:   0min   9mb  A-V:-0.013 [420:63]
  1 duplicate frame(s)!
  Pos: 129.6s   1948f (81%) 92.35fps Trem:   0min   9mb  A-V:-0.020 [420:63]
  1 duplicate frame(s)!
  Pos: 129.7s   1949f (81%) 92.35fps Trem:   0min   9mb  A-V:-0.013 [420:63]
  1 duplicate frame(s)!
  Pos: 129.7s   1950f (81%) 92.36fps Trem:   0min   9mb  A-V:-0.012 [420:63]
  1 duplicate frame(s)!
  Pos: 129.8s   1951f (81%) 92.36fps Trem:   0min   9mb  A-V:-0.018 [420:63]
  1 duplicate frame(s)!
  Pos: 129.9s   1952f (81%) 92.37fps Trem:   0min   9mb  A-V:-0.025 [420:63]
  1 duplicate frame(s)!
  Pos: 129.9s   1953f (81%) 92.36fps Trem:   0min   9mb  A-V:-0.021 [420:63]
  1 duplicate frame(s)!
  Pos: 130.0s   1954f (81%) 92.37fps Trem:   0min   9mb  A-V:-0.021 [420:63]
  1 duplicate frame(s)!
  Pos: 130.1s   1955f (81%) 92.37fps Trem:   0min   9mb  A-V:-0.027 [420:63]
  1 duplicate frame(s)!
  Pos: 130.1s   1956f (81%) 92.37fps Trem:   0min   9mb  A-V:-0.021 [420:63]
  1 duplicate frame(s)!
  Pos: 130.2s   1957f (81%) 92.37fps Trem:   0min   9mb  A-V:-0.014 [420:63]
  1 duplicate frame(s)!
  Pos: 130.3s   1958f (81%) 92.36fps Trem:   0min   9mb  A-V:-0.017 [420:63]
  1 duplicate frame(s)!
  Pos: 130.3s   1959f (81%) 92.36fps Trem:   0min   9mb  A-V:-0.024 [420:63]
  1 duplicate frame(s)!
  Pos: 130.4s   1960f (81%) 92.36fps Trem:   0min   9mb  A-V:-0.020 [420:63]
  1 duplicate frame(s)!
  Pos: 130.5s   1961f (81%) 92.36fps Trem:   0min   9mb  A-V:-0.021 [420:63]
  1 duplicate frame(s)!
  Pos: 130.5s   1962f (81%) 92.36fps Trem:   0min   9mb  A-V:-0.018 [420:63]
  1 duplicate frame(s)!
  Pos: 130.6s   1963f (82%) 92.35fps Trem:   0min   9mb  A-V:-0.012 [420:63]
  1 duplicate frame(s)!
  Pos: 130.7s   1964f (82%) 92.37fps Trem:   0min   9mb  A-V:-0.007 [419:63]
  1 duplicate frame(s)!
  Pos: 130.7s   1965f (82%) 92.37fps Trem:   0min   9mb  A-V:-0.011 [419:63]
  1 duplicate frame(s)!
  Pos: 130.8s   1966f (82%) 92.37fps Trem:   0min   9mb  A-V:-0.005 [419:63]
  1 duplicate frame(s)!
  Pos: 130.9s   1967f (82%) 92.37fps Trem:   0min   9mb  A-V:-0.008 [419:63]
  1 duplicate frame(s)!
  Pos: 130.9s   1968f (82%) 92.38fps Trem:   0min   9mb  A-V:-0.002 [419:63]
  1 duplicate frame(s)!
  Pos: 131.0s   1969f (82%) 92.38fps Trem:   0min   9mb  A-V:-0.006 [419:63]
  1 duplicate frame(s)!
  Pos: 131.1s   1970f (82%) 92.38fps Trem:   0min   9mb  A-V:0.001 [419:63]
  1 duplicate frame(s)!
  Pos: 131.1s   1971f (82%) 92.38fps Trem:   0min   9mb  A-V:-0.001 [419:63]
  1 duplicate frame(s)!
  Pos: 131.2s   1972f (82%) 92.38fps Trem:   0min   9mb  A-V:0.002 [419:63]
  1 duplicate frame(s)!
  Pos: 131.3s   1973f (82%) 92.39fps Trem:   0min   9mb  A-V:0.001 [419:63]
  1 duplicate frame(s)!
  Pos: 131.3s   1974f (82%) 92.39fps Trem:   0min   9mb  A-V:0.005 [419:64]
  1 duplicate frame(s)!
  Pos: 131.4s   1975f (82%) 92.39fps Trem:   0min   9mb  A-V:0.004 [419:64]
  1 duplicate frame(s)!
  Pos: 131.5s   1976f (82%) 92.39fps Trem:   0min   9mb  A-V:-0.002 [419:64]
  1 duplicate frame(s)!
  Pos: 131.5s   1977f (82%) 92.40fps Trem:   0min   9mb  A-V:0.002 [419:64]
  1 duplicate frame(s)!
  Pos: 131.6s   1978f (82%) 92.40fps Trem:   0min   9mb  A-V:-0.002 [419:64]
  1 duplicate frame(s)!
  Pos: 131.7s   1979f (82%) 92.39fps Trem:   0min   9mb  A-V:0.005 [419:64]
  1 duplicate frame(s)!
  Pos: 131.7s   1980f (82%) 92.39fps Trem:   0min   9mb  A-V:0.007 [419:64]
  1 duplicate frame(s)!
  Pos: 131.8s   1981f (82%) 92.39fps Trem:   0min   9mb  A-V:0.001 [418:64]
  1 duplicate frame(s)!
  Pos: 131.9s   1982f (82%) 92.40fps Trem:   0min   9mb  A-V:-0.005 [419:64]
  1 duplicate frame(s)!
  Pos: 131.9s   1983f (82%) 92.39fps Trem:   0min   9mb  A-V:-0.006 [418:64]
  1 duplicate frame(s)!
  Pos: 132.0s   1984f (82%) 92.40fps Trem:   0min   9mb  A-V:-0.010 [418:64]
  1 duplicate frame(s)!
  Pos: 132.1s   1985f (82%) 92.39fps Trem:   0min   9mb  A-V:-0.004 [419:64]
  1 duplicate frame(s)!
  Pos: 132.1s   1986f (82%) 92.40fps Trem:   0min   9mb  A-V:-0.001 [418:64]
  1 duplicate frame(s)!
  Pos: 132.2s   1987f (83%) 92.40fps Trem:   0min   9mb  A-V:0.005 [418:64]
  1 duplicate frame(s)!
  Pos: 132.3s   1989f (83%) 92.42fps Trem:   0min   9mb  A-V:-0.004 [418:64]
  2 duplicate frame(s)!
  Pos: 132.4s   1990f (83%) 92.42fps Trem:   0min   9mb  A-V:-0.011 [418:64]
  1 duplicate frame(s)!
  Pos: 132.5s   1992f (83%) 92.42fps Trem:   0min   9mb  A-V:-0.003 [418:64]
  1 duplicate frame(s)!
  Pos: 132.6s   1993f (83%) 92.43fps Trem:   0min   9mb  A-V:-0.001 [418:64]
  2 duplicate frame(s)!
  Pos: 132.7s   1995f (83%) 92.43fps Trem:   0min   9mb  A-V:-0.000 [418:64]
  1 duplicate frame(s)!
  Pos: 132.8s   1996f (83%) 92.45fps Trem:   0min   9mb  A-V:0.003 [418:64]
  2 duplicate frame(s)!
  Pos: 132.9s   1998f (83%) 92.44fps Trem:   0min   9mb  A-V:-0.010 [418:64]
  1 duplicate frame(s)!
  Pos: 133.0s   1999f (83%) 92.45fps Trem:   0min   9mb  A-V:-0.003 [418:64]
  1 duplicate frame(s)!
  Pos: 133.0s   2000f (83%) 92.45fps Trem:   0min   9mb  A-V:-0.006 [418:64]
  1 duplicate frame(s)!
  Pos: 133.1s   2001f (83%) 92.45fps Trem:   0min   9mb  A-V:-0.013 [418:63]
  1 duplicate frame(s)!
  Pos: 133.2s   2002f (83%) 92.45fps Trem:   0min   9mb  A-V:-0.009 [418:63]
  1 duplicate frame(s)!
  Pos: 133.2s   2003f (83%) 92.46fps Trem:   0min   9mb  A-V:-0.011 [418:63]
  1 duplicate frame(s)!
  Pos: 133.3s   2004f (83%) 92.46fps Trem:   0min   9mb  A-V:-0.017 [418:63]
  1 duplicate frame(s)!
  Pos: 133.4s   2005f (83%) 92.47fps Trem:   0min   9mb  A-V:-0.024 [418:63]
  1 duplicate frame(s)!
  Pos: 133.4s   2006f (83%) 92.46fps Trem:   0min   9mb  A-V:-0.021 [418:63]
  1 duplicate frame(s)!
  Pos: 133.5s   2007f (83%) 92.45fps Trem:   0min   9mb  A-V:-0.027 [420:63]
  1 duplicate frame(s)!
  Pos: 133.6s   2008f (83%) 92.47fps Trem:   0min   9mb  A-V:-0.033 [419:63]
  1 duplicate frame(s)!
  Pos: 133.6s   2009f (84%) 92.47fps Trem:   0min   9mb  A-V:-0.030 [419:63]
  1 duplicate frame(s)!
  Pos: 133.7s   2010f (84%) 92.48fps Trem:   0min   9mb  A-V:-0.031 [419:63]
  1 duplicate frame(s)!
  Pos: 133.8s   2011f (84%) 92.48fps Trem:   0min   9mb  A-V:-0.037 [419:63]
  1 duplicate frame(s)!
  Pos: 133.8s   2012f (84%) 92.49fps Trem:   0min   9mb  A-V:-0.031 [419:63]
  1 duplicate frame(s)!
  Pos: 133.9s   2013f (84%) 92.49fps Trem:   0min   9mb  A-V:-0.030 [419:63]
  1 duplicate frame(s)!
  Pos: 134.0s   2014f (84%) 92.50fps Trem:   0min   9mb  A-V:-0.036 [419:63]
  1 duplicate frame(s)!
  Pos: 134.0s   2015f (84%) 92.50fps Trem:   0min   9mb  A-V:-0.043 [419:63]
  1 duplicate frame(s)!
  Pos: 134.1s   2016f (84%) 92.50fps Trem:   0min   9mb  A-V:-0.039 [419:63]
  1 duplicate frame(s)!
  Pos: 134.2s   2017f (84%) 92.51fps Trem:   0min   9mb  A-V:-0.039 [419:63]
  1 duplicate frame(s)!
  Pos: 134.2s   2018f (84%) 92.50fps Trem:   0min   9mb  A-V:-0.046 [419:63]
  1 duplicate frame(s)!
  Pos: 134.3s   2019f (84%) 92.51fps Trem:   0min   9mb  A-V:-0.039 [419:63]
  1 duplicate frame(s)!
  Pos: 134.4s   2020f (84%) 92.51fps Trem:   0min   9mb  A-V:-0.037 [419:63]
  1 duplicate frame(s)!
  Pos: 134.4s   2021f (84%) 92.52fps Trem:   0min   9mb  A-V:-0.039 [419:63]
  1 duplicate frame(s)!
  Pos: 134.5s   2022f (84%) 92.52fps Trem:   0min   9mb  A-V:-0.045 [419:63]
  1 duplicate frame(s)!
  Pos: 134.6s   2023f (84%) 92.52fps Trem:   0min   9mb  A-V:-0.040 [419:63]
  1 duplicate frame(s)!
  Pos: 134.6s   2024f (84%) 92.53fps Trem:   0min   9mb  A-V:-0.040 [419:63]
  1 duplicate frame(s)!
  Pos: 134.7s   2025f (84%) 92.52fps Trem:   0min   9mb  A-V:-0.033 [419:63]
  1 duplicate frame(s)!
  Pos: 134.8s   2026f (84%) 92.53fps Trem:   0min   9mb  A-V:-0.028 [418:63]
  1 duplicate frame(s)!
  Pos: 134.8s   2027f (84%) 92.54fps Trem:   0min   9mb  A-V:-0.032 [418:63]
  1 duplicate frame(s)!
  Pos: 134.9s   2028f (84%) 92.54fps Trem:   0min   9mb  A-V:-0.038 [418:63]
  1 duplicate frame(s)!
  Pos: 135.0s   2029f (84%) 92.55fps Trem:   0min   9mb  A-V:-0.045 [418:63]
  1 duplicate frame(s)!
  Pos: 135.0s   2030f (84%) 92.55fps Trem:   0min   9mb  A-V:-0.040 [418:63]
  1 duplicate frame(s)!
  Pos: 135.1s   2031f (84%) 92.56fps Trem:   0min   9mb  A-V:-0.039 [418:63]
  1 duplicate frame(s)!
  Pos: 135.2s   2032f (84%) 92.56fps Trem:   0min   9mb  A-V:-0.034 [418:63]
  1 duplicate frame(s)!
  Pos: 135.2s   2033f (84%) 92.57fps Trem:   0min   9mb  A-V:-0.034 [418:63]
  1 duplicate frame(s)!
  Pos: 135.3s   2034f (84%) 92.57fps Trem:   0min   9mb  A-V:-0.040 [418:63]
  1 duplicate frame(s)!
  Pos: 135.4s   2035f (84%) 92.57fps Trem:   0min   9mb  A-V:-0.034 [418:63]
  1 duplicate frame(s)!
  Pos: 135.4s   2036f (84%) 92.57fps Trem:   0min   9mb  A-V:-0.033 [418:63]
  1 duplicate frame(s)!
  Pos: 135.5s   2037f (84%) 92.58fps Trem:   0min   9mb  A-V:-0.036 [418:63]
  1 duplicate frame(s)!
  Pos: 135.6s   2038f (85%) 92.57fps Trem:   0min   9mb  A-V:-0.030 [418:63]
  1 duplicate frame(s)!
  Pos: 135.6s   2039f (85%) 92.57fps Trem:   0min   9mb  A-V:-0.030 [418:63]
  1 duplicate frame(s)!
  Pos: 135.7s   2040f (85%) 92.58fps Trem:   0min   9mb  A-V:-0.035 [418:63]
  1 duplicate frame(s)!
  Pos: 135.8s   2041f (85%) 92.57fps Trem:   0min   9mb  A-V:-0.029 [418:63]
  1 duplicate frame(s)!
  Pos: 135.8s   2042f (85%) 92.58fps Trem:   0min   9mb  A-V:-0.029 [418:63]
  1 duplicate frame(s)!
  Pos: 135.9s   2043f (85%) 92.58fps Trem:   0min   9mb  A-V:-0.022 [418:63]
  1 duplicate frame(s)!
  Pos: 136.0s   2044f (85%) 92.59fps Trem:   0min   9mb  A-V:-0.017 [418:63]
  1 duplicate frame(s)!
  Pos: 136.0s   2045f (85%) 92.59fps Trem:   0min   9mb  A-V:-0.020 [418:63]
  1 duplicate frame(s)!
  Pos: 136.1s   2046f (85%) 92.59fps Trem:   0min   9mb  A-V:-0.027 [418:63]
  1 duplicate frame(s)!
  Pos: 136.2s   2047f (85%) 92.60fps Trem:   0min   9mb  A-V:-0.020 [418:63]
  1 duplicate frame(s)!
  Pos: 136.2s   2048f (85%) 92.59fps Trem:   0min   9mb  A-V:-0.021 [418:63]
  1 duplicate frame(s)!
  Pos: 136.3s   2049f (85%) 92.60fps Trem:   0min   9mb  A-V:-0.014 [418:63]
  1 duplicate frame(s)!
  Pos: 136.4s   2050f (85%) 92.61fps Trem:   0min   9mb  A-V:-0.015 [418:63]
  1 duplicate frame(s)!
  Pos: 136.4s   2051f (85%) 92.62fps Trem:   0min   9mb  A-V:-0.020 [418:64]
  1 duplicate frame(s)!
  Pos: 136.5s   2052f (85%) 92.61fps Trem:   0min   9mb  A-V:-0.014 [418:64]
  1 duplicate frame(s)!
  Pos: 136.6s   2053f (85%) 92.61fps Trem:   0min   9mb  A-V:-0.016 [418:64]
  1 duplicate frame(s)!
  Pos: 136.6s   2054f (85%) 92.62fps Trem:   0min   9mb  A-V:-0.023 [418:64]
  1 duplicate frame(s)!
  Pos: 136.7s   2055f (85%) 92.61fps Trem:   0min   9mb  A-V:-0.020 [418:64]
  1 duplicate frame(s)!
  Pos: 136.8s   2056f (85%) 92.62fps Trem:   0min   9mb  A-V:-0.021 [418:64]
  1 duplicate frame(s)!
  Pos: 136.8s   2057f (86%) 92.62fps Trem:   0min   9mb  A-V:-0.015 [418:64]
  1 duplicate frame(s)!
  Pos: 136.9s   2058f (86%) 92.63fps Trem:   0min   9mb  A-V:-0.010 [418:64]
  1 duplicate frame(s)!
  Pos: 137.0s   2059f (86%) 92.62fps Trem:   0min   9mb  A-V:-0.004 [418:64]
  1 duplicate frame(s)!
  Pos: 137.0s   2060f (86%) 92.63fps Trem:   0min   9mb  A-V:-0.001 [417:64]
  1 duplicate frame(s)!
  Pos: 137.1s   2061f (86%) 92.62fps Trem:   0min   9mb  A-V:-0.007 [417:64]
  1 duplicate frame(s)!
  Pos: 137.2s   2062f (86%) 92.61fps Trem:   0min   9mb  A-V:-0.006 [417:64]
  1 duplicate frame(s)!
  Pos: 137.2s   2063f (86%) 92.62fps Trem:   0min   9mb  A-V:0.000 [417:64]
  1 duplicate frame(s)!
  Pos: 137.3s   2064f (86%) 92.59fps Trem:   0min   9mb  A-V:-0.002 [417:64]
  1 duplicate frame(s)!
  Pos: 137.4s   2065f (86%) 92.59fps Trem:   0min   9mb  A-V:-0.009 [417:64]
  1 duplicate frame(s)!
  Pos: 137.4s   2066f (86%) 92.58fps Trem:   0min   9mb  A-V:-0.005 [417:64]
  1 duplicate frame(s)!
  Pos: 137.5s   2067f (86%) 92.59fps Trem:   0min   9mb  A-V:-0.006 [417:64]
  1 duplicate frame(s)!
  Pos: 137.6s   2068f (86%) 92.59fps Trem:   0min   9mb  A-V:-0.003 [417:64]
  1 duplicate frame(s)!
  Pos: 137.6s   2069f (86%) 92.59fps Trem:   0min   9mb  A-V:-0.009 [417:64]
  1 duplicate frame(s)!
  Pos: 137.7s   2070f (86%) 92.60fps Trem:   0min   9mb  A-V:-0.016 [417:64]
  1 duplicate frame(s)!
  Pos: 137.8s   2071f (86%) 92.59fps Trem:   0min   9mb  A-V:-0.013 [417:64]
  1 duplicate frame(s)!
  Pos: 137.8s   2072f (86%) 92.60fps Trem:   0min   9mb  A-V:-0.015 [417:64]
  1 duplicate frame(s)!
  Pos: 137.9s   2073f (86%) 92.60fps Trem:   0min   9mb  A-V:-0.008 [417:64]
  1 duplicate frame(s)!
  Pos: 138.0s   2074f (86%) 92.61fps Trem:   0min   9mb  A-V:-0.005 [417:64]
  1 duplicate frame(s)!
  Pos: 138.0s   2075f (86%) 92.61fps Trem:   0min   9mb  A-V:-0.011 [417:64]
  1 duplicate frame(s)!
  Pos: 138.1s   2076f (86%) 92.60fps Trem:   0min   9mb  A-V:-0.017 [417:64]
  1 duplicate frame(s)!
  Pos: 138.2s   2077f (87%) 92.60fps Trem:   0min   9mb  A-V:-0.011 [417:64]
  1 duplicate frame(s)!
  Pos: 138.2s   2078f (87%) 92.59fps Trem:   0min   9mb  A-V:-0.014 [417:63]
  1 duplicate frame(s)!
  Pos: 138.3s   2079f (87%) 92.61fps Trem:   0min   9mb  A-V:-0.021 [417:63]
  1 duplicate frame(s)!
  Pos: 138.4s   2080f (87%) 92.60fps Trem:   0min   9mb  A-V:-0.017 [417:63]
  1 duplicate frame(s)!
  Pos: 138.4s   2081f (87%) 92.61fps Trem:   0min   9mb  A-V:-0.017 [417:63]
  1 duplicate frame(s)!
  Pos: 138.5s   2082f (87%) 92.61fps Trem:   0min   9mb  A-V:-0.023 [417:63]
  1 duplicate frame(s)!
  Pos: 138.6s   2083f (87%) 92.61fps Trem:   0min   9mb  A-V:-0.017 [417:63]
  1 duplicate frame(s)!
  Pos: 138.6s   2084f (87%) 92.61fps Trem:   0min   9mb  A-V:-0.015 [417:63]
  1 duplicate frame(s)!
  Pos: 138.7s   2085f (87%) 92.62fps Trem:   0min   9mb  A-V:-0.021 [417:63]
  1 duplicate frame(s)!
  Pos: 138.8s   2086f (87%) 92.62fps Trem:   0min   9mb  A-V:-0.015 [417:63]
  1 duplicate frame(s)!
  Pos: 138.8s   2087f (87%) 92.62fps Trem:   0min   9mb  A-V:-0.016 [417:63]
  1 duplicate frame(s)!
  Pos: 138.9s   2088f (87%) 92.63fps Trem:   0min   9mb  A-V:-0.021 [417:63]
  1 duplicate frame(s)!
  Pos: 139.0s   2089f (87%) 92.62fps Trem:   0min   9mb  A-V:-0.017 [417:63]
  1 duplicate frame(s)!
  Pos: 139.0s   2090f (87%) 92.63fps Trem:   0min   9mb  A-V:-0.016 [417:63]
  1 duplicate frame(s)!
  Pos: 139.1s   2091f (87%) 92.62fps Trem:   0min   9mb  A-V:-0.023 [417:63]
  1 duplicate frame(s)!
  Pos: 139.2s   2092f (87%) 92.62fps Trem:   0min   9mb  A-V:-0.022 [417:63]
  1 duplicate frame(s)!
  Pos: 139.2s   2093f (87%) 92.63fps Trem:   0min   9mb  A-V:-0.026 [417:63]
  1 duplicate frame(s)!
  Pos: 139.3s   2094f (87%) 92.63fps Trem:   0min   9mb  A-V:-0.033 [417:63]
  1 duplicate frame(s)!
  Pos: 139.4s   2095f (87%) 92.64fps Trem:   0min   9mb  A-V:-0.026 [417:63]
  1 duplicate frame(s)!
  Pos: 139.4s   2096f (87%) 92.63fps Trem:   0min   9mb  A-V:-0.027 [417:63]
  1 duplicate frame(s)!
  Pos: 139.5s   2097f (87%) 92.64fps Trem:   0min   9mb  A-V:-0.031 [417:63]
  1 duplicate frame(s)!
  Pos: 139.6s   2098f (87%) 92.64fps Trem:   0min   9mb  A-V:-0.025 [417:63]
  1 duplicate frame(s)!
  Pos: 139.6s   2099f (87%) 92.65fps Trem:   0min   9mb  A-V:-0.024 [417:63]
  1 duplicate frame(s)!
  Pos: 139.7s   2100f (87%) 92.65fps Trem:   0min   9mb  A-V:-0.031 [417:63]
  1 duplicate frame(s)!
  Pos: 139.8s   2101f (87%) 92.65fps Trem:   0min   9mb  A-V:-0.024 [417:63]
  1 duplicate frame(s)!
  Pos: 139.8s   2102f (87%) 92.65fps Trem:   0min   9mb  A-V:-0.021 [417:63]
  1 duplicate frame(s)!
  Pos: 139.9s   2103f (87%) 92.65fps Trem:   0min   9mb  A-V:-0.027 [417:63]
  1 duplicate frame(s)!
  Pos: 140.0s   2104f (87%) 92.66fps Trem:   0min   9mb  A-V:-0.021 [417:63]
  1 duplicate frame(s)!
  Pos: 140.0s   2105f (87%) 92.66fps Trem:   0min   9mb  A-V:-0.020 [417:63]
  1 duplicate frame(s)!
  Pos: 140.1s   2106f (87%) 92.66fps Trem:   0min   9mb  A-V:-0.013 [417:63]
  1 duplicate frame(s)!
  Pos: 140.2s   2107f (87%) 92.66fps Trem:   0min   9mb  A-V:-0.013 [417:63]
  1 duplicate frame(s)!
  Pos: 140.2s   2108f (87%) 92.66fps Trem:   0min   9mb  A-V:-0.020 [417:63]
  1 duplicate frame(s)!
  Pos: 140.3s   2109f (87%) 92.66fps Trem:   0min   9mb  A-V:-0.013 [417:63]
  1 duplicate frame(s)!
  Pos: 140.4s   2110f (87%) 92.66fps Trem:   0min   9mb  A-V:-0.015 [417:63]
  1 duplicate frame(s)!
  Pos: 140.4s   2111f (87%) 92.67fps Trem:   0min   9mb  A-V:-0.009 [417:63]
  1 duplicate frame(s)!
  Pos: 140.5s   2112f (87%) 92.66fps Trem:   0min   9mb  A-V:-0.012 [417:63]
  1 duplicate frame(s)!
  Pos: 140.6s   2113f (87%) 92.67fps Trem:   0min   9mb  A-V:-0.019 [417:63]
  1 duplicate frame(s)!
  Pos: 140.6s   2114f (88%) 92.67fps Trem:   0min   9mb  A-V:-0.014 [417:63]
  1 duplicate frame(s)!
  Pos: 140.7s   2115f (88%) 92.67fps Trem:   0min   9mb  A-V:-0.014 [417:63]
  1 duplicate frame(s)!
  Pos: 140.8s   2116f (88%) 92.68fps Trem:   0min   9mb  A-V:-0.020 [417:63]
  1 duplicate frame(s)!
  Pos: 140.8s   2117f (88%) 92.67fps Trem:   0min   9mb  A-V:-0.018 [417:63]
  1 duplicate frame(s)!
  Pos: 140.9s   2118f (88%) 92.68fps Trem:   0min   9mb  A-V:-0.019 [417:63]
  1 duplicate frame(s)!
  Pos: 141.0s   2119f (88%) 92.67fps Trem:   0min   9mb  A-V:-0.013 [417:63]
  1 duplicate frame(s)!
  Pos: 141.0s   2120f (88%) 92.69fps Trem:   0min   9mb  A-V:-0.009 [417:63]
  1 duplicate frame(s)!
  Pos: 141.1s   2121f (88%) 92.68fps Trem:   0min   9mb  A-V:-0.015 [417:63]
  1 duplicate frame(s)!
  Pos: 141.2s   2122f (88%) 92.69fps Trem:   0min   9mb  A-V:-0.021 [417:63]
  1 duplicate frame(s)!
  Pos: 141.2s   2123f (88%) 92.69fps Trem:   0min   9mb  A-V:-0.015 [417:63]
  1 duplicate frame(s)!
  Pos: 141.3s   2124f (88%) 92.69fps Trem:   0min   9mb  A-V:-0.018 [417:63]
  1 duplicate frame(s)!
  Pos: 141.4s   2125f (88%) 92.70fps Trem:   0min   9mb  A-V:-0.024 [417:63]
  1 duplicate frame(s)!
  Pos: 141.4s   2126f (88%) 92.69fps Trem:   0min   9mb  A-V:-0.021 [417:63]
  1 duplicate frame(s)!
  Pos: 141.5s   2127f (88%) 92.70fps Trem:   0min   9mb  A-V:-0.023 [417:63]
  1 duplicate frame(s)!
  Pos: 141.6s   2128f (88%) 92.70fps Trem:   0min   9mb  A-V:-0.029 [417:63]
  1 duplicate frame(s)!
  Pos: 141.6s   2129f (89%) 92.70fps Trem:   0min   9mb  A-V:-0.022 [417:63]
  1 duplicate frame(s)!
  Pos: 141.7s   2130f (89%) 92.71fps Trem:   0min   9mb  A-V:-0.021 [417:63]
  1 duplicate frame(s)!
  Pos: 141.8s   2131f (89%) 92.70fps Trem:   0min   9mb  A-V:-0.028 [416:63]
  1 duplicate frame(s)!
  Pos: 141.8s   2132f (89%) 92.70fps Trem:   0min   9mb  A-V:-0.021 [418:63]
  1 duplicate frame(s)!
  Pos: 141.9s   2133f (89%) 92.71fps Trem:   0min   9mb  A-V:-0.023 [418:63]
  1 duplicate frame(s)!
  Pos: 142.0s   2134f (89%) 92.71fps Trem:   0min   9mb  A-V:-0.030 [418:63]
  1 duplicate frame(s)!
  Pos: 142.0s   2135f (89%) 92.71fps Trem:   0min   9mb  A-V:-0.023 [418:63]
  1 duplicate frame(s)!
  Pos: 142.1s   2136f (89%) 92.72fps Trem:   0min   9mb  A-V:-0.018 [418:63]
  1 duplicate frame(s)!
  Pos: 142.2s   2137f (89%) 92.72fps Trem:   0min   9mb  A-V:-0.022 [418:63]
  1 duplicate frame(s)!
  Pos: 142.2s   2138f (89%) 92.72fps Trem:   0min   9mb  A-V:-0.015 [418:63]
  1 duplicate frame(s)!
  Pos: 142.3s   2139f (89%) 92.72fps Trem:   0min   9mb  A-V:-0.015 [418:64]
  1 duplicate frame(s)!
  Pos: 142.4s   2140f (89%) 92.72fps Trem:   0min   9mb  A-V:-0.021 [418:64]
  1 duplicate frame(s)!
  Pos: 142.4s   2141f (89%) 92.74fps Trem:   0min   9mb  A-V:-0.028 [418:64]
  1 duplicate frame(s)!
  Pos: 142.5s   2142f (89%) 92.73fps Trem:   0min   9mb  A-V:-0.023 [418:64]
  1 duplicate frame(s)!
  Pos: 142.6s   2143f (89%) 92.74fps Trem:   0min   9mb  A-V:-0.023 [418:64]
  1 duplicate frame(s)!
  Pos: 142.6s   2144f (89%) 92.74fps Trem:   0min   9mb  A-V:-0.017 [418:64]
  1 duplicate frame(s)!
  Pos: 142.7s   2145f (89%) 92.75fps Trem:   0min   9mb  A-V:-0.013 [418:64]
  1 duplicate frame(s)!
  Pos: 142.8s   2146f (89%) 92.75fps Trem:   0min   9mb  A-V:-0.006 [417:63]
  1 duplicate frame(s)!
  Pos: 142.8s   2147f (89%) 92.75fps Trem:   0min   9mb  A-V:-0.006 [417:64]
  1 duplicate frame(s)!
  Pos: 142.9s   2148f (89%) 92.76fps Trem:   0min   9mb  A-V:-0.010 [417:63]
  1 duplicate frame(s)!
  Pos: 143.0s   2149f (89%) 92.76fps Trem:   0min   9mb  A-V:-0.004 [417:64]
  1 duplicate frame(s)!
  Pos: 143.0s   2150f (89%) 92.77fps Trem:   0min   9mb  A-V:-0.001 [417:63]
  1 duplicate frame(s)!
  Pos: 143.1s   2151f (89%) 92.76fps Trem:   0min   9mb  A-V:0.005 [417:63]
  1 duplicate frame(s)!
  Pos: 143.2s   2152f (89%) 92.76fps Trem:   0min   9mb  A-V:0.008 [417:63]
  1 duplicate frame(s)!
  Pos: 143.2s   2153f (89%) 92.76fps Trem:   0min   9mb  A-V:0.015 [417:63]
  1 duplicate frame(s)!
  Pos: 143.3s   2154f (89%) 92.77fps Trem:   0min   9mb  A-V:0.017 [417:64]
  1 duplicate frame(s)!
  Pos: 143.4s   2155f (89%) 92.77fps Trem:   0min   9mb  A-V:0.011 [417:63]
  1 duplicate frame(s)!
  Pos: 143.4s   2156f (90%) 92.77fps Trem:   0min   9mb  A-V:0.016 [417:63]
  1 duplicate frame(s)!
  Pos: 143.5s   2157f (90%) 92.78fps Trem:   0min   9mb  A-V:0.016 [417:63]
  1 duplicate frame(s)!
  Pos: 143.6s   2158f (90%) 92.78fps Trem:   0min   9mb  A-V:0.009 [417:63]
  1 duplicate frame(s)!
  Pos: 143.6s   2159f (90%) 92.79fps Trem:   0min   9mb  A-V:0.002 [417:63]
  1 duplicate frame(s)!
  Pos: 143.7s   2160f (90%) 92.79fps Trem:   0min   9mb  A-V:0.005 [417:63]
  1 duplicate frame(s)!
  Pos: 143.8s   2161f (90%) 92.80fps Trem:   0min   9mb  A-V:0.004 [417:63]
  1 duplicate frame(s)!
  Pos: 143.8s   2162f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.003 [417:63]
  1 duplicate frame(s)!
  Pos: 143.9s   2163f (90%) 92.78fps Trem:   0min   9mb  A-V:-0.002 [417:63]
  1 duplicate frame(s)!
  Pos: 144.0s   2164f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.005 [417:63]
  1 duplicate frame(s)!
  Pos: 144.0s   2165f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.012 [417:63]
  1 duplicate frame(s)!
  Pos: 144.1s   2166f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.005 [417:63]
  1 duplicate frame(s)!
  Pos: 144.2s   2167f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.007 [417:63]
  1 duplicate frame(s)!
  Pos: 144.2s   2168f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.012 [417:63]
  1 duplicate frame(s)!
  Pos: 144.3s   2169f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.006 [416:63]
  1 duplicate frame(s)!
  Pos: 144.4s   2170f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.006 [416:63]
  1 duplicate frame(s)!
  Pos: 144.4s   2171f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.011 [416:63]
  1 duplicate frame(s)!
  Pos: 144.5s   2172f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.004 [416:63]
  1 duplicate frame(s)!
  Pos: 144.6s   2173f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.002 [416:63]
  1 duplicate frame(s)!
  Pos: 144.6s   2174f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.009 [416:63]
  1 duplicate frame(s)!
  Pos: 144.7s   2175f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.015 [416:63]
  1 duplicate frame(s)!
  Pos: 144.8s   2176f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.011 [416:63]
  1 duplicate frame(s)!
  Pos: 144.8s   2177f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.012 [416:63]
  1 duplicate frame(s)!
  Pos: 144.9s   2178f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.019 [416:63]
  1 duplicate frame(s)!
  Pos: 145.0s   2179f (90%) 92.79fps Trem:   0min   9mb  A-V:-0.012 [416:63]
  1 duplicate frame(s)!
  Pos: 145.0s   2180f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.010 [416:63]
  1 duplicate frame(s)!
  Pos: 145.1s   2181f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.017 [416:63]
  1 duplicate frame(s)!
  Pos: 145.2s   2182f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.024 [416:63]
  1 duplicate frame(s)!
  Pos: 145.2s   2183f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.019 [416:63]
  1 duplicate frame(s)!
  Pos: 145.3s   2184f (90%) 92.81fps Trem:   0min   9mb  A-V:-0.019 [416:63]
  1 duplicate frame(s)!
  Pos: 145.4s   2185f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.012 [416:63]
  1 duplicate frame(s)!
  Pos: 145.4s   2186f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.011 [416:63]
  1 duplicate frame(s)!
  Pos: 145.5s   2187f (90%) 92.81fps Trem:   0min   9mb  A-V:-0.014 [416:63]
  1 duplicate frame(s)!
  Pos: 145.6s   2188f (90%) 92.80fps Trem:   0min   9mb  A-V:-0.021 [416:63]
  1 duplicate frame(s)!
  Pos: 145.6s   2189f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.014 [416:63]
  1 duplicate frame(s)!
  Pos: 145.7s   2190f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.016 [416:63]
  1 duplicate frame(s)!
  Pos: 145.8s   2191f (91%) 92.82fps Trem:   0min   9mb  A-V:-0.021 [416:63]
  1 duplicate frame(s)!
  Pos: 145.8s   2192f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.016 [416:63]
  1 duplicate frame(s)!
  Pos: 145.9s   2193f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.016 [416:63]
  1 duplicate frame(s)!
  Pos: 146.0s   2194f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.023 [416:63]
  1 duplicate frame(s)!
  Pos: 146.0s   2195f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.020 [416:63]
  1 duplicate frame(s)!
  Pos: 146.1s   2196f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.022 [415:63]
  1 duplicate frame(s)!
  Pos: 146.2s   2197f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.016 [415:63]
  1 duplicate frame(s)!
  Pos: 146.2s   2198f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.012 [415:63]
  1 duplicate frame(s)!
  Pos: 146.3s   2199f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.017 [415:63]
  1 duplicate frame(s)!
  Pos: 146.4s   2200f (91%) 92.82fps Trem:   0min   9mb  A-V:-0.011 [415:63]
  1 duplicate frame(s)!
  Pos: 146.4s   2201f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.011 [415:63]
  1 duplicate frame(s)!
  Pos: 146.5s   2202f (91%) 92.81fps Trem:   0min   9mb  A-V:-0.018 [415:63]
  1 duplicate frame(s)!
  Pos: 146.6s   2203f (91%) 92.82fps Trem:   0min   9mb  A-V:-0.024 [415:63]
  1 duplicate frame(s)!
  Pos: 146.6s   2204f (91%) 92.82fps Trem:   0min   9mb  A-V:-0.021 [415:63]
  1 duplicate frame(s)!
  Pos: 146.7s   2205f (91%) 92.82fps Trem:   0min   9mb  A-V:-0.022 [415:63]
  1 duplicate frame(s)!
  Pos: 146.8s   2206f (91%) 92.82fps Trem:   0min   9mb  A-V:-0.017 [415:63]
  1 duplicate frame(s)!
  Pos: 146.8s   2207f (91%) 92.82fps Trem:   0min   9mb  A-V:-0.017 [415:63]
  1 duplicate frame(s)!
  Pos: 146.9s   2208f (91%) 92.82fps Trem:   0min   9mb  A-V:-0.012 [415:63]
  1 duplicate frame(s)!
  Pos: 147.0s   2209f (91%) 92.82fps Trem:   0min   9mb  A-V:-0.016 [415:63]
  1 duplicate frame(s)!
  Pos: 147.0s   2210f (92%) 92.82fps Trem:   0min   9mb  A-V:-0.009 [415:63]
  1 duplicate frame(s)!
  Pos: 147.1s   2211f (92%) 92.81fps Trem:   0min   9mb  A-V:-0.012 [415:64]
  1 duplicate frame(s)!
  Pos: 147.2s   2212f (92%) 92.82fps Trem:   0min   9mb  A-V:-0.019 [415:63]
  1 duplicate frame(s)!
  Pos: 147.2s   2213f (92%) 92.82fps Trem:   0min   9mb  A-V:-0.016 [415:64]
  1 duplicate frame(s)!
  Pos: 147.3s   2214f (92%) 92.81fps Trem:   0min   9mb  A-V:-0.018 [415:64]
  1 duplicate frame(s)!
  Pos: 147.4s   2215f (92%) 92.81fps Trem:   0min   9mb  A-V:-0.011 [415:64]
  1 duplicate frame(s)!
  Pos: 147.4s   2216f (92%) 92.82fps Trem:   0min   9mb  A-V:-0.006 [414:64]
  1 duplicate frame(s)!
  Pos: 147.5s   2217f (92%) 92.81fps Trem:   0min   9mb  A-V:-0.011 [414:64]
  1 duplicate frame(s)!
  Pos: 147.6s   2218f (92%) 92.81fps Trem:   0min   9mb  A-V:-0.009 [414:64]
  1 duplicate frame(s)!
  Pos: 147.6s   2219f (92%) 92.81fps Trem:   0min   9mb  A-V:-0.012 [414:64]
  1 duplicate frame(s)!
  Pos: 147.7s   2220f (92%) 92.81fps Trem:   0min   9mb  A-V:-0.005 [414:64]
  1 duplicate frame(s)!
  Pos: 147.8s   2221f (92%) 92.82fps Trem:   0min   9mb  A-V:-0.003 [414:64]
  1 duplicate frame(s)!
  Pos: 147.8s   2222f (92%) 92.81fps Trem:   0min   9mb  A-V:0.000 [414:64]
  1 duplicate frame(s)!
  Pos: 147.9s   2223f (92%) 92.82fps Trem:   0min   9mb  A-V:-0.001 [414:64]
  1 duplicate frame(s)!
  Pos: 148.0s   2224f (92%) 92.82fps Trem:   0min   9mb  A-V:0.003 [414:64]
  1 duplicate frame(s)!
  Pos: 148.0s   2225f (92%) 92.82fps Trem:   0min   9mb  A-V:-0.002 [414:64]
  1 duplicate frame(s)!
  Pos: 148.1s   2226f (92%) 92.82fps Trem:   0min   9mb  A-V:0.003 [414:64]
  1 duplicate frame(s)!
  Pos: 148.2s   2227f (92%) 92.82fps Trem:   0min   9mb  A-V:-0.001 [414:64]
  1 duplicate frame(s)!
  Pos: 148.2s   2228f (93%) 92.83fps Trem:   0min   9mb  A-V:0.006 [414:64]
  1 duplicate frame(s)!
  Pos: 148.3s   2229f (93%) 92.83fps Trem:   0min   9mb  A-V:0.002 [414:64]
  1 duplicate frame(s)!
  Pos: 148.4s   2230f (93%) 92.84fps Trem:   0min   9mb  A-V:-0.004 [414:64]
  1 duplicate frame(s)!
  Pos: 148.4s   2231f (93%) 92.83fps Trem:   0min   9mb  A-V:0.003 [414:64]
  1 duplicate frame(s)!
  Pos: 148.5s   2232f (93%) 92.85fps Trem:   0min   9mb  A-V:0.005 [414:64]
  1 duplicate frame(s)!
  Pos: 148.6s   2233f (93%) 92.84fps Trem:   0min   9mb  A-V:-0.001 [414:64]
  1 duplicate frame(s)!
  Pos: 148.6s   2234f (93%) 92.84fps Trem:   0min   9mb  A-V:0.004 [414:64]
  1 duplicate frame(s)!
  Pos: 148.7s   2235f (93%) 92.85fps Trem:   0min   9mb  A-V:0.005 [414:64]
  1 duplicate frame(s)!
  Pos: 148.8s   2236f (93%) 92.85fps Trem:   0min   9mb  A-V:-0.002 [414:63]
  1 duplicate frame(s)!
  Pos: 148.8s   2237f (93%) 92.86fps Trem:   0min   9mb  A-V:0.005 [414:63]
  1 duplicate frame(s)!
  Pos: 148.9s   2238f (93%) 92.86fps Trem:   0min   9mb  A-V:0.002 [414:63]
  1 duplicate frame(s)!
  Pos: 149.0s   2239f (93%) 92.87fps Trem:   0min   9mb  A-V:-0.004 [414:64]
  1 duplicate frame(s)!
  Pos: 149.0s   2240f (93%) 92.86fps Trem:   0min   9mb  A-V:0.003 [414:63]
  1 duplicate frame(s)!
  Pos: 149.1s   2241f (93%) 92.86fps Trem:   0min   9mb  A-V:0.002 [414:63]
  1 duplicate frame(s)!
  Pos: 149.2s   2242f (93%) 92.87fps Trem:   0min   9mb  A-V:-0.002 [414:63]
  1 duplicate frame(s)!
  Pos: 149.2s   2243f (93%) 92.87fps Trem:   0min   9mb  A-V:0.004 [414:63]
  1 duplicate frame(s)!
  Pos: 149.3s   2244f (93%) 92.88fps Trem:   0min   9mb  A-V:0.005 [414:63]
  1 duplicate frame(s)!
  Pos: 149.4s   2245f (93%) 92.88fps Trem:   0min   9mb  A-V:-0.002 [414:63]
  1 duplicate frame(s)!
  Pos: 149.4s   2246f (93%) 92.88fps Trem:   0min   9mb  A-V:0.005 [414:63]
  1 duplicate frame(s)!
  Pos: 149.5s   2247f (93%) 92.87fps Trem:   0min   9mb  A-V:0.002 [414:63]
  1 duplicate frame(s)!
  Pos: 149.6s   2248f (93%) 92.87fps Trem:   0min   9mb  A-V:0.009 [414:63]
  1 duplicate frame(s)!
  Pos: 149.6s   2249f (93%) 92.88fps Trem:   0min   9mb  A-V:0.012 [414:63]
  1 duplicate frame(s)!
  Pos: 149.7s   2250f (93%) 92.87fps Trem:   0min   9mb  A-V:0.006 [414:63]
  1 duplicate frame(s)!
  Pos: 149.8s   2251f (93%) 92.87fps Trem:   0min   9mb  A-V:-0.000 [414:63]
  1 duplicate frame(s)!
  Pos: 149.8s   2252f (94%) 92.87fps Trem:   0min   9mb  A-V:0.005 [414:63]
  1 duplicate frame(s)!
  Pos: 149.9s   2253f (94%) 92.88fps Trem:   0min   9mb  A-V:0.006 [414:63]
  1 duplicate frame(s)!
  Pos: 150.0s   2254f (94%) 92.86fps Trem:   0min   9mb  A-V:-0.001 [414:63]
  1 duplicate frame(s)!
  Pos: 150.0s   2255f (94%) 92.87fps Trem:   0min   9mb  A-V:-0.007 [414:63]
  1 duplicate frame(s)!
  Pos: 150.1s   2256f (94%) 92.85fps Trem:   0min   9mb  A-V:-0.003 [414:63]
  1 duplicate frame(s)!
  Pos: 150.2s   2257f (94%) 92.84fps Trem:   0min   9mb  A-V:-0.007 [415:63]
  1 duplicate frame(s)!
  Pos: 150.3s   2258f (94%) 92.85fps Trem:   0min   9mb  A-V:-0.014 [415:63]
  1 duplicate frame(s)!
  Pos: 150.3s   2259f (94%) 92.84fps Trem:   0min   9mb  A-V:-0.007 [415:63]
  1 duplicate frame(s)!
  Pos: 150.4s   2260f (94%) 92.85fps Trem:   0min   9mb  A-V:-0.005 [415:63]
  1 duplicate frame(s)!
  Pos: 150.5s   2261f (94%) 92.85fps Trem:   0min   9mb  A-V:-0.012 [415:63]
  1 duplicate frame(s)!
  Pos: 150.5s   2262f (94%) 92.86fps Trem:   0min   9mb  A-V:-0.005 [415:63]
  1 duplicate frame(s)!
  Pos: 150.6s   2263f (94%) 92.86fps Trem:   0min   9mb  A-V:-0.007 [415:63]
  1 duplicate frame(s)!
  Pos: 150.7s   2264f (94%) 92.86fps Trem:   0min   9mb  A-V:-0.014 [415:63]
  1 duplicate frame(s)!
  Pos: 150.7s   2265f (94%) 92.87fps Trem:   0min   9mb  A-V:-0.020 [415:63]
  1 duplicate frame(s)!
  Pos: 150.8s   2266f (94%) 92.87fps Trem:   0min   9mb  A-V:-0.018 [415:63]
  1 duplicate frame(s)!
  Pos: 150.9s   2267f (94%) 92.87fps Trem:   0min   9mb  A-V:-0.020 [415:63]
  1 duplicate frame(s)!
  Pos: 150.9s   2268f (94%) 92.87fps Trem:   0min   9mb  A-V:-0.013 [415:63]
  1 duplicate frame(s)!
  Pos: 151.0s   2269f (94%) 92.88fps Trem:   0min   9mb  A-V:-0.010 [415:63]
  1 duplicate frame(s)!
  Pos: 151.1s   2270f (94%) 92.88fps Trem:   0min   9mb  A-V:-0.017 [415:63]
  1 duplicate frame(s)!
  Pos: 151.1s   2271f (94%) 92.88fps Trem:   0min   9mb  A-V:-0.010 [415:63]
  1 duplicate frame(s)!
  Pos: 151.2s   2272f (94%) 92.89fps Trem:   0min   9mb  A-V:-0.010 [415:63]
  1 duplicate frame(s)!
  Pos: 151.3s   2273f (94%) 92.89fps Trem:   0min   9mb  A-V:-0.016 [415:63]
  1 duplicate frame(s)!
  Pos: 151.3s   2274f (94%) 92.89fps Trem:   0min   9mb  A-V:-0.023 [415:63]
  1 duplicate frame(s)!
  Pos: 151.4s   2275f (94%) 92.89fps Trem:   0min   9mb  A-V:-0.020 [415:63]
  1 duplicate frame(s)!
  Pos: 151.5s   2276f (94%) 92.89fps Trem:   0min   9mb  A-V:-0.022 [415:63]
  1 duplicate frame(s)!
  Pos: 151.5s   2277f (94%) 92.89fps Trem:   0min   9mb  A-V:-0.029 [415:63]
  1 duplicate frame(s)!
  Pos: 151.6s   2278f (94%) 92.90fps Trem:   0min   9mb  A-V:-0.022 [415:63]
  1 duplicate frame(s)!
  Pos: 151.7s   2279f (94%) 92.90fps Trem:   0min   9mb  A-V:-0.021 [415:63]
  1 duplicate frame(s)!
  Pos: 151.7s   2280f (95%) 92.89fps Trem:   0min   9mb  A-V:-0.014 [415:63]
  1 duplicate frame(s)!
  Pos: 151.8s   2281f (95%) 92.90fps Trem:   0min   9mb  A-V:-0.013 [415:63]
  1 duplicate frame(s)!
  Pos: 151.9s   2282f (95%) 92.89fps Trem:   0min   9mb  A-V:-0.020 [415:63]
  1 duplicate frame(s)!
  Pos: 151.9s   2283f (95%) 92.90fps Trem:   0min   9mb  A-V:-0.013 [415:63]
  1 duplicate frame(s)!
  Pos: 152.0s   2284f (95%) 92.89fps Trem:   0min   9mb  A-V:-0.015 [415:63]
  1 duplicate frame(s)!
  Pos: 152.1s   2285f (95%) 92.90fps Trem:   0min   9mb  A-V:-0.021 [415:63]
  1 duplicate frame(s)!
  Pos: 152.1s   2286f (95%) 92.90fps Trem:   0min   9mb  A-V:-0.016 [415:63]
  1 duplicate frame(s)!
  Pos: 152.2s   2287f (95%) 92.91fps Trem:   0min   9mb  A-V:-0.015 [415:63]
  1 duplicate frame(s)!
  Pos: 152.3s   2288f (95%) 92.91fps Trem:   0min   9mb  A-V:-0.009 [415:63]
  1 duplicate frame(s)!
  Pos: 152.3s   2289f (95%) 92.90fps Trem:   0min   9mb  A-V:-0.013 [415:63]
  1 duplicate frame(s)!
  Pos: 152.4s   2290f (95%) 92.90fps Trem:   0min   9mb  A-V:-0.019 [415:63]
  1 duplicate frame(s)!
  Pos: 152.5s   2291f (95%) 92.90fps Trem:   0min   9mb  A-V:-0.016 [415:63]
  1 duplicate frame(s)!
  Pos: 152.5s   2292f (95%) 92.91fps Trem:   0min   9mb  A-V:-0.009 [415:63]
  1 duplicate frame(s)!
  Pos: 152.6s   2293f (95%) 92.91fps Trem:   0min   9mb  A-V:-0.010 [415:63]
  1 duplicate frame(s)!
  Pos: 152.7s   2294f (95%) 92.92fps Trem:   0min   9mb  A-V:-0.003 [415:63]
  1 duplicate frame(s)!
  Pos: 152.7s   2295f (95%) 92.91fps Trem:   0min   9mb  A-V:-0.004 [415:63]
  1 duplicate frame(s)!
  Pos: 152.8s   2296f (95%) 92.91fps Trem:   0min   9mb  A-V:-0.010 [415:63]
  1 duplicate frame(s)!
  Pos: 152.9s   2297f (95%) 92.92fps Trem:   0min   9mb  A-V:-0.004 [415:63]
  1 duplicate frame(s)!
  Pos: 152.9s   2298f (95%) 92.92fps Trem:   0min   9mb  A-V:-0.007 [415:63]
  1 duplicate frame(s)!
  Pos: 153.0s   2299f (95%) 92.92fps Trem:   0min   9mb  A-V:-0.014 [415:63]
  1 duplicate frame(s)!
  Pos: 153.1s   2300f (95%) 92.92fps Trem:   0min   9mb  A-V:-0.011 [415:64]
  1 duplicate frame(s)!
  Pos: 153.1s   2301f (95%) 92.93fps Trem:   0min   9mb  A-V:-0.013 [415:64]
  1 duplicate frame(s)!
  Pos: 153.2s   2302f (95%) 92.92fps Trem:   0min   9mb  A-V:-0.020 [415:64]
  1 duplicate frame(s)!
  Pos: 153.3s   2303f (95%) 92.92fps Trem:   0min   9mb  A-V:-0.014 [415:64]
  1 duplicate frame(s)!
  Pos: 153.3s   2304f (95%) 92.93fps Trem:   0min   9mb  A-V:-0.012 [415:64]
  1 duplicate frame(s)!
  Pos: 153.4s   2305f (95%) 92.93fps Trem:   0min   9mb  A-V:-0.019 [415:64]
  1 duplicate frame(s)!
  Pos: 153.5s   2306f (96%) 92.94fps Trem:   0min   9mb  A-V:-0.012 [415:64]
  1 duplicate frame(s)!
  Pos: 153.5s   2307f (96%) 92.93fps Trem:   0min   9mb  A-V:-0.015 [415:64]
  1 duplicate frame(s)!
  Pos: 153.6s   2308f (96%) 92.94fps Trem:   0min   9mb  A-V:-0.022 [415:64]
  1 duplicate frame(s)!
  Pos: 153.7s   2309f (96%) 92.94fps Trem:   0min   9mb  A-V:-0.017 [415:64]
  1 duplicate frame(s)!
  Pos: 153.7s   2310f (96%) 92.94fps Trem:   0min   9mb  A-V:-0.017 [415:64]
  1 duplicate frame(s)!
  Pos: 153.8s   2311f (96%) 92.95fps Trem:   0min   9mb  A-V:-0.023 [415:64]
  1 duplicate frame(s)!
  Pos: 153.9s   2312f (96%) 92.94fps Trem:   0min   9mb  A-V:-0.017 [415:64]
  1 duplicate frame(s)!
  Pos: 153.9s   2313f (96%) 92.95fps Trem:   0min   9mb  A-V:-0.016 [415:64]
  1 duplicate frame(s)!
  Pos: 154.0s   2314f (96%) 92.95fps Trem:   0min   9mb  A-V:-0.022 [415:64]
  1 duplicate frame(s)!
  Pos: 154.1s   2315f (96%) 92.95fps Trem:   0min   9mb  A-V:-0.029 [415:64]
  1 duplicate frame(s)!
  Pos: 154.1s   2316f (96%) 92.95fps Trem:   0min   9mb  A-V:-0.024 [415:64]
  1 duplicate frame(s)!
  Pos: 154.2s   2317f (96%) 92.96fps Trem:   0min   9mb  A-V:-0.024 [415:63]
  1 duplicate frame(s)!
  Pos: 154.3s   2318f (96%) 92.96fps Trem:   0min   9mb  A-V:-0.031 [415:63]
  1 duplicate frame(s)!
  Pos: 154.3s   2319f (96%) 92.96fps Trem:   0min   9mb  A-V:-0.024 [415:63]
  1 duplicate frame(s)!
  Pos: 154.4s   2320f (96%) 92.97fps Trem:   0min   9mb  A-V:-0.022 [415:63]
  1 duplicate frame(s)!
  Pos: 154.5s   2321f (96%) 92.97fps Trem:   0min   9mb  A-V:-0.028 [415:63]
  1 duplicate frame(s)!
  Pos: 154.5s   2322f (96%) 92.98fps Trem:   0min   9mb  A-V:-0.035 [415:63]
  1 duplicate frame(s)!
  Pos: 154.6s   2323f (96%) 92.97fps Trem:   0min   9mb  A-V:-0.031 [414:63]
  1 duplicate frame(s)!
  Pos: 154.7s   2324f (96%) 92.98fps Trem:   0min   9mb  A-V:-0.031 [414:63]
  1 duplicate frame(s)!
  Pos: 154.7s   2325f (96%) 92.98fps Trem:   0min   9mb  A-V:-0.037 [414:63]
  1 duplicate frame(s)!
  Pos: 154.8s   2326f (96%) 92.99fps Trem:   0min   9mb  A-V:-0.031 [414:63]
  1 duplicate frame(s)!
  Pos: 154.9s   2327f (96%) 92.99fps Trem:   0min   9mb  A-V:-0.029 [414:63]
  1 duplicate frame(s)!
  Pos: 154.9s   2328f (96%) 92.99fps Trem:   0min   9mb  A-V:-0.035 [414:63]
  1 duplicate frame(s)!
  Pos: 155.0s   2329f (96%) 92.99fps Trem:   0min   9mb  A-V:-0.028 [414:63]
  1 duplicate frame(s)!
  Pos: 155.1s   2330f (96%) 93.00fps Trem:   0min   9mb  A-V:-0.029 [414:63]
  1 duplicate frame(s)!
  Pos: 155.1s   2331f (96%) 93.00fps Trem:   0min   9mb  A-V:-0.034 [414:63]
  1 duplicate frame(s)!
  Pos: 155.2s   2332f (96%) 93.00fps Trem:   0min   9mb  A-V:-0.028 [414:63]
  1 duplicate frame(s)!
  Pos: 155.3s   2333f (96%) 93.01fps Trem:   0min   9mb  A-V:-0.023 [414:63]
  1 duplicate frame(s)!
  Pos: 155.3s   2334f (96%) 93.01fps Trem:   0min   9mb  A-V:-0.027 [414:63]
  1 duplicate frame(s)!
  Pos: 155.4s   2335f (96%) 93.01fps Trem:   0min   9mb  A-V:-0.034 [414:63]
  1 duplicate frame(s)!
  Pos: 155.5s   2336f (97%) 93.02fps Trem:   0min   9mb  A-V:-0.027 [414:63]
  1 duplicate frame(s)!
  Pos: 155.5s   2337f (97%) 93.01fps Trem:   0min   9mb  A-V:-0.028 [414:63]
  1 duplicate frame(s)!
  Pos: 155.6s   2338f (97%) 93.02fps Trem:   0min   9mb  A-V:-0.022 [414:63]
  1 duplicate frame(s)!
  Pos: 155.7s   2339f (97%) 93.02fps Trem:   0min   9mb  A-V:-0.023 [414:63]
  1 duplicate frame(s)!
  Pos: 155.7s   2340f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.016 [414:63]
  1 duplicate frame(s)!
  Pos: 155.8s   2341f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.016 [414:63]
  1 duplicate frame(s)!
  Pos: 155.9s   2342f (97%) 93.02fps Trem:   0min   9mb  A-V:-0.009 [414:63]
  1 duplicate frame(s)!
  Pos: 155.9s   2343f (97%) 93.02fps Trem:   0min   9mb  A-V:-0.005 [414:63]
  1 duplicate frame(s)!
  Pos: 156.0s   2344f (97%) 93.02fps Trem:   0min   9mb  A-V:-0.010 [414:63]
  1 duplicate frame(s)!
  Pos: 156.1s   2345f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.016 [414:63]
  1 duplicate frame(s)!
  Pos: 156.1s   2346f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.010 [414:63]
  1 duplicate frame(s)!
  Pos: 156.2s   2347f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.007 [414:63]
  1 duplicate frame(s)!
  Pos: 156.3s   2348f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.013 [414:63]
  1 duplicate frame(s)!
  Pos: 156.3s   2349f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.006 [414:63]
  1 duplicate frame(s)!
  Pos: 156.4s   2350f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.007 [414:63]
  1 duplicate frame(s)!
  Pos: 156.5s   2351f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.003 [414:63]
  1 duplicate frame(s)!
  Pos: 156.5s   2352f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.003 [414:63]
  1 duplicate frame(s)!
  Pos: 156.6s   2353f (97%) 93.03fps Trem:   0min   9mb  A-V:-0.010 [414:63]
  1 duplicate frame(s)!
  Pos: 156.7s   2354f (97%) 93.04fps Trem:   0min   9mb  A-V:-0.016 [413:63]
  1 duplicate frame(s)!
  Pos: 156.7s   2355f (98%) 93.04fps Trem:   0min   9mb  A-V:-0.012 [413:63]
  1 duplicate frame(s)!
  Pos: 156.8s   2356f (98%) 93.04fps Trem:   0min   9mb  A-V:-0.013 [413:63]
  1 duplicate frame(s)!
  Pos: 156.9s   2357f (98%) 93.04fps Trem:   0min   9mb  A-V:-0.008 [413:63]
  1 duplicate frame(s)!
  Pos: 156.9s   2358f (98%) 93.04fps Trem:   0min   9mb  A-V:-0.002 [413:63]
  1 duplicate frame(s)!
  Pos: 157.0s   2359f (98%) 93.04fps Trem:   0min   9mb  A-V:0.003 [413:63]
  1 duplicate frame(s)!
  Pos: 157.1s   2360f (98%) 93.04fps Trem:   0min   9mb  A-V:-0.001 [413:63]
  1 duplicate frame(s)!
  Pos: 157.1s   2361f (98%) 93.04fps Trem:   0min   9mb  A-V:0.005 [413:63]
  1 duplicate frame(s)!
  Pos: 157.2s   2362f (98%) 93.04fps Trem:   0min   9mb  A-V:0.011 [413:63]
  1 duplicate frame(s)!
  Pos: 157.3s   2363f (98%) 93.05fps Trem:   0min   9mb  A-V:0.012 [413:63]
  1 duplicate frame(s)!
  Pos: 157.3s   2364f (98%) 93.04fps Trem:   0min   9mb  A-V:0.018 [413:63]
  1 duplicate frame(s)!
  Pos: 157.4s   2365f (98%) 93.04fps Trem:   0min   9mb  A-V:0.020 [413:63]
  1 duplicate frame(s)!
  Pos: 157.5s   2366f (98%) 93.04fps Trem:   0min   9mb  A-V:0.026 [413:63]
  1 duplicate frame(s)!
  Pos: 157.5s   2367f (98%) 93.04fps Trem:   0min   9mb  A-V:0.024 [413:63]
  1 duplicate frame(s)!
  Pos: 157.6s   2368f (98%) 93.05fps Trem:   0min   9mb  A-V:0.017 [413:63]
  1 duplicate frame(s)!
  Pos: 157.7s   2369f (98%) 93.04fps Trem:   0min   9mb  A-V:0.017 [413:63]
  1 duplicate frame(s)!
  Pos: 157.7s   2370f (98%) 93.04fps Trem:   0min   9mb  A-V:0.012 [413:63]
  1 duplicate frame(s)!
  Pos: 157.8s   2371f (98%) 93.04fps Trem:   0min   9mb  A-V:0.006 [413:63]
  1 duplicate frame(s)!
  Pos: 157.9s   2372f (98%) 93.05fps Trem:   0min   9mb  A-V:0.012 [413:63]
  1 duplicate frame(s)!
  Pos: 157.9s   2373f (98%) 93.04fps Trem:   0min   9mb  A-V:0.008 [413:64]
  1 duplicate frame(s)!
  Pos: 158.0s   2374f (98%) 93.04fps Trem:   0min   9mb  A-V:0.015 [413:64]
  1 duplicate frame(s)!
  Pos: 158.1s   2375f (98%) 93.04fps Trem:   0min   9mb  A-V:0.018 [413:64]
  1 duplicate frame(s)!
  Pos: 158.1s   2376f (98%) 93.04fps Trem:   0min   9mb  A-V:0.012 [413:64]
  1 duplicate frame(s)!
  Pos: 158.2s   2377f (98%) 93.04fps Trem:   0min   9mb  A-V:0.017 [413:64]
  1 duplicate frame(s)!
  Pos: 158.3s   2378f (98%) 93.04fps Trem:   0min   9mb  A-V:0.012 [413:64]
  1 duplicate frame(s)!
  Pos: 158.3s   2379f (98%) 93.05fps Trem:   0min   9mb  A-V:0.006 [413:64]
  1 duplicate frame(s)!
  Pos: 158.4s   2380f (98%) 93.05fps Trem:   0min   9mb  A-V:0.012 [413:64]
  1 duplicate frame(s)!
  Pos: 158.5s   2381f (98%) 93.04fps Trem:   0min   9mb  A-V:0.009 [413:64]
  1 duplicate frame(s)!
  Pos: 158.5s   2382f (98%) 93.04fps Trem:   0min   9mb  A-V:0.002 [414:64]
  1 duplicate frame(s)!
  Pos: 158.6s   2383f (99%) 93.04fps Trem:   0min   9mb  A-V:0.007 [414:64]
  1 duplicate frame(s)!
  Pos: 158.7s   2384f (99%) 93.05fps Trem:   0min   9mb  A-V:0.007 [414:64]
  1 duplicate frame(s)!
  Pos: 158.7s   2385f (99%) 93.06fps Trem:   0min   9mb  A-V:-0.000 [414:64]
  1 duplicate frame(s)!
  Pos: 158.8s   2386f (99%) 93.06fps Trem:   0min   9mb  A-V:-0.007 [414:64]
  1 duplicate frame(s)!
  Pos: 158.9s   2387f (99%) 93.06fps Trem:   0min   9mb  A-V:-0.005 [414:64]
  1 duplicate frame(s)!
  Pos: 158.9s   2388f (99%) 93.07fps Trem:   0min   9mb  A-V:-0.007 [414:64]
  1 duplicate frame(s)!
  Pos: 159.0s   2389f (99%) 93.07fps Trem:   0min   9mb  A-V:-0.013 [414:64]
  1 duplicate frame(s)!
  Pos: 159.1s   2390f (99%) 93.07fps Trem:   0min   9mb  A-V:-0.008 [414:63]
  1 duplicate frame(s)!
  Pos: 159.1s   2391f (99%) 93.08fps Trem:   0min   9mb  A-V:-0.008 [414:63]
  1 duplicate frame(s)!
  Pos: 159.2s   2392f (99%) 93.08fps Trem:   0min   9mb  A-V:-0.014 [414:63]
  1 duplicate frame(s)!
  Pos: 159.3s   2393f (99%) 93.08fps Trem:   0min   9mb  A-V:-0.008 [414:63]
  1 duplicate frame(s)!
  Pos: 159.3s   2394f (99%) 93.09fps Trem:   0min   9mb  A-V:-0.011 [414:63]
  1 duplicate frame(s)!
  Pos: 159.4s   2395f (99%) 93.09fps Trem:   0min   9mb  A-V:-0.017 [414:63]
  1 duplicate frame(s)!
  Pos: 159.5s   2396f (99%) 93.09fps Trem:   0min   9mb  A-V:-0.011 [414:63]
  1 duplicate frame(s)!
  Pos: 159.5s   2397f (99%) 93.09fps Trem:   0min   9mb  A-V:-0.011 [414:63]
  1 duplicate frame(s)!
  Pos: 159.6s   2398f (99%) 93.10fps Trem:   0min   9mb  A-V:-0.015 [413:63]
  1 duplicate frame(s)!
  Pos: 159.7s   2399f (99%) 93.10fps Trem:   0min   9mb  A-V:-0.022 [413:63]
  1 duplicate frame(s)!
  Pos: 159.7s   2400f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.015 [413:63]
  1 duplicate frame(s)!
  Pos: 159.8s   2401f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.017 [413:63]
  1 duplicate frame(s)!
  Pos: 159.9s   2402f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.023 [414:63]
  1 duplicate frame(s)!
  Pos: 159.9s   2403f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.019 [413:63]
  1 duplicate frame(s)!
  Pos: 160.0s   2404f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.019 [413:63]
  1 duplicate frame(s)!
  Pos: 160.1s   2405f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.026 [413:63]
  1 duplicate frame(s)!
  Pos: 160.1s   2406f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.019 [413:63]
  1 duplicate frame(s)!
  Pos: 160.2s   2407f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.017 [413:63]
  1 duplicate frame(s)!
  Pos: 160.3s   2408f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.024 [413:63]
  1 duplicate frame(s)!
  Pos: 160.3s   2409f (99%) 93.12fps Trem:   0min   9mb  A-V:-0.017 [413:63]
  1 duplicate frame(s)!
  Pos: 160.4s   2410f (99%) 93.11fps Trem:   0min   9mb  A-V:-0.019 [413:63]
  1 duplicate frame(s)!
  Pos: 160.5s   2411f (99%) 93.12fps Trem:   0min   9mb  A-V:-0.025 [413:63]
  1 duplicate frame(s)!
  Pos: 160.5s   2412f (99%) 93.12fps Trem:   0min   9mb  A-V:-0.031 [413:63]
  1 duplicate frame(s)!
  Pos: 160.6s   2413f (99%) 93.12fps Trem:   0min   9mb  A-V:-0.038 [413:63]
  1 duplicate frame(s)!
  Pos: 160.7s   2414f (99%) 93.13fps Trem:   0min   9mb  A-V:-0.045 [413:63]
  1 duplicate frame(s)!
  Pos: 160.7s   2415f (99%) 93.13fps Trem:   0min   9mb  A-V:-0.042 [413:63]
  1 duplicate frame(s)!
  Pos: 160.8s   2416f (99%) 93.14fps Trem:   0min   9mb  A-V:-0.044 [413:63]
  1 duplicate frame(s)!
  Pos: 160.9s   2417f (99%) 93.14fps Trem:   0min   9mb  A-V:-0.037 [413:63]
  1 duplicate frame(s)!
  Pos: 160.9s   2418f (99%) 93.14fps Trem:   0min   9mb  A-V:-0.033 [413:63]
  1 duplicate frame(s)!
  Pos: 161.0s   2419f (99%) 93.14fps Trem:   0min   9mb  A-V:-0.039 [413:63]
  1 duplicate frame(s)!
  Pos: 161.1s   2420f (99%) 93.14fps Trem:   0min   9mb  A-V:-0.033 [413:63]
  1 duplicate frame(s)!
  Pos: 161.1s   2421f (99%) 93.15fps Trem:   0min   9mb  A-V:-0.033 [413:63]
  1 duplicate frame(s)!
  Pos: 161.2s   2422f (99%) 93.15fps Trem:   0min   9mb  A-V:-0.039 [413:63]
  1 duplicate frame(s)!
  Pos: 161.3s   2423f (99%) 93.15fps Trem:   0min   9mb  A-V:-0.033 [413:63]
  1 duplicate frame(s)!
  Pos: 161.3s   2424f (99%) 93.15fps Trem:   0min   9mb  A-V:-0.035 [413:63]
  1 duplicate frame(s)!
  Pos: 161.4s   2425f (99%) 93.16fps Trem:   0min   9mb  A-V:-0.042 [413:63]
  1 duplicate frame(s)!
  Pos: 161.5s   2426f (100%) 93.17fps Trem:   0min   9mb  A-V:-0.048 [413:63]
  1 duplicate frame(s)!
  Pos: 161.5s   2427f (100%) 93.18fps Trem:   0min   9mb  A-V:-0.055 [413:63]
  1 duplicate frame(s)!
  Pos: 161.6s   2428f (100%) 93.20fps Trem:   0min   9mb  A-V:-0.062 [413:63]
  1 duplicate frame(s)!
  Pos: 161.7s   2429f (100%) 93.22fps Trem:   0min   9mb  A-V:-0.068 [413:63]
  Flushing video frames
  Writing index...
  SEEK 176
  SEEK 9642263
  SEEK 9642555
  SEEK 9642600
  SEEK 9642628
  SEEK 9642664
  SEEK 9642774
  SEEK 9642856
  SEEK 9642688
  SEEK 9642856
  SEEK 9642672
  SEEK 9642856
  SEEK 9642892
  SEEK 9642976
  SEEK 9642880
  SEEK 9642976
  SEEK 9642988
  SEEK 9643004
  SEEK 9642976
  SEEK 9643004
  SEEK 9643004
  SEEK 9662404
  SEEK 9662404
  SEEK 9681800
  SEEK 9642664
  SEEK 9681800
  SEEK 9642600
  SEEK 9681800
  SEEK 9642515
  SEEK 9681800
  SEEK 9642379
  SEEK 9681852
  SEEK 9682028
  SEEK 9682073
  SEEK 9682097
  SEEK 9682133
  SEEK 9682193
  SEEK 9682232
  SEEK 9682157
  SEEK 9682232
  SEEK 9682141
  SEEK 9682232
  SEEK 9682268
  SEEK 9682284
  SEEK 9682256
  SEEK 9682284
  SEEK 9682284
  SEEK 9697480
  SEEK 9697480
  SEEK 9712672
  SEEK 9682133
  SEEK 9712672
  SEEK 9682073
  SEEK 9712672
  SEEK 9681988
  SEEK 9712672
  SEEK 9681852
  SEEK 9712724
  SEEK 9642263
  SEEK 9712724

  Video stream:  413.233 kbit/s  (51654 B/s)  size: 8350481 bytes  161.661 secs  2429 frames

  Audio stream:   63.831 kbit/s  (7978 B/s)  size: 1291598 bytes  161.877 secs"
end