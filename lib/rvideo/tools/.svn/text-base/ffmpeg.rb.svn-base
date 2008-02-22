module RVideo
  module Tools
    class Ffmpeg
      include AbstractTool::InstanceMethods
      
      attr_reader :frame, :q, :size, :time, :output_bitrate, :video_size, :audio_size, :header_size, :overhead, :psnr, :output_fps
      
      # Not sure if this is needed anymore...
      def tool_command
        'ffmpeg'
      end
      
      #
      # Return -r and the frame rate of the original file. E.g.:
      #
      #   -r 29.97
      #
      # If the original frame rate can't be determined, return an empty 
      # string.
      def original_fps
        inspect_original if @original.nil?
        if @original.fps
          "-r #{@original.fps}" 
        else
          ""
        end
      end
      
      private
      
      def parse_result(result)
        
        if m = /Unable for find a suitable output format for.*$/.match(result)
          raise TranscoderError::InvalidCommand, m[0]
        end
        
        if m = /Unknown codec \'(.*)\'/.match(result)
          raise TranscoderError::InvalidFile, "Codec #{m[1]} not supported by this build of ffmpeg"
       end
        
        if m = /could not find codec parameters/.match(result)
          raise TranscoderError::InvalidFile, "Codec not supported by this build of ffmpeg"
        end
        
        if m = /I\/O error occured\n(.*)$/.match(result)
          raise TranscoderError::InvalidFile, "I/O error: #{m[1].strip}"
        end
          
        if m = /\n(.*)Unknown Format$/.match(result)
          raise TranscoderError::InvalidFile, "unknown format (#{m[1]})"
        end
        
        if m = /\nERROR.*/m.match(result)
          raise TranscoderError::InvalidFile, m[0]
        end
        
        if result =~ /usage: ffmpeg/
          raise TranscoderError::InvalidCommand, "must pass a command to ffmpeg"
        end
        
        if result =~ /Output file does not contain.*stream/
          raise TranscoderError, "Output file does not contain any video or audio streams."
        end
        
        if m = /Unsupported codec.*id=(.*)\).*for input stream\s*(.*)\s*/.match(result) 
          inspect_original if @original.nil?
          case m[2]
          when @original.audio_stream_id
            codec_type = "audio"
            codec = @original.audio_codec
          when @original.video_stream_id
            codec_type = "video"
            codec = @original.video_codec
          else
            codec_type = "video or audio"
            codec = "unknown"
          end
          
          raise TranscoderError::InvalidFile, "Unsupported #{codec_type} codec: #{codec} (id=#{m[1]}, stream=#{m[2]})"
          #raise TranscoderError, "Codec #{m[1]} not supported (in stream #{m[2]})"
        end
        
        # Could not open './spec/../config/../tmp/processed/1/kites-1.avi'
        if result =~ /Could not open .#{@output_file}.\Z/
          raise TranscoderError, "Could not write output file to #{@output_file}"
        end
          
        full_details = /Press .* to stop encoding\n(.*)/m.match(result)
        raise TranscoderError, "Unexpected result details (#{result})" if full_details.nil?
        details = full_details[1].strip.gsub(/\s*\n\s*/," - ")
        
        if details =~ /Could not write header/
          raise TranscoderError, details
        end
        
        #frame=  584 q=6.0 Lsize=     708kB time=19.5 bitrate= 297.8kbits/s    
        #video:49kB audio:153kB global headers:0kB muxing overhead 250.444444%
        
        #frame= 4126 q=31.0 Lsize=    5917kB time=69.1 bitrate= 702.0kbits/s    
        #video:2417kB audio:540kB global headers:0kB muxing overhead 100.140277%
        
        #frame=  273 fps= 31 q=10.0 Lsize=     398kB time=5.9 bitrate= 551.8kbits/s
        #video:284kB audio:92kB global headers:0kB muxing overhead 5.723981%
        
        #mdb:94, lastbuf:0 skipping granule 0
        #size=    1080kB time=69.1 bitrate= 128.0kbits /s    
        #video:0kB audio:1080kB global headers:0kB muxing overhead 0.002893%
        
        #size=      80kB time=5.1 bitrate= 128.0kbits/s    ^Msize=     162kB time=10.3 bitrate= 128.0kbits/s    ^Msize=     241kB time=15.4 bitrate= 128.0kbits/s    ^Msize=     329kB time=21.1 bitrate= 128.0kbits/s    ^Msize=     413kB time=26.4 bitrate= 128.0kbits/s    ^Msize=     506kB time=32.4 bitrate= 128.0kbits/s    ^Msize=     591kB time=37.8 bitrate= 128.0kbits/s    ^Msize=     674kB time=43.2 bitrate= 128.0kbits/s    ^Msize=     771kB time=49.4 bitrate= 128.0kbits/s    ^Msize=     851kB time=54.5 bitrate= 128.0kbits/s    ^Msize=     932kB time=59.6 bitrate= 128.0kbits/s    ^Msize=    1015kB time=64.9 bitrate= 128.0kbits/s    ^Msize=    1094kB time=70.0 bitrate= 128.0kbits/s    ^Msize=    1175kB time=75.2 bitrate= 128.0kbits/s    ^Msize=    1244kB time=79.6 bitrate= 128.0kbits/s    ^Msize=    1335kB time=85.4 bitrate= 128.0kbits/s    ^Msize=    1417kB time=90.7 bitrate= 128.0kbits/s    ^Msize=    1508kB time=96.5 bitrate= 128.0kbits/s    ^Msize=    1589kB time=101.7 bitrate= 128.0kbits/s    ^Msize=    1671kB time=106.9 bitrate= 128.0kbits/s    ^Msize=    1711kB time=109.5 bitrate= 128.0kbits/s - video:0kB audio:1711kB global headers:0kB muxing overhead 0.001826%
        
        #mdb:14, lastbuf:0 skipping granule 0 - overread, skip -5 enddists: -2 -2 - overread, skip -5 enddists: -2 -2 - size=      90kB time=5.7 bitrate= 128.0kbits/s    \nsize=     189kB time=12.1 bitrate= 128.0kbits/s
        
        #size=      59kB time=20.2 bitrate=  24.0kbits/s    \nsize=     139kB time=47.4 bitrate=  24.0kbits/s    \nsize=     224kB time=76.5 bitrate=  24.0kbits/s    \nsize=     304kB time=103.7 bitrate=  24.0kbits/s    \nsi
        
        #mdb:14, lastbuf:0 skipping granule 0 - overread, skip -5 enddists: -2 -2 - overread, skip -5 enddists: -2 -2 - size=      81kB time=10.3 bitrate=  64.0kbits/s    \nsize=     153kB time=19.6 bitrate=  64.0kbits/s 
        
        #size=      65kB time=4.1 bitrate= 128.1kbits/s    \nsize=     119kB time=7.6 bitrate= 128.0kbits/s    \nsize=     188kB time=12.0 bitrate= 128.0kbits/s    \nsize=     268kB time=17.1 bitrate= 128.0kbits/s    \nsize=
        
        #Error while decoding stream #0.1     [mpeg4aac @ 0xb7d089f0]faac: frame decoding failed: Gain control not yet implementedError while decoding stream #0.1frame= 2143 fps= 83 q=4.0 size=    4476kB time=71.3 bitrate= 514.5kbits/s    ^M[mpeg4aac @ 0xb7d089f0]faac: frame decoding failed: Gain control not yet implementedError while decoding stream #0.1
        
        # NOTE: had to remove "\s" from "\s.*L.*size=" from this regexp below.
        # Not sure why. Unit tests were succeeding, but hand tests weren't.
        if details =~ /video:/ 
          #success = /^frame=\s*(\S*)\s*q=(\S*).*L.*size=\s*(\S*)\s*time=\s*(\S*)\s*bitrate=\s*(\S*)\s*/m.match(details)
          @frame = sanitary_match(/frame=\s*(\S*)/, details)
          @output_fps = sanitary_match(/fps=\s*(\S*)/, details)
          @q = sanitary_match(/\s+q=\s*(\S*)/, details)
          @size = sanitary_match(/size=\s*(\S*)/, details)
          @time = sanitary_match(/time=\s*(\S*)/, details)
          @output_bitrate = sanitary_match(/bitrate=\s*(\S*)/, details)
          
          @video_size = /video:\s*(\S*)/.match(details)[1]
          @audio_size = /audio:\s*(\S*)/.match(details)[1]
          @header_size = /headers:\s*(\S*)/.match(details)[1]
          @overhead = /overhead[:]*\s*(\S*)/.match(details)[1]
          psnr_match = /PSNR=(.*)\s*size=/.match(details)
          @psnr = psnr_match[1].strip if psnr_match
          return true
        end
        
        #[mp3 @ 0x54340c]flv doesnt support that sample rate, choose from (44100, 22050, 11025)
        #Could not write header for output file #0 (incorrect codec parameters ?)
        
        raise TranscoderError::UnexpectedResult, details
      end

      def sanitary_match(regexp, string)
        match = regexp.match(string)
        return match[1] if match
      end
      
    end
  end
end
