describe Line do
  
  describe '#to_json' do
    let(:line) { create(:line) }
    subject { MultiJson.load(line.to_json) }
    its(:keys) { should eq(%w(id filters name visible updated_at)) }
  end
  
end