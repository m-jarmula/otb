require 'spec_helper'

describe 'DataManager' do
  let(:data_manager) { DataManager.new }

  describe '#append' do
    it 'adds element to the end' do
      data_manager.send(:append, 'a')
      data_manager.send(:append, 'b')
      expect(data_manager.jobs).to include('a', 'b')
      expect(data_manager.jobs.last).to eq('b')
    end
  end

  describe '#insert_before' do
    it 'adds elment before different element' do
      data_manager.send(:append, 'a')
      data_manager.send(:insert_before, 'a', 'b')
      expect(data_manager.jobs).to include('a', 'b')
      expect(data_manager.jobs.first).to eq('b')
    end
  end

  describe '#find_by_dependnecy' do
    let(:job) { Job.new(id: 'b', dependency: 'a') }

    it 'searches for job by jobs dependency' do
      data_manager.send(:append, job)
      expect(data_manager.find_by_dependency('a').id).to eq(job.id)
    end
  end
end
