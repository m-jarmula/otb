class DataManager
  attr_reader :jobs

  def initialize
    @jobs = []
  end

  def find_by_id(id)
    @jobs.find { |job| job.id == id }
  end

  def find_by_dependency(id)
    @jobs.find { |job| job.dependency == id }
  end

  def add(job)
    depended_job = find_by_dependency(job.id)
    if depended_job
      insert_before(depended_job, job)
    else
      append(job)
    end
  end

  private

  def insert_before(before_node, job)
    depended_job_index = @jobs.index(before_node)
    @jobs.insert(depended_job_index, job)
  end

  def append(job)
    @jobs << job
  end
end
