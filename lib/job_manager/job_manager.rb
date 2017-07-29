require_relative '../errors/contract_not_implemented'

class JobManager
  def initialize(string)
    string.scan(/(\w+) => ?(\w?)/i).each(&method(:each_job))
  end

  private

  def each_job(job_data)
    raise ::ContractNotImplementedError.new('each_job')
  end
end
