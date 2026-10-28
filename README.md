<p align="center">
  <a href="https://github.com/altruby/picoruby-freebsd-process">
    <img src="logo.png" width="200" height="200" border="0" alt="picoruby-freebsd-process">
  </a>
</p>
<p align="center">
  <strong>picoruby-freebsd-process</strong>
</p>

## About

[picoruby](https://picoruby.org/) + libutil = picoruby-freebsd-process.

This project combines an implementation of ruby that can run on a
single-chip microcontroller and the process API from the
[FreeBSD](https://www.freebsd.org/) project. Although
[picoruby](https://picoruby.org/) markets itself towards embedded devices it
also happens to run exceptionally well on POSIX systems too. It is more or
less straight forward to embed picoruby's bytecode into a C program.

## Install

#### make

The next few lines will build your own copy
of the picoruby executable. The executable
is linked against picoruby-freebsd-process
and when it is run it automatically has access
to the picoruby-freebsd-process classes, modules
and methods. This can be surprising compared
to mainstream CRuby where there is a single
copy of the executable that is built once on
install:

    $ git clone --recursive-submodules https://github.com/picoruby/picoruby picoruby
    $ git clone https://github.com/altruby/picoruby-freebsd-process
    $ cd picoruby-freebsd-process
    $ make build
    $ ../picoruby/build/picoruby-freebsd-process/bin/picoruby -e 'p Kernel::Process.self.pid'

#### build_config.rb

The steps:

```sh
mkdir myapp
touch build_config.rb
cd ../picoruby
MRUBY_CONFIG=../myapp/build_config.rb rake
```

The configuration (`build_config.rb`):

```ruby
MRuby::Build.new("app") do |conf|
  conf.toolchain
  conf.gembox "default"
  conf.gem github: "altruby/picoruby-freebsd-process", branch: "main"
end
```

## Quick start

#### Kernel::Process

`Kernel::Process` is enumerable. It provides access to every process that is
visible to the current process. We can use the `each` method to iterate over
processes, we can use the `select` method to filter, we can use the `find`
method to find a process, and we can use the `map` method to transform:

```ruby
##
# Iterate all
Kernel::Process.each do |process|
  print "pid=#{process.pid}",
        "command=#{process.command}",
        "uid=#{process.uid}",
        "\n\n"
end

##
# Select processes by command
Kernel::Process.select do |process|
  process.command == "sshd"
end

##
# Find a process by pid
process = Kernel::Process.find do |process|
  process.pid == 1
end

##
# Transform processes
pids = Kernel::Process.map(&:pid)
```

#### Kernel::Process.self

`Kernel::Process.self` returns the `Kernel::Process` that stands for the current
process. It is the same instance that `find_by` would return for
`Process.pid`:

```ruby
process = Kernel::Process.self
print "pid ", "\t", process.pid     , "\n"
print "ppid", "\t", process.ppid    , "\n"
print "uid ", "\t", process.uid     , "\n"
print "cmd ", "\t", process.command , "\n"
```

#### Kernel::Process.find_by

`Kernel::Process.find_by` finds a process by pid and returns a
`Kernel::Process` instance:

```ruby
process = Kernel::Process.find_by(1)
print "pid   ", "\t", process.pid        , "\n"
print "cmd   ", "\t", process.command    , "\n"
print "start ", "\t", process.start_time , "\n"
```

A pid that does not exist raises `Errno::ESRCH`.

#### Accessors

| Method | Returns |
| ------ | ------- |
| `#pid` | the process id |
| `#ppid` | the parent process id |
| `#pgid` | the process group id |
| `#sid` | the session id |
| `#tpgid` | the terminal process group id |
| `#uid` | the user id |
| `#ruid` | the real user id |
| `#svuid` | the saved user id |
| `#login` | the login name |
| `#login_class` | the login class |
| `#command` | the command name |
| `#jid` | the jail id |
| `#start_time` | a `Time` for when the process started |
| `#runtime` | the microseconds the process has run for |

#### Kernel::Process#parent

`#parent` returns the parent as a `Kernel::Process` instance, or nil when the
parent has already exited:

```ruby
process = Kernel::Process.self
parent  = process.parent
print "ppid ", "\t", parent.pid , "\n"
print "cmd  ", "\t", parent.command , "\n"
```

#### Kernel::Process#reload

An instance is a snapshot of a process, and `#reload` takes a new one. It
returns self, so it can be chained:

```ruby
process = Kernel::Process.self
process.reload
print "cmd ", "\t", process.command , "\n"
```

#### Kernel::Process#inspect

`#inspect` returns a one line summary of a process:

```ruby
puts Kernel::Process.self.inspect
# => #<Kernel::Process:0x1e0 command=picoruby pid=12345 uid=1000>
```

## License

[0BSD License](https://opensource.org/license/0bsd)
<br>
See [LICENSE](./LICENSE)
