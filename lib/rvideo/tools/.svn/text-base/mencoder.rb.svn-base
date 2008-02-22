module RVideo
  module Tools
    class Mencoder
      include AbstractTool::InstanceMethods

      attr_reader :frame, :size, :time, :bitrate, :video_size, :audio_size, :fps

      def tool_command
        'mencoder'
      end

      def original_fps
        inspect_original if @original.nil?
        if @original.fps
          "-r #{@original.fps}" 
        else
          ""
        end
      end

      def parse_result(result)
        if m = /Exiting.*No output file specified/.match(result)
          raise TranscoderError::InvalidCommand, "no command passed to mencoder, or no output file specified"
        end
        
        if m = /Sorry, this file format is not recognized\/supported/.match(result)
          raise TranscoderError::InvalidFile, "unknown format"
        end
        
        if m = /Cannot open file\/device./.match(result)
          raise TranscoderError::InvalidFile, "I/O error"
        end
        
        if m = /File not found:$/.match(result)
          raise TranscoderError::InvalidFile, "I/O error"
        end
        
        video_details = result.match /Video stream:(.*)$/
        if video_details
          @bitrate = sanitary_match(/Video stream:\s*([0-9.]*)/, video_details[0])
          @video_size = sanitary_match(/size:\s*(\d*)\s*(\S*)/, video_details[0])
          @time = sanitary_match(/bytes\s*([0-9.]*)/, video_details[0])
          @frame = sanitary_match(/secs\s*(\d*)/, video_details[0])
          @fps = (@frame.to_f / @time.to_f).round_to(3)
        elsif result =~ /Video stream is mandatory/
          raise TranscoderError::InvalidFile, "Video stream required, and no video stream found"
        end
        
        audio_details = result.match /Audio stream:(.*)$/
        if audio_details
          @audio_size = sanitary_match(/size:\s*(\d*)\s*(\S*)/, audio_details[0])
        else
          @audio_size = 0
        end
        @size = (@video_size.to_i + @audio_size.to_i).to_s
      end

      def sanitary_match(regexp, string)
        match = regexp.match(string)
        return match[1] if match
      end
      
    end
  end
end
