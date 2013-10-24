# == Schema Information
#
# Table name: sample_metrics
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

class SampleMetric < ActiveRecord::Base
  validates_presence_of :name
end
