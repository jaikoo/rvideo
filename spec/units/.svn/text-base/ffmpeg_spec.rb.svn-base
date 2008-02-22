require File.dirname(__FILE__) + '/../spec_helper'

module RVideo
  module Tools
  
    describe Ffmpeg do
      before do
        setup_ffmpeg_spec
      end
      
      it "should initialize with valid arguments" do
        @ffmpeg.class.should == Ffmpeg
      end
      
      it "should have the correct tool_command" do
        @ffmpeg.tool_command.should == 'ffmpeg'
      end
      
      it "should call parse_result on execute, with a ffmpeg result string" do
        @ffmpeg.should_receive(:parse_result).once.with /\AFFmpeg version/
        @ffmpeg.execute
      end
      
      it "should mixin AbstractTool" do
        Ffmpeg.included_modules.include?(AbstractTool::InstanceMethods).should be_true
      end
      
      it "should set supported options successfully" do
        @ffmpeg.options[:resolution].should == @options[:resolution]
        @ffmpeg.options[:input_file].should == @options[:input_file]
        @ffmpeg.options[:output_file].should == @options[:output_file]
      end
      
    end
    
    describe Ffmpeg, " magic variables" do
      before do
        mock_inspector = mock("inspector")
        Inspector.stub!(:new).and_return(mock_inspector)
        mock_inspector.stub!(:fps).and_return 23.98
        mock_inspector.stub!(:width).and_return 1280
        mock_inspector.stub!(:height).and_return 720
      end
      
      it 'should access the original fps (ffmpeg)' do
        options = {:input_file => "foo", :output_file => "bar"}
        ffmpeg = Ffmpeg.new("ffmpeg -i $input_file$ -ar 44100 -ab 64 -vcodec xvid -acodec mp3 $original_fps$ -s 320x240 -y $output_file$", options)
        ffmpeg.command.should == "ffmpeg -i #{options[:input_file]} -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 23.98 -s 320x240 -y #{options[:output_file]}"
      end
      
      it 'should create width/height (ffmpeg)' do
        command = "ffmpeg -i $input_file$ -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s $resolution$ -aspect $aspect_ratio$ -y $output_file$"
        ffmpeg = Ffmpeg.new(command, {:input_file => "foo", :output_file => "bar", :width => "640", :height => "360"})
        ffmpeg.command.should == "ffmpeg -i foo -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s 640x360 -aspect 640:360 -y bar"
      end
      
      it 'should support calculated height' do
        command = "ffmpeg -i $input_file$ -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s $resolution$ -aspect $aspect_ratio$ -y $output_file$"
        ffmpeg = Ffmpeg.new(command, {:input_file => "foo", :output_file => "bar", :width => "640", :height => "x"})
        ffmpeg.command.should == "ffmpeg -i foo -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s 640x368 -aspect 640:368 -y bar"
      end
      
      it 'should support calculated width' do
        command = "ffmpeg -i $input_file$ -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s $resolution$ -aspect $aspect_ratio$ -y $output_file$"
        ffmpeg = Ffmpeg.new(command, {:input_file => "foo", :output_file => "bar", :width => "x", :height => "360"})
        ffmpeg.command.should == "ffmpeg -i foo -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s 640x360 -aspect 640:360 -y bar"
      end
      
      it 'should support passthrough height' do
        command = "ffmpeg -i $input_file$ -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s $resolution$ -aspect $aspect_ratio$ -y $output_file$"
        ffmpeg = Ffmpeg.new(command, {:input_file => "foo", :output_file => "bar", :width => "640", :height => "?"})
        ffmpeg.command.should == "ffmpeg -i foo -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s 640x720 -aspect 640:720 -y bar"        
      end
      
      it 'should support passthrough width' do
        command = "ffmpeg -i $input_file$ -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s $resolution$ -aspect $aspect_ratio$ -y $output_file$"
        ffmpeg = Ffmpeg.new(command, {:input_file => "foo", :output_file => "bar", :width => "?", :height => "360"})
        ffmpeg.command.should == "ffmpeg -i foo -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s 1280x360 -aspect 1280:360 -y bar"        
      end
      
    end
    
    describe Ffmpeg, " when parsing a result" do
      before do
        setup_ffmpeg_spec
        @result = "FFmpeg version CVS, Copyright (c) 2000-2004 Fabrice Bellard
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
        Press [q] to stop encoding
        frame= 4126 q=31.0 Lsize=    5917kB time=69.1 bitrate= 702.0kbits/s    
        video:2417kB audio:540kB global headers:0kB muxing overhead 100.140277%
        "
        
        @result2 = "FFmpeg version CVS, Copyright (c) 2000-2004 Fabrice Bellard
        Mac OSX universal build for ffmpegX
          configuration:  --enable-memalign-hack --enable-mp3lame --enable-gpl --disable-vhook --disable-ffplay --disable-ffserver --enable-a52 --enable-xvid --enable-faac --enable-faad --enable-amr_nb --enable-amr_wb --enable-pthreads --enable-x264 
          libavutil version: 49.0.0
          libavcodec version: 51.9.0
          libavformat version: 50.4.0
          built on Apr 15 2006 04:58:19, gcc: 4.0.1 (Apple Computer, Inc. build 5250)
        Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '/Users/jon/code/spinoza/rvideo/config/../spec/files/kites.mp4':
          Duration: 00:00:19.6, start: 0.000000, bitrate: 98 kb/s
          Stream #0.0(und), 10.00 fps(r): Video: mpeg4, yuv420p, 176x144
          Stream #0.1(und): Audio: amr_nb, 8000 Hz, mono
        Output #0, avi, to '/Users/jon/code/spinoza/rvideo/config/../tmp/kites-transcoded.avi':
          Stream #0.0, 29.97 fps(c): Video: xvid, yuv420p, 320x240, q=2-31, 200 kb/s
          Stream #0.1: Audio: mp3, 44100 Hz, mono, 64 kb/s
        Stream mapping:
          Stream #0.0 -> #0.0
          Stream #0.1 -> #0.1
        Press [q] to stop encoding
        frame=  584 q=6.0 Lsize=     708kB time=19.5 bitrate= 297.8kbits/s    
        video:49kB audio:153kB global headers:0kB muxing overhead 250.444444%
        "  
        
        @result3 = "FFmpeg version CVS, Copyright (c) 2000-2004 Fabrice Bellard
        Mac OSX universal build for ffmpegX
          configuration:  --enable-memalign-hack --enable-mp3lame --enable-gpl --disable-vhook --disable-ffplay --disable-ffserver --enable-a52 --enable-xvid --enable-faac --enable-faad --enable-amr_nb --enable-amr_wb --enable-pthreads --enable-x264 
          libavutil version: 49.0.0
          libavcodec version: 51.9.0
          libavformat version: 50.4.0
          built on Apr 15 2006 04:58:19, gcc: 4.0.1 (Apple Computer, Inc. build 5250)
        Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '/Users/jon/code/spinoza/rvideo/config/../spec/files/kites.mp4':
          Duration: 00:00:19.6, start: 0.000000, bitrate: 98 kb/s
          Stream #0.0(und), 10.00 fps(r): Video: mpeg4, yuv420p, 176x144
          Stream #0.1(und): Audio: amr_nb, 8000 Hz, mono
        Output #0, avi, to '/Users/jon/code/spinoza/rvideo/config/../tmp/kites-transcoded.avi':
          Stream #0.0, 29.97 fps(c): Video: xvid, yuv420p, 320x240, q=2-31, 200 kb/s
          Stream #0.1: Audio: mp3, 44100 Hz, mono, 64 kb/s
        Stream mapping:
          Stream #0.0 -> #0.0
          Stream #0.1 -> #0.1
        Press [q] to stop encoding
        frame=  273 fps= 31 q=10.0 Lsize=     398kB time=5.9 bitrate= 551.8kbits/s
        video:284kB audio:92kB global headers:0kB muxing overhead 5.723981%
        "
        
        @result4 = "FFmpeg version SVN-rUNKNOWN, Copyright (c) 2000-2007 Fabrice Bellard, et al.
          configuration: --prefix=/opt/local --prefix=/opt/local --disable-vhook --mandir=/opt/local/share/man --enable-shared --enable-pthreads --enable-libmp3lame --enable-gpl --enable-libfaac --enable-libfaad --enable-xvid --enable-x264 
          libavutil version: 49.4.0
          libavcodec version: 51.40.4
          libavformat version: 51.12.1
          built on Sep 19 2007 11:30:28, gcc: 4.0.1 (Apple Computer, Inc. build 5367)
        Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '/Users/Eric/Projects/rvidtest/rvideo/report/input_files/jobjob.mov': 
          Duration: 00:01:12.0, start: 0.000000, bitrate: 972 kb/s
          Stream #0.0(eng): Video: mpeg4, yuv420p, 512x384, 29.97 fps(r)
          Stream #0.1(eng): Audio: mp3, 48000 Hz, stereo
        Output #0, mp3, to '/Users/Eric/Projects/rvidtest/rvideo/report/generated_reports/62/output_files/jobjob_mov/private_mp3.mp3': 
          Stream #0.0: Audio: mp3, 48000 Hz, stereo, 0 kb/s
        Stream mapping:
          Stream #0.1 -> #0.0
        Press [q] to stop encoding
        mdb:94, lastbuf:0 skipping granule 0
        size=    1080kB time=69.1 bitrate= 128.0kbits /s    
        video:0kB audio:1080kB global headers:0kB muxing overhead 0.002893%
        "
      end
      
      it "should create correct result metadata" do
        @ffmpeg.send(:parse_result, @result).should be_true
        @ffmpeg.frame.should == '4126'
        @ffmpeg.output_fps.should be_nil
        @ffmpeg.q.should == '31.0'
        @ffmpeg.size.should == '5917kB'
        @ffmpeg.time.should == '69.1'
        @ffmpeg.output_bitrate.should == '702.0kbits/s'
        @ffmpeg.video_size.should == "2417kB"
        @ffmpeg.audio_size.should == "540kB"
        @ffmpeg.header_size.should == "0kB"
        @ffmpeg.overhead.should == "100.140277%"
        @ffmpeg.psnr.should be_nil
      end
      
      it "should create correct result metadata (2)" do
        @ffmpeg.send(:parse_result, @result2).should be_true
        @ffmpeg.frame.should == '584'
        @ffmpeg.output_fps.should be_nil
        @ffmpeg.q.should == '6.0'
        @ffmpeg.size.should == '708kB'
        @ffmpeg.time.should == '19.5'
        @ffmpeg.output_bitrate.should == '297.8kbits/s'
        @ffmpeg.video_size.should == "49kB"
        @ffmpeg.audio_size.should == "153kB"
        @ffmpeg.header_size.should == "0kB"
        @ffmpeg.overhead.should == "250.444444%"
        @ffmpeg.psnr.should be_nil
      end
      
      it "should create correct result metadata (3)" do
        @ffmpeg.send(:parse_result, @result3).should be_true
        @ffmpeg.frame.should == '273'
        @ffmpeg.output_fps.should == "31"
        @ffmpeg.q.should == '10.0'
        @ffmpeg.size.should == '398kB'
        @ffmpeg.time.should == '5.9'
        @ffmpeg.output_bitrate.should == '551.8kbits/s'
        @ffmpeg.video_size.should == "284kB"
        @ffmpeg.audio_size.should == "92kB"
        @ffmpeg.header_size.should == "0kB"
        @ffmpeg.overhead.should == "5.723981%"
        @ffmpeg.psnr.should be_nil
      end
      
      it "should create correct result metadata (4)" do
        @ffmpeg.send(:parse_result, @result4).should be_true
        @ffmpeg.frame.should be_nil
        @ffmpeg.output_fps.should be_nil
        @ffmpeg.q.should be_nil
        @ffmpeg.size.should == '1080kB'
        @ffmpeg.time.should == '69.1'
        @ffmpeg.output_bitrate.should == '128.0kbits'
        @ffmpeg.video_size.should == "0kB"
        @ffmpeg.audio_size.should == "1080kB"
        @ffmpeg.header_size.should == "0kB"
        @ffmpeg.overhead.should == "0.002893%"
        @ffmpeg.psnr.should be_nil
      end
      
      it "ffmpeg should calculate PSNR if it is turned on" do
        @ffmpeg.send(:parse_result, @result.gsub("Lsize=","LPSNR=Y:33.85 U:37.61 V:37.46 *:34.77 size=")).should be_true
        @ffmpeg.psnr.should == "Y:33.85 U:37.61 V:37.46 *:34.77"
      end
    end
    
    context Ffmpeg, " result parsing should raise an exception" do
      
      setup do
        setup_ffmpeg_spec
      end
      
      specify "when codec not supported" do
        result = "Unexpected result details (FFmpeg version SVN-r9102, Copyright (c) 2000-2007 Fabrice Bellard, et al. configuration: --prefix=/opt/local --prefix=/opt/local --disable-vhook --mandir=/opt/local/share/man --enable-shared --enable-pthreads --disable-mmx --enable-gpl --enable-libmp3lame --enable-libogg --enable-libvorbis --enable-libtheora --enable-libfaac --enable-libfaad --enable-xvid --enable-x264 --enable-liba52 libavutil version: 49.4.0 libavcodec version: 51.40.4 libavformat version: 51.12.1 built on Dec 20 2007 13:49:31, gcc: 4.0.1 (Apple Inc. build 5465) Seems stream 0 codec frame rate differs from container frame rate: 30000.00 (30000/1) -> 29.97 (30000/1001) Input #0, avi, from '/Users/swd/Sites/worker/tmp/22/1989-Onboard-Hungaroring-Piquet.avi': Duration: 00:01:37.3, start: 0.000000, bitrate: 1393 kb/s Stream #0.0: Video: mpeg4, yuv420p, 512x384, 29.97 fps(r) Stream #0.1: Audio: mp3, 24000 Hz, stereo, 40 kb/s Unknown codec 'amr_nb' )"
        lambda {
          @ffmpeg.send(:parse_result, result)
        }.should raise_error(TranscoderError::InvalidFile, "Codec amr_nb not supported by this build of ffmpeg")
      end
      
      specify "when not passed a command" do
        result = "FFmpeg version CVS, Copyright (c) 2000-2004 Fabrice Bellard
        Mac OSX universal build for ffmpegX
          configuration:  --enable-memalign-hack --enable-mp3lame --enable-gpl --disable-vhook --disable-ffplay --disable-ffserver --enable-a52 --enable-xvid --enable-faac --enable-faad --enable-amr_nb --enable-amr_wb --enable-pthreads --enable-x264 
          libavutil version: 49.0.0
          libavcodec version: 51.9.0
          libavformat version: 50.4.0
          built on Apr 15 2006 04:58:19, gcc: 4.0.1 (Apple Computer, Inc. build 5250)
        usage: ffmpeg [[infile options] -i infile]... {[outfile options] outfile}...
        Hyper fast Audio and Video encoder

        Main options:
        -L                  show license
        -h                  show help
        -version            show version
        -formats            show available formats, codecs, protocols, ...
        -f fmt              force format
        -img img_fmt        force image format
        -i filename         input file name
        -y                  overwrite output files
        -t duration         set the recording time
        -fs limit_size      set the limit file size
        -ss time_off        set the start time offset
        -itsoffset time_off  set the input ts offset
        -title string       set the title
        -timestamp time     set the timestamp
        -author string      set the author
        -copyright string   set the copyright
        -comment string     set the comment
        -v verbose          control amount of logging
        -target type        specify target file type (\"vcd\", \"svcd\", \"dvd\", \"dv\", \"dv50\", \pal-vcd\", \"ntsc-svcd\", ...)
        -dframes number     set the number of data frames to record
        -scodec codec       force subtitle codec ('copy' to copy stream)
        -newsubtitle        add a new subtitle stream to the current output stream
        -slang code         set the ISO 639 language code (3 letters) of the current subtitle stream

        Video options:
        -b bitrate          set video bitrate (in kbit/s)
        -vframes number     set the number of video frames to record
        -r rate             set frame rate (Hz value, fraction or abbreviation)
        -s size             set frame size (WxH or abbreviation)
        -aspect aspect      set aspect ratio (4:3, 16:9 or 1.3333, 1.7777)
        -croptop size       set top crop band size (in pixels)
        -cropbottom size    set bottom crop band size (in pixels)
        -cropleft size      set left crop band size (in pixels)
        -cropright size     set right crop band size (in pixels)
        -padtop size        set top pad band size (in pixels)
        -padbottom size     set bottom pad band size (in pixels)
        -padleft size       set left pad band size (in pixels)
        -padright size      set right pad band size (in pixels)
        -padcolor color     set color of pad bands (Hex 000000 thru FFFFFF)
        -vn                 disable video
        -bt tolerance       set video bitrate tolerance (in kbit/s)
        -maxrate bitrate    set max video bitrate tolerance (in kbit/s)
        -minrate bitrate    set min video bitrate tolerance (in kbit/s)
        -bufsize size       set ratecontrol buffer size (in kByte)
        -vcodec codec       force video codec ('copy' to copy stream)
        -sameq              use same video quality as source (implies VBR)
        -pass n             select the pass number (1 or 2)
        -passlogfile file   select two pass log file name
        -newvideo           add a new video stream to the current output stream

        Advanced Video options:
        -pix_fmt format     set pixel format
        -g gop_size         set the group of picture size
        -intra              use only intra frames
        -vdt n              discard threshold
        -qscale q           use fixed video quantiser scale (VBR)
        -qmin q             min video quantiser scale (VBR)
        -qmax q             max video quantiser scale (VBR)
        -lmin lambda        min video lagrange factor (VBR)
        -lmax lambda        max video lagrange factor (VBR)
        -mblmin q           min macroblock quantiser scale (VBR)
        -mblmax q           max macroblock quantiser scale (VBR)
        -qdiff q            max difference between the quantiser scale (VBR)
        -qblur blur         video quantiser scale blur (VBR)
        -qsquish squish     how to keep quantiser between qmin and qmax (0 = clip, 1 = use differentiable function)
        -qcomp compression  video quantiser scale compression (VBR)
        -rc_init_cplx complexity  initial complexity for 1-pass encoding
        -b_qfactor factor   qp factor between p and b frames
        -i_qfactor factor   qp factor between p and i frames
        -b_qoffset offset   qp offset between p and b frames
        -i_qoffset offset   qp offset between p and i frames
        -ibias bias         intra quant bias
        -pbias bias         inter quant bias
        -rc_eq equation     set rate control equation
        -rc_override override  rate control override for specific intervals
        -me method          set motion estimation method
        -me_threshold       motion estimaton threshold
        -mb_threshold       macroblock threshold
        -bf frames          use 'frames' B frames
        -preme              pre motion estimation
        -bug param          workaround not auto detected encoder bugs
        -strict strictness  how strictly to follow the standards
        -deinterlace        deinterlace pictures
        -psnr               calculate PSNR of compressed frames
        -vstats             dump video coding statistics to file
        -vhook module       insert video processing module
        -intra_matrix matrix  specify intra matrix coeffs
        -inter_matrix matrix  specify inter matrix coeffs
        -top                top=1/bottom=0/auto=-1 field first
        -sc_threshold threshold  scene change threshold
        -me_range range     limit motion vectors range (1023 for DivX player)
        -dc precision       intra_dc_precision
        -mepc factor (1.0 = 256)  motion estimation bitrate penalty compensation
        -vtag fourcc/tag    force video tag/fourcc
        -skip_threshold threshold  frame skip threshold
        -skip_factor factor  frame skip factor
        -skip_exp exponent  frame skip exponent
        -genpts             generate pts
        -qphist             show QP histogram

        Audio options:
        -aframes number     set the number of audio frames to record
        -ab bitrate         set audio bitrate (in kbit/s)
        -aq quality         set audio quality (codec-specific)
        -ar rate            set audio sampling rate (in Hz)
        -ac channels        set number of audio channels
        -an                 disable audio
        -acodec codec       force audio codec ('copy' to copy stream)
        -vol volume         change audio volume (256=normal)
        -newaudio           add a new audio stream to the current output stream
        -alang code         set the ISO 639 language code (3 letters) of the current audio stream

        Advanced Audio options:
        -atag fourcc/tag    force audio tag/fourcc

        Subtitle options:
        -scodec codec       force subtitle codec ('copy' to copy stream)
        -newsubtitle        add a new subtitle stream to the current output stream
        -slang code         set the ISO 639 language code (3 letters) of the current subtitle stream

        Audio/Video grab options:
        -vd device          set video grab device
        -vc channel         set video grab channel (DV1394 only)
        -tvstd standard     set television standard (NTSC, PAL (SECAM))
        -ad device          set audio device
        -grab format        request grabbing using
        -gd device          set grab device

        Advanced options:
        -map file:stream[:syncfile:syncstream]  set input stream mapping
        -map_meta_data outfile:infile  set meta data information of outfile from infile
        -benchmark          add timings for benchmarking
        -dump               dump each input packet
        -hex                when dumping packets, also dump the payload
        -re                 read input at native frame rate
        -loop_input         loop (current only works with images)
        -loop_output        number of times to loop output in formats that support looping (0 loops forever)
        -threads count      thread count
        -vsync              video sync method
        -async              audio sync method
        -vglobal            video global header storage type
        -copyts             copy timestamps
        -shortest           finish encoding within shortest input
        -dts_delta_threshold   timestamp discontinuity delta threshold
        -ps size            set packet size in bits
        -error rate         error rate
        -muxrate rate       set mux rate
        -packetsize size    set packet size
        -muxdelay seconds   set the maximum demux-decode delay
        -muxpreload seconds  set the initial demux-decode delay
        AVCodecContext AVOptions:
        -bit_rate          <int>   E.VA.
        -bit_rate_tolerance <int>   E.V..
        -flags             <flags> EDVA.
        -mv4                       E.V.. use four motion vector by macroblock (mpeg4)
        -obmc                      E.V.. use overlapped block motion compensation (h263+)
        -qpel                      E.V.. use 1/4 pel motion compensation
        -loop                      E.V.. use loop filter
        -gmc                       E.V.. use gmc
        -mv0                       E.V.. always try a mb with mv=<0,0>
        -part                      E.V.. use data partitioning
        -gray                      EDV.. only decode/encode grayscale
        -psnr                      E.V.. error[?] variables will be set during encoding
        -naq                       E.V.. normalize adaptive quantization
        -ildct                     E.V.. use interlaced dct
        -low_delay                 .DV.. force low delay
        -alt                       E.V.. enable alternate scantable (mpeg2/mpeg4)
        -trell                     E.V.. use trellis quantization
        -bitexact                  EDVAS use only bitexact stuff (except (i)dct)
        -aic                       E.V.. h263 advanced intra coding / mpeg4 ac prediction
        -umv                       E.V.. use unlimited motion vectors
        -cbp                       E.V.. use rate distortion optimization for cbp
        -qprd                      E.V.. use rate distortion optimization for qp selection
        -aiv                       E.V.. h263 alternative inter vlc
        -slice                     E.V..
        -ilme                      E.V.. interlaced motion estimation
        -scan_offset               E.V.. will reserve space for svcd scan offset user data
        -cgop                      E.V.. closed gop
        -fast                      E.V.. allow non spec compliant speedup tricks
        -sgop                      E.V.. strictly enforce gop size
        -noout                     E.V.. skip bitstream encoding
        -local_header              E.V.. place global headers at every keyframe instead of in extradata
        -me_method         <int>   E.V..
        -gop_size          <int>   E.V..
        -cutoff            <int>   E..A. set cutoff bandwidth
        -qcompress         <float> E.V..
        -qblur             <float> E.V..
        -qmin              <int>   E.V..
        -qmax              <int>   E.V..
        -max_qdiff         <int>   E.V..
        -max_b_frames      <int>   E.V..
        -b_quant_factor    <float> E.V..
        -rc_strategy       <int>   E.V..
        -b_strategy        <int>   E.V..
        -hurry_up          <int>   .DV..
        -bugs              <int>   .DV..
        -autodetect                .DV..
        -old_msmpeg4               .DV..
        -xvid_ilace                .DV..
        -ump4                      .DV..
        -no_padding                .DV..
        -amv                       .DV..
        -ac_vlc                    .DV..
        -qpel_chroma               .DV..
        -std_qpel                  .DV..
        -qpel_chroma2              .DV..
        -direct_blocksize          .DV..
        -edge                      .DV..
        -hpel_chroma               .DV..
        -dc_clip                   .DV..
        -ms                        .DV..
        -lelim             <int>   E.V.. single coefficient elimination threshold for luminance (negative values also consider dc coefficient)
        -celim             <int>   E.V.. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient)
        -strict            <int>   E.V..
        -very                      E.V..
        -strict                    E.V..
        -normal                    E.V..
        -inofficial                E.V..
        -experimental              E.V..
        -b_quant_offset    <float> E.V..
        -er                <int>   .DV..
        -careful                   .DV..
        -compliant                 .DV..
        -aggressive                .DV..
        -very_aggressive           .DV..
        -mpeg_quant        <int>   E.V..
        -rc_qsquish        <float> E.V..
        -rc_qmod_amp       <float> E.V..
        -rc_qmod_freq      <int>   E.V..
        -rc_eq             <string> E.V..
        -rc_max_rate       <int>   E.V..
        -rc_min_rate       <int>   E.V..
        -rc_buffer_size    <int>   E.V..
        -rc_buf_aggressivity <float> E.V..
        -i_quant_factor    <float> E.V..
        -i_quant_offset    <float> E.V..
        -rc_initial_cplx   <float> E.V..
        -dct               <int>   E.V..
        -auto                      E.V..
        -fastint                   E.V..
        -int                       E.V..
        -mmx                       E.V..
        -mlib                      E.V..
        -altivec                   E.V..
        -faan                      E.V..
        -lumi_mask         <float> E.V.. lumimasking
        -tcplx_mask        <float> E.V.. temporal complexity masking
        -scplx_mask        <float> E.V.. spatial complexity masking
        -p_mask            <float> E.V.. inter masking
        -dark_mask         <float> E.V.. darkness masking
        -idct              <int>   EDV..
        -auto                      EDV..
        -int                       EDV..
        -simple                    EDV..
        -simplemmx                 EDV..
        -libmpeg2mmx               EDV..
        -ps2                       EDV..
        -mlib                      EDV..
        -arm                       EDV..
        -altivec                   EDV..
        -sh4                       EDV..
        -simplearm                 EDV..
        -h264                      EDV..
        -vp3                       EDV..
        -ipp                       EDV..
        -xvidmmx                   EDV..
        -ec                <flags> .DV..
        -guess_mvs                 .DV..
        -deblock                   .DV..
        -pred              <int>   E.V.. prediction method
        -left                      E.V..
        -plane                     E.V..
        -median                    E.V..
        -aspect            <rational> E.V..
        -debug             <flags> EDVAS print specific debug info
        -pict                      .DV..
        -rc                        E.V..
        -bitstream                 .DV..
        -mb_type                   .DV..
        -qp                        .DV..
        -mv                        .DV..
        -dct_coeff                 .DV..
        -skip                      .DV..
        -startcode                 .DV..
        -pts                       .DV..
        -er                        .DV..
        -mmco                      .DV..
        -bugs                      .DV..
        -vis_qp                    .DV..
        -vis_mb_type               .DV..
        -vismv             <int>   .DV.. visualize motion vectors
        -pf                        .DV..
        -bf                        .DV..
        -bb                        .DV..
        -mb_qmin           <int>   E.V..
        -mb_qmax           <int>   E.V..
        -cmp               <int>   E.V.. full pel me compare function
        -subcmp            <int>   E.V.. sub pel me compare function
        -mbcmp             <int>   E.V.. macroblock compare function
        -ildctcmp          <int>   E.V.. interlaced dct compare function
        -dia_size          <int>   E.V..
        -last_pred         <int>   E.V..
        -preme             <int>   E.V..
        -precmp            <int>   E.V.. pre motion estimation compare function
        -sad                       E.V..
        -sse                       E.V..
        -satd                      E.V..
        -dct                       E.V..
        -psnr                      E.V..
        -bit                       E.V..
        -rd                        E.V..
        -zero                      E.V..
        -vsad                      E.V..
        -vsse                      E.V..
        -nsse                      E.V..
        -w53                       E.V..
        -w97                       E.V..
        -dctmax                    E.V..
        -chroma                    E.V..
        -pre_dia_size      <int>   E.V..
        -subq              <int>   E.V.. sub pel motion estimation quality
        -me_range          <int>   E.V..
        -ibias             <int>   E.V..
        -pbias             <int>   E.V..
        -coder             <int>   E.V..
        -vlc                       E.V.. variable length coder / huffman coder
        -ac                        E.V.. arithmetic coder
        -context           <int>   E.V.. context model
        -mbd               <int>   E.V..
        -simple                    E.V..
        -bits                      E.V..
        -rd                        E.V..
        -sc_threshold      <int>   E.V..
        -lmin              <int>   E.V.. min lagrange factor
        -lmax              <int>   E.V.. max lagrange factor
        -nr                <int>   E.V.. noise reduction
        -rc_init_occupancy <int>   E.V..
        -inter_threshold   <int>   E.V..
        -flags2            <flags> EDVA.
        -antialias         <int>   .DV..
        -auto                      .DV..
        -fastint                   .DV..
        -int                       .DV..
        -float                     .DV..
        -qns               <int>   E.V.. quantizer noise shaping
        -thread_count      <int>   EDV..
        -dc                <int>   E.V..
        -nssew             <int>   E.V.. nsse weight
        -skip_top          <int>   .DV..
        -skip_bottom       <int>   .DV..
        -profile           <int>   E.VA.
        -unknown                   E.VA.
        -level             <int>   E.VA.
        -unknown                   E.VA.
        -lowres            <int>   .DV..
        -frame_skip_threshold <int>   E.V..
        -frame_skip_factor <int>   E.V..
        -frame_skip_exp    <int>   E.V..
        -skipcmp           <int>   E.V.. frame skip compare function
        -border_mask       <float> E.V..
        -mb_lmin           <int>   E.V..
        -mb_lmax           <int>   E.V..
        -me_penalty_compensation <int>   E.V..
        -bidir_refine      <int>   E.V..
        -brd_scale         <int>   E.V..
        -crf               <int>   E.V..
        -cqp               <int>   E.V..
        -keyint_min        <int>   E.V..
        -refs              <int>   E.V..
        -chromaoffset      <int>   E.V..
        -bframebias        <int>   E.V..
        -trellis           <int>   E.V..
        -directpred        <int>   E.V..
        -bpyramid                  E.V..
        -wpred                     E.V..
        -mixed_refs                E.V..
        -8x8dct                    E.V..
        -fastpskip                 E.V..
        -aud                       E.V..
        -brdo                      E.V..
        -complexityblur    <float> E.V..
        -deblockalpha      <int>   E.V..
        -deblockbeta       <int>   E.V..
        -partitions        <flags> E.V..
        -parti4x4                  E.V..
        -parti8x8                  E.V..
        -partp4x4                  E.V..
        -partp8x8                  E.V..
        -partb8x8                  E.V..
        -sc_factor         <int>   E.V.."
        lambda {
          @ffmpeg.send(:parse_result, result)
        }.should raise_error(TranscoderError::InvalidCommand, "must pass a command to ffmpeg")
      end
      
      specify "when given a broken command" do
        result = "FFmpeg version CVS, Copyright (c) 2000-2004 Fabrice Bellard
        Mac OSX universal build for ffmpegX
          configuration:  --enable-memalign-hack --enable-mp3lame --enable-gpl --disable-vhook --disable-ffplay --disable-ffserver --enable-a52 --enable-xvid --enable-faac --enable-faad --enable-amr_nb --enable-amr_wb --enable-pthreads --enable-x264 
          libavutil version: 49.0.0
          libavcodec version: 51.9.0
          libavformat version: 50.4.0
          built on Apr 15 2006 04:58:19, gcc: 4.0.1 (Apple Computer, Inc. build 5250)
        Unable for find a suitable output format for 'foo'
        "
        lambda { 
          @ffmpeg.send(:parse_result, result) 
        }.should raise_error(TranscoderError::InvalidCommand, "Unable for find a suitable output format for 'foo'")
      end
      
      specify "when the output file has no streams" do
        result = "Unexpected result details (FFmpeg version SVN-r10656, Copyright (c) 2000-2007 Fabrice Bellard, et al.
          configuration: --enable-libmp3lame --enable-libogg --enable-libvorbis --enable-liba52 --enable-libxvid --enable-libfaac --enable-libfaad --enable-libx264 --enable-libxvid --enable-pp --enable-shared --enable-gpl --enable-libtheora --enable-libfaadbin --enable-liba52bin --enable-libamr_nb --enable-libamr_wb --extra-ldflags=-L/usr/local/ffmpeg-src/ffmpeg/libavcodec/acfr16/ --extra-libs=-lacfr --enable-libacfr16
          libavutil version: 49.5.0
          libavcodec version: 51.44.0
          libavformat version: 51.14.0
          built on Oct 31 2007 00:58:48, gcc: 4.1.2 (Ubuntu 4.1.2-0ubuntu4)

        Seems stream 0 codec frame rate differs from container frame rate: 1000.00 (1000/1) -> 30.00 (30/1)
        Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '/mnt/app/current/tmp/114/FlyIn1Comp.mov':
          Duration: 00:00:08.3, start: 0.000000, bitrate: 2253 kb/s
          Stream #0.0(eng): Video: mpeg4, yuv420p, 320x240, 30.00 fps(r)
        Output file does not contain any stream
        )"
        lambda {
          @ffmpeg.send(:parse_result, result)
        }.should raise_error(TranscoderError, /Output file does not contain.*stream/)
        
      end
      
      specify "when given a missing input file" do
        result = "FFmpeg version CVS, Copyright (c) 2000-2004 Fabrice Bellard
        Mac OSX universal build for ffmpegX
          configuration:  --enable-memalign-hack --enable-mp3lame --enable-gpl --disable-vhook --disable-ffplay --disable-ffserver --enable-a52 --enable-xvid --enable-faac --enable-faad --enable-amr_nb --enable-amr_wb --enable-pthreads --enable-x264 
          libavutil version: 49.0.0
          libavcodec version: 51.9.0
          libavformat version: 50.4.0
          built on Apr 15 2006 04:58:19, gcc: 4.0.1 (Apple Computer, Inc. build 5250)
        asdf: I/O error occured
        Usually that means that input file is truncated and/or corrupted.
        "
        lambda {
          @ffmpeg.send(:parse_result, result)
        }.should raise_error(TranscoderError::InvalidFile, /I\/O error: .+/)
      end
      
      specify "when given a file it can't handle"
      
      specify "when cancelled halfway through"
    
      specify "when receiving unexpected results" do
        result = "FFmpeg version CVS, Copyright (c) 2000-2004 Fabrice Bellard
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
        Press [q] to stop encoding
        foo
        bar
        "
        lambda {
          @ffmpeg.send(:parse_result, result)
        }.should raise_error(TranscoderError::UnexpectedResult, 'foo - bar')
      end
      
      specify "with an unsupported codec" do
        result = "FFmpeg version SVN-r9102, Copyright (c) 2000-2007 Fabrice Bellard, et al. configuration: --prefix=/opt/local --prefix=/opt/local --disable-vhook --mandir=/opt/local/share/man --enable-shared --enable-pthreads --disable-mmx --enable-gpl --enable-libmp3lame --enable-libogg --enable-libvorbis --enable-libtheora --enable-libfaac --enable-xvid --enable-x264 --enable-liba52 libavutil version: 49.4.0 libavcodec version: 51.40.4 libavformat version: 51.12.1 built on Dec 11 2007 12:00:30, gcc: 4.0.1 (Apple Inc. build 5465) Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '/Users/jon/projects/rvideo/spec/files/kites.mp4': Duration: 00:00:19.6, start: 0.000000, bitrate: 98 kb/s Stream #0.0(und): Video: mpeg4, yuv420p, 176x144, 10.00 fps(r) Stream #0.1(und): Audio: samr / 0x726D6173, 8000 Hz, mono Output #0, flv, to '/Users/jon/projects/rvideo/tmp/kites.flv': Stream #0.0: Video: flv, yuv420p, 320x240, q=2-31, pass 1, 300 kb/s, 15.00 fps(c) Stream #0.1: Audio: mp3, 22050 Hz, stereo, 64 kb/s Stream mapping: Stream #0.0 -> #0.0 Stream #0.1 -> #0.1 Unsupported codec (id=73728) for input stream #0.1"
        @ffmpeg.original = Inspector.new(:raw_response => files('kites2'))
        lambda {
          @ffmpeg.send(:parse_result, result)
        }.should raise_error(TranscoderError::InvalidFile, /samr/)
      end
      
      specify "when a stream cannot be written" do
        result = "FFmpeg version CVS, Copyright (c) 2000-2004 Fabrice Bellard
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
        Press [q] to stop encoding
        [mp3 @ 0x54340c]flv doesnt support that sample rate, choose from (44100, 22050, 11025)
        Could not write header for output file #0 (incorrect codec parameters ?)
        "
        lambda {
          @ffmpeg.send(:parse_result, result)
        }.should raise_error(TranscoderError, /flv doesnt support.*incorrect codec/)
      end
      
    end
  end
end

def setup_ffmpeg_spec
  @options = {:input_file => "foo", :output_file => "bar", :width => "320", :height => "240"}
  @simple_avi = "ffmpeg -i $input_file$ -ar 44100 -ab 64 -vcodec xvid -acodec mp3 -r 29.97 -s $resolution$ -y $output_file$"  
  @ffmpeg = RVideo::Tools::Ffmpeg.new(@simple_avi, @options)
end