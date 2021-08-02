shared_examples_for 'stored accessor' do |attribute_name, value|
  it "works as stored accessor" do
    expected_value = value.is_a?(Proc) ? value.call : value

    subject.public_send "#{attribute_name}=", expected_value
    subject.save!

    reloaded_model = described_class.find subject.id
    expect(reloaded_model.public_send attribute_name).to eql expected_value
  end
end