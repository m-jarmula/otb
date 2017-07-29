class DataManager
  attr_reader :jobs

  def initialize
    @jobs = []
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

  def insert_before(before_node, job)
    depended_job_index = get_index(before_node)
    @jobs.insert(depended_job_index, job)
  end

  def append(job)
    @jobs << job
  end
end
