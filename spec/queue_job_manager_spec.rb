require 'spec_helper'

describe 'QueueJobManager' do

  describe '#initialize' do
    it 'adds valid structure' do
      queue_job_manager = QueueJobManager.new('a =>')
      expect(queue_job_manager.ids).to include('a')
    end
  end

  describe '#ids' do
    context 'with three params, no dependency' do
      it 'returns valid job sequence no queue modification' do
        queue_job_manager = QueueJobManager.new("a =>\nb =>\nc =>")
        expect(queue_job_manager.ids.size).to eq(3)
        expect(queue_job_manager.ids).to include('a', 'b', 'c')
      end
    end

    context 'with three params, one dependency' do
      let(:queue_job_manager) { QueueJobManager.new("a =>\nb =>c\nc =>") }

      it 'returns valid job sequence' do
        expect(queue_job_manager.ids.size).to eq(3)
        expect(queue_job_manager.ids).to include('a', 'b', 'c')
      end

      it 'inserts c before b' do
        expect(queue_job_manager.jobs.last.dependency).to eq 'c'
      end
    end

    context 'with 6 params, multiple dependencies' do
      let(:queue_job_manager) { QueueJobManager.new("a =>\nb => c\nc => f\nd => a\ne => b\nf =>") }

      it 'returns valid job sequence' do
        expect(queue_job_manager.ids.size).to eq(6)
        expect(queue_job_manager.ids).to include('a', 'b', 'c', 'd', 'e', 'f')
      end

      it 'inserts elemenets in order' do
        expect(queue_job_manager.ids.to_s).to match /f.*c/
        expect(queue_job_manager.ids.to_s).to match /c.*b/
        expect(queue_job_manager.ids.to_s).to match /b.*e/
        expect(queue_job_manager.ids.to_s).to match /a.*d/
      end
    end

    context 'with self dependency' do
      it 'raises SelfDependentError' do
        expect { QueueJobManager.new("a =>\nb =>\nc => c") }.to raise_error SelfDependentError
      end
    end

    context 'with circural dependency' do
      it 'raises CircuralDependencyError' do
        expect do
          QueueJobManager.new("a =>\nb => c\nc => f\nd => a\ne =>\nf => b")
        end.to raise_error CircuralDependencyError
      end
    end
  end
end
