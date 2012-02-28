require 'logger'

module Import

  class << self
    attr_accessor :logger
  end
  self.logger = Logger.new STDOUT

end

require 'import/source'
