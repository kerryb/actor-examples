class Counter
  def initialize
    @count = 0
  end

  def increment_and_use
    do_something_slow
    @count = do_something_with(@count)
  end

  def to_s
    @count.to_s
  end

  private

  def do_something_slow
    sleep(rand / 10)
  end

  def do_something_with(count)
    sleep(rand / 500)
    count + 1
  end
end

counter = Counter.new

100.times do
  counter.increment_and_use
end

puts counter
