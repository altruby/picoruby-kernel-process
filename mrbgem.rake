load File.join(__dir__, "mrblib", "process", "version.rb")

MRuby::Gem::Specification.new("picoruby-freebsd-process") do |spec|
  spec.license = '0BSD'
  spec.author  = '0x1eef'
  spec.summary = 'picoruby + BSD process APIs = picoruby-freebsd-process'
  spec.version = Kernel::Process::VERSION

  if build.picoruby?
    spec.require_name = "freebsd-process"
    spec.add_dependency "mruby-errno", 
                        github: "mruby/mruby",
                        branch: "master",
                        path: "mrbgems/mruby-errno"
  end

  spec.cc.flags << '-Wall'
  spec.cc.flags << '-Wpedantic'
  spec.linker.libraries << 'util'
end
