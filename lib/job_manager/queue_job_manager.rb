require_relative 'job_manager'
require_relative '../job'
require_relative '../errors/self_dependent'
require_relative '../errors/circural_dependency'
require_relative '../data_manager'
require 'forwardable'

class QueueJobManager < JobManager
  extend ::Forwardable
  def_delegators :@data_manager, :get_index, :find_by_id, :find_by_dependency, :insert_before,
                 :append, :jobs

  private

  def initialize(*params)
    @data_manager = DataManager.new
    super
  end

  def each_job(job_data)
    id, dependency = job_data.reject(&:empty?)
    add(Job.new(id: id, dependency: dependency))
  end

  def add(job)
    validate(job)
    depended_job = find_by_dependency(job.id)
    if depended_job
      insert_before(depended_job, job)
    else
      append(job) unless depended_job
    end
  end

  def validate(job)
    raise ::SelfDependentError if job.self_dependent?
    dependency = find_by_id(job.dependency)
    raise ::CircuralDependency if circural_dependency?(job, dependency)
  end

  def circural_dependency?(job, job_dependency_object)
    next_dependency = find_by_id(job_dependency_object.dependency)
    return true if job.id == job_dependency_object.dependency
    return false if next_dependency.nil?
    circural_dependency?(job, next_dependency)
  end
end
