class ProcessTest < Picotest::Test
  def test_self_returns_an_instance
    assert_equal Kernel::Process, Kernel::Process.self.class
  end

  def test_self_returns_the_jid
    assert_equal 0, Kernel::Process.self.jid
  end

  def test_self_returns_the_pid
    assert_equal Process.pid, Kernel::Process.self.pid
  end

  def test_self_returns_the_parent_pid
    assert_equal Process.ppid, Kernel::Process.self.ppid
  end

  def test_self_returns_the_uid
    assert_equal Process.uid, Kernel::Process.self.uid
  end

  def test_self_returns_the_command
    assert_equal "picoruby", Kernel::Process.self.command
  end

  def test_parent_returns_a_kernel_process
    assert_equal Kernel::Process, Kernel::Process.self.parent.class
  end

  def test_all_returns_an_array
    assert_equal Array, Kernel::Process.all.class
  end

  def test_each_includes_self
    pids = Kernel::Process.map { |process| process.pid }
    assert pids.include?(Process.pid)
  end

  def test_find_by_returns_a_kernel_process
    assert_equal Kernel::Process, Kernel::Process.find_by(Process.pid).class
  end

  def test_reload_returns_self
    process = Kernel::Process.self
    assert_equal process, process.reload
  end

  def test_inspect_includes_the_pid
    process = Kernel::Process.self
    assert process.inspect.include?("pid=#{process.pid}")
  end

  def test_starts_at_is_an_alias_of_start_time
    process = Kernel::Process.self
    assert_equal process.start_time, process.starts_at
  end
end
