ROOT = File.expand_path("..", __dir__)
PICORUBY_DIR = File.expand_path(ENV["PICORUBY_DIR"] || "../picoruby", ROOT)
TEST_DIR = File.join(ROOT, "test")
PICORUBY = File.join(PICORUBY_DIR, "build", "picoruby-freebsd-process", "bin", "picoruby")

require File.join(PICORUBY_DIR, "mrbgems", "picoruby-picotest", "mrblib", "picotest")

unless File.executable?(PICORUBY)
  abort "picoruby-freebsd-process: #{PICORUBY} is missing. Run `make build` first."
end

ENV["RUBY"] = PICORUBY

entries = Dir[File.join(TEST_DIR, "*_test.rb")].sort
if entries.empty?
  abort "picoruby-freebsd-process: no test files in #{TEST_DIR}"
end

runner = Picotest::Runner.new(
  TEST_DIR,
  require_name: "freebsd-process",
  load_path: ROOT,
  entries: entries
)

exit(runner.run == 0 ? 0 : 1)
