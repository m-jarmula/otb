require_relative 'job_manager'
require_relative '../job'
require_relative '../validator'
require_relative '../data_manager'
require 'forwardable'

class QueueJobManager < JobManager
  extend ::Forwardable
  def_delegators :@data_manager, :find_by_dependency, :insert_before, :append, :jobs

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
    ::Validator.validate(job: job, data_manager: @data_manager)
  end
end
