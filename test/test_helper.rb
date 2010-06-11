require 'rubygems'
require 'bacon'
require 'mocha-on-bacon'
require 'mocha'
require 'core'

class Bacon::Context
  def before_all; yield; end

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