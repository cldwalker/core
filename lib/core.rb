$:.unshift(File.dirname(__FILE__)) unless 
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'core/util'
require 'core/manager'
require 'core/loader'
require 'core/interface'

module Core
  extend Core::Interface
end
