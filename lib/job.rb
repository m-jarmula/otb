class Job
  attr_reader :id, :dependency

  def initialize(id:, dependency: nil)
    @id = id
    @dependency = dependency
  end

  def self_dependent?
    @id == @dependency
  end
end
