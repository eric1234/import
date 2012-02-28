Gem::Specification.new do |s|

  s.name        = "import_framework"
  s.version     = '0.0.1'
  s.authors     = ['Eric Anderson']
  s.email       = ['eric@pixelwareinc.com']

  s.files = Dir['lib/**/*.rb']
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'flexmock'
  
  s.summary     = 'A framework for managing an import/sync of data'
  s.description = <<DESCRIPTION
A framework to assist in importing data from a master to a slave.
Through a series of callbacks the framework figures out what to
add, edit and remove.
DESCRIPTION

end
