class ContractNotImplementedError < StandardError
  def initialize(contract)
    super("Class should implement contract #{contract}")
  end
end
