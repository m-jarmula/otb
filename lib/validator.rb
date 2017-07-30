require_relative 'errors/self_dependent'
require_relative 'errors/circural_dependency'

class Validator
  def initialize(job, data_manager)
    @job = job
    @dependency = data_manager.find_by_id(job.dependency)
    @data_manager = data_manager
  end

  def self.validate!(job:, data_manager:)
    validator = new(job, data_manager)
    validator.send(:validate_self_dependency!)
    validator.send(:validate_circural_dependency!)
  end

  private

  def validate_self_dependency!
    raise ::SelfDependentError if @job.self_dependent?
  end

  def validate_circural_dependency!
    return unless @dependency
    raise ::CircuralDependencyError if circural_dependency?(@job, @dependency)
  end

  def circural_dependency?(job, job_dependency_object)
    next_dependency = @data_manager.find_by_id(job_dependency_object.dependency)
    return true if job.id == job_dependency_object.dependency
    return false if next_dependency.nil?
    circural_dependency?(job, next_dependency)
  end
end
