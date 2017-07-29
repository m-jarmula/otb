require_relative 'lib/job_manager/queue_job_manager'

string = <<-EOT
a =>
b => c
c => f
d => a
e => b
f =>
EOT

string2 = <<-EOT
a =>
b => c
c => f
d => a
e =>
f => b
EOT

string3 = <<-EOT
a =>
b => c
c =>
EOT

queue = QueueJobManager.new(string)
p queue.jobs.map(&:id)
