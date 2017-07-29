require 'spec_helper'

describe 'DataManager' do
  let(:data_manager) { DataManager.new }

  describe '#append' do
    it 'adds element to the end' do
      data_manager.append('a')
      data_manager.append('b')
      expect(data_manager.jobs).to include('a', 'b')
      expect(data_manager.jobs.last).to eq('b')
    end
  end

  describe '#insert_before' do
    it 'adds elment before different element' do
      data_manager.append('a')
      data_manager.insert_before('a', 'b')
      expect(data_manager.jobs).to include('a', 'b')
      expect(data_manager.jobs.first).to eq('b')
    end
  end

  describe '#get_index' do
    it 'returns index of given param' do
      data_manager.append('a')
      expect(data_manager.get_index('a')).to eq(0)
    end
  end

  describe '#find_by_dependnecy' do
    let(:job) { Job.new(id: 'b', dependency: 'a') }

    it 'searches for job by jobs dependency' do
      data_manager.append(job)
      expect(data_manager.find_by_dependency('a').id).to eq(job.id)
    end
  end
end
