class CircuralDependency < StandardError
  def initialize(msg = 'Job cant have circural dependency')
    super
  end
end
