shared_examples_for 'invalid' do |attribute_name|
  it 'is not valid' do
    expect(subject).to be_invalid
  end

  it "has an error for #{attribute_name}" do
    subject.validate
    expect(subject.errors).to have_key attribute_name
  end
end