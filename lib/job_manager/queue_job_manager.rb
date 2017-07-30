require_relative 'job_manager'
require_relative '../job'
require_relative '../validator'
require_relative '../data_manager'
require 'forwardable'

class QueueJobManager < JobManager
  extend Forwardable
  def_delegators :@data_manager, :find_by_dependency, :insert_before, :append, :jobs
  def_delegator :@validator, :validate!

  def initialize(*params)
    @data_manager = DataManager.new
    @validator = Validator.new
    super
  end

  def ids
    jobs.map(&:id)
  end

  private

  def each_job(job_data)
    id, dependency = job_data.reject(&:empty?)
    add(Job.new(id: id, dependency: dependency))
  end

  def add(job)
    validate!(job: job, data_manager: @data_manager)
    depended_job = find_by_dependency(job.id)
    if depended_job
      insert_before(depended_job, job)
    else
      append(job) unless depended_job
    end
  end
end
