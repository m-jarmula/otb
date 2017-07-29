require_relative 'job_manager'
require_relative '../job'
require_relative '../errors/self_dependent'
require_relative '../errors/circural_dependency'

class QueueJobManager < JobManager
  SelfDependentError = Class.new(StandardError)
  attr_reader :jobs

  private

  def initialize(*params)
    @jobs = []
    super
  end

  def each_job(job_data)
    id, dependency = job_data.reject(&:empty?)
    add(Job.new(id: id, dependency: dependency))
  end

  def add(job)
    raise ::SelfDependentError if job.self_dependent?
    depended_job_index = get_index(find_by_dependency(job.id))
    dependency = find_by_id(job.dependency)
    dd = circural_dependency?(job, dependency) if dependency
    if(depended_job_index)
      p dd if dependency
      @jobs.insert(depended_job_index, job)
    else
      @jobs << job
    end
  end

  def circural_dependency?(job, job_dependency_object)
    next_dependency = find_by_id(job_dependency_object.dependency)
    return true if job.id == job_dependency_object.dependency
    return false if next_dependency.nil?
    circural_dependency?(job, next_dependency)
  end

  def get_index(job)
    @jobs.index(job)
  end

  def find_by_id(id)
    @jobs.find { |job| job.id == id }
  end

  def find_by_dependency(id)
    @jobs.find { |job| job.dependency == id }
  end
end
