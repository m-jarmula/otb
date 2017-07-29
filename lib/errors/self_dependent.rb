class SelfDependentError < StandardError
  def initialize(msg = 'Job cant have self dependency')
    super
  end
end
