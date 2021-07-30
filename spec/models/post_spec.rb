require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post){ create :post }

  shared_examples 'stored accessor' do |attribute_name, value|
    it "works as stored accessor" do
      subject.public_send "#{attribute_name}=", value
      subject.save!

      reloaded_model = described_class.find subject.id
      expect(reloaded_model.public_send attribute_name).to eql value
    end
  end

  describe '#draft[=]' do
    before do
      expect(post.draft).to be false # foolproof check
    end

    it_behaves_like 'stored accessor', :draft, true
  end

  example '#draft? returns the same value as #draft' do
    post.draft = true
    expect(post.draft?).to be true

    post.draft = false
    expect(post.draft?).to be false
  end

  context '#name[=]' do
    it_behaves_like 'stored accessor', :name, 'Тестовое название'
  end

  context '#seo_url[=]' do
    it_behaves_like 'stored accessor', :seo_url, 'god-loves-everyone'
  end

  describe '#components' do
    it 'returns all associated components'
  end

  describe '#destroy' do
    it 'destroys all associated components'
  end

  shared_examples_for 'not valid' do |attribute_name|
    it 'is not valid' do
      expect(subject).to be_invalid
    end

    it "has an error for #{attribute_name}" do
      subject.validate
      expect(subject.errors).to have_key attribute_name
    end
  end

  describe 'Validation' do
    context 'without #name' do
      before{ subject.name = ' ' }
      it_behaves_like 'not valid', :name
    end

    context 'without #draft' do
      before{ subject.draft = nil }
      it_behaves_like 'not valid', :draft
    end

  end

end
