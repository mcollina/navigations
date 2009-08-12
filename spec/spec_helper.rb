require 'rubygems'
require 'spec'
require 'activesupport'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

unless Object.const_defined?(:ApplicationController)
  class ApplicationController
  end
end

unless Object.const_defined?(:I18n)
  module I18n
  end
end