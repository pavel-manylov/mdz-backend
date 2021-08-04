shared_examples_for 'post modify interaction' do
  subject(:outcome) { described_class.run interaction_params }

  let(:post_name) { 'Публикация 123' }
  let(:post_seo_url) { 'post-123' }

  describe '.run' do
    context 'modified post' do
      subject(:modified_post) { outcome.result.reload }

      it 'has passed #name' do
        expect(modified_post.name).to eql post_name
      end

      it 'has passed #seo_url' do
        expect(modified_post.seo_url).to eql post_seo_url
      end
    end
  end

  describe 'Validation' do
    example 'foolproof check' do
      expect(outcome).to be_valid
    end

    context 'without #name' do
      let(:post_name) { '' }
      it_behaves_like 'invalid', :name, validate: false
    end
  end
end