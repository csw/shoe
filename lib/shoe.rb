require 'pathname'
require 'rbconfig'
require 'rbconfig/datadir'

module Shoe
  VERSION = '0.6.0'

  autoload :Extensions, 'shoe/extensions'
  autoload :Generator,  'shoe/generator'
  autoload :Tasks,      'shoe/tasks'

  def self.datadir
    @@datadir ||= begin
      datadir = RbConfig.datadir('shoe')
      if !File.exist?(datadir)
        warn "#{datadir} does not exist. Trying again with relative data directory."
        datadir = File.expand_path('../../data/shoe', __FILE__)
      end
      Pathname.new(datadir)
    end
  end
end
