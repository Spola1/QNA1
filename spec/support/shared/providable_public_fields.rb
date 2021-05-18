shared_examples_for 'providable public fields' do
  it 'returns all public fields' do
    fields_list.each do |attr|
      expect(object_response[attr]).to eq object.send(attr).as_json
    end
  end
end
