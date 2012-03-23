require 'singleton'

class ApplicationState
  include Singleton

  def initialize
    @state = 'state1'
  end

  def set(state)
    @state = state
  end

  def get
    @state.to_sym
  end
end

