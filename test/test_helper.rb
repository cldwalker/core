require 'rubygems'
require 'test/unit'
require 'context' #gem install jeremymcanally-context -s http://gems.github.com
require 'matchy' #gem install jeremymcanally-matchy -s http://gems.github.com
require 'mocha'
#require 'pending' #gem install jeremymcanally-pending -s http://gems.github.com
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'core'

class Test::Unit::TestCase
  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end
end

#from ActiveSupport
class Hash
  def slice(*keys)
    reject { |key,| !keys.include?(key) }
  end
end
