class JobManager
  ContractNotImplementedError = Class.new(NotImplementedError)

  def initialize(string)
    string.scan(/(\w+) => ?(\w?)/i).each(&method(:each_job))
  end

  private

  def each_job(job_data)
    raise ContractNotImplementedError, 'Class should implement contract each_job'
  end
end
