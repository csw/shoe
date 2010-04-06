$:.unshift File.expand_path('../lib', __FILE__)
require 'shoe/version'

Gem::Specification.new do |spec|
  spec.name    = 'shoe'
  spec.version = Shoe::VERSION

  spec.summary = 'Another take on hoe, jeweler & friends.'
  spec.description = spec.summary
  spec.author = 'Matthew Todd'
  spec.email  = 'matthew.todd@gmail.com'
  spec.homepage = 'http://github.com/matthewtodd/shoe'

  spec.requirements = ['git']
  spec.required_rubygems_version = '>= 1.3.6'
  spec.add_runtime_dependency 'rake'

  def spec.git_files(glob=nil)
    `git ls-files -z #{glob}`.split("\0")
  end

  spec.files       = spec.git_files
  spec.executables = spec.git_files('bin/*').map { |f| File.basename(f) }
  spec.extensions  = spec.git_files('ext/**/extconf.rb')

  spec.extra_rdoc_files = spec.git_files('**/*.rdoc')
  spec.rdoc_options     = %W(
    --main README.rdoc
    --title #{spec.full_name}
    --inline-source
  )
end
