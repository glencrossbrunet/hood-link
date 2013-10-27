# == Schema Information
#
# Table name: sample_metrics
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

require 'spec_helper'

describe SampleMetric do
  
  describe '#validate' do
    let(:metric) { create(:sample_metric) }
    subject { metric }
    
    describe 'name' do
      before { metric.name = nil }
      it { should_not be_valid }
    end
  end
  
end
