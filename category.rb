class Category
  def initialize(name)
    @name = name
  end

  def to_sym
    @name.to_sym
  end

  def param_start
    @name + '-start'
  end

  def param_end
    @name + '-end'
  end

  def param_granularity
    @name + '-granularity'
  end
end

