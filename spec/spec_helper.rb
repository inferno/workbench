$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'

require 'work_bench'
require 'rspec'
require 'stringio'

RSpec.configure do |config|

  config.before :each do
    ARGV.replace []
  end

  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end

end
