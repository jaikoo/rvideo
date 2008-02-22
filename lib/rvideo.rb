$LOAD_PATH.unshift File.dirname(__FILE__) + '/rvideo'

require 'inspector'
require 'float'
require 'tools/abstract_tool'
require 'tools/ffmpeg'
require 'tools/mencoder'
require 'tools/flvtool2'
require 'errors'
require 'transcoder'
require 'active_support'

TEMP_PATH = File.expand_path(File.dirname(__FILE__) + '/../tmp')
FIXTURE_PATH = File.expand_path(File.dirname(__FILE__) + '/../spec/fixtures')
TEST_FILE_PATH = File.expand_path(File.dirname(__FILE__) + '/../spec/files')
REPORT_PATH = File.expand_path(File.dirname(__FILE__) + '/../report')

