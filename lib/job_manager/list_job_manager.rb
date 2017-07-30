require_relative 'job_manager'
require_relative '../job'
require_relative '../validator'
require_relative '../data_manager'
require 'forwardable'

class ListJobManager < JobManager
  extend Forwardable
  def_delegator :Validator, :validate!
  def_delegator :@data_manager, :jobs

  def initialize(*params)
    @data_manager = DataManager.new
    # @validator = Validator.new
    super
  end

  def ids
    jobs.map(&:id)
  end

  private

  def each_job(job_data)
    id, dependency = job_data.reject(&:empty?)
    job = Job.new(id: id, dependency: dependency)
    validate!(job: job, data_manager: @data_manager)
    @data_manager.add(job)
  end
end
