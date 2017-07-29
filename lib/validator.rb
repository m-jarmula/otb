require_relative 'errors/self_dependent'
require_relative 'errors/circural_dependency'

class Validator
  def self.validate(job:, dependency:, data_manager:)
    @job = job
    @dependency = dependency
    @data_manager = data_manager
    validate_self_dependency
    validate_circural_dependency
  end

  def self.validate_self_dependency
    raise ::SelfDependentError if @job.self_dependent?
  end

  def self.validate_circural_dependency
    return unless @dependency
    raise ::CircuralDependency if circural_dependency?(@job, @dependency)
  end


  def self.circural_dependency?(job, job_dependency_object)
    next_dependency = @data_manager.find_by_id(job_dependency_object.dependency)
    return true if job.id == job_dependency_object.dependency
    return false if next_dependency.nil?
    circural_dependency?(job, next_dependency)
  end
end
