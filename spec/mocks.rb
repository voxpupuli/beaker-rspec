class MockIO < IO
  def initialize
  end

  methods.each do |meth|
    define_method(:meth) {}
  end

  def === other
    super other
  end
end
