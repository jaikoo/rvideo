module RVideo # :nodoc:
  module Tools # :nodoc:
    class AbstractTool
      
      #
      # AbstractTool is an interface to every transcoder tool class (e.g. 
      # ffmpeg, flvtool2). Called by the Transcoder class.
      #
      
      def self.assign(cmd, options = {})
        tool_name = cmd.split(" ").first
        begin
          tool = "RVideo::Tools::#{tool_name.classify}".constantize.send(:new, cmd, options)
        rescue NameError, /uninitialized constant/
          raise TranscoderError::UnknownTool, "The recipe tried to use the '#{tool_name}' tool, which does not exist."
        end
      end
      
      
      module InstanceMethods
        attr_reader :options, :command, :raw_result
        attr_writer :original
        
        def initialize(raw_command, options = {})
          @raw_command = raw_command
          @options = HashWithIndifferentAccess.new(options)
          @command = interpolate_variables(raw_command)
        end

        #
        # Execute the command and parse the result.
        #
        
        def execute
          final_command = "#{@command} 2>&1"
          Transcoder.logger.info("\nExecuting Command: #{final_command}\n")
          @raw_result = `#{final_command}`
          Transcoder.logger.info("Result: \n#{@raw_result}")
          parse_result(@raw_result)
        end
        
        #
        # Magic parameters
        #
        
        def original_fps
          raise ParameterError, "The #{self.class} tool has not implemented the original_fps method."
        end
        
        def resolution
          if @options['resolution']
            @options['resolution']
          else
            "#{calculate_width}x#{calculate_height}"
          end
        end

        def aspect_ratio
          "#{calculate_width}:#{calculate_height}"
        end

        def fps
          case fps.to_s
          when "?"
            inspect_original if @original.nil?
            @original.fps
          else
            @options['fps']
          end
        end

        def calculate_width
          width = @options['width']
          height = @options['height']
          if width.to_i > 0
            width
          end

          case width
          when "x"
            inspect_original if @original.nil?
            x = ((@original.width.to_f / @original.height.to_f) * height.to_f).to_i
            (x.to_f / 16).round * 16
          when "?"
            inspect_original if @original.nil?
            @original.width
          else
            width
          end
        end

        def calculate_height
          width = @options['width']
          height = @options['height']
          if height.to_i > 0
            height
          end
          #w/(ow/oh) = h

          case height
          when "x"
            inspect_original if @original.nil?
            x = (width.to_f / (@original.width.to_f / @original.height.to_f)).to_i
            (x.to_f / 16).round * 16
          when "?"
            inspect_original if @original.nil?
            @original.height
          else
            height
          end
        end
        
        private
        
        
        #
        # Look for variables surrounded by $, and interpolate with either 
        # variables passed in the options hash, or special methods provided by
        # the tool class (e.g. "$original_fps$" with ffmpeg).
        #
        # $foo$ should match
        # \$foo or $foo\$ or \$foo\$ should not

        def interpolate_variables(raw_command)
          raw_command.scan(/[^\\]\$[-_a-zA-Z]+\$/).each do |match|
            match.strip!
            raw_command.gsub!(match, matched_variable(match))
          end
          raw_command.gsub("\\$", "$")
        end
        
        #
        # Strip the $s. First, look for a supplied option that matches the
        # variable name. If one is not found, look for a method that matches.
        # If not found, raise ParameterError exception.
        # 
        
        def matched_variable(match)
          variable_name = match.gsub("$","")
          if self.respond_to? variable_name
            self.send(variable_name)
          elsif @options.key?(variable_name) 
            @options[variable_name] || ""
          else
            raise TranscoderError::ParameterError, "command is looking for the #{variable_name} parameter, but it was not provided. (Command: #{@raw_command})"
          end
        end
        
        def inspect_original
          @original = Inspector.new(:file => options[:input_file])
        end
      end
    
    end
  end
end
