shared_examples_for 'component modify interaction' do
  subject(:outcome) { described_class.run interaction_params }

  let(:component_display_class){ 'heading1' }
  let(:component_custom_fields) do
    {
      'mobile-class' => 'xLarge',
      'as-preview' => 'true'
    }
  end
  let(:component_public) { true }
  let(:component_type) { 'boolean' }
  let(:component_value) { true }
  let(:component_order) { 55 }

  describe '.run' do
    context 'modified component' do
      subject(:modified_component) { outcome.result.reload }

      it 'has passed #public flag' do
        expect(modified_component.public).to be component_public
      end

      it 'has passed #order' do
        expect(modified_component.order).to eq component_order
      end

      it 'has passed #display_class' do
        expect(modified_component.display_class).to eq component_display_class
      end

      context 'representative value' do
        subject(:representative_value) { modified_component.representative_value }

        context 'with passed boolean value' do
          let(:component_type) { 'boolean' }
          let(:component_value) { true }

          it 'has boolean representative value' do
            expect(representative_value).to be component_value
          end
        end

        context 'with passed string value' do
          let(:component_type) { 'string' }
          let(:component_value) { 'test string value' }

          it 'has string representative value' do
            expect(representative_value).to eql component_value
          end
        end

        context 'with passed relation value' do
          let(:component_type) { 'relation' }
          let(:component_value) do
            posts.map { |post| { 'id' => post.id } }
          end
          let(:posts) { create_list :post, 3 }

          it 'has correct posts linked as representative value' do
            expect(representative_value).to match_array posts
          end
        end
      end

      it 'sets custom fields' do
        expect(
          modified_component.custom_fields
        ).to match_array [
                           have_attributes(name: 'mobile-class', value: 'xLarge'),
                           have_attributes(name: 'as-preview', value: 'true')
                         ]
      end
    end
  end

  describe 'Validation' do
    example 'foolproof check' do
      expect(outcome).to be_valid
    end

    context 'with non-boolean value for public flag' do
      let(:component_public) { 'notbooleanatall' }

      it_behaves_like 'invalid', :public, validate: false
    end

    context 'with non-integer value for order' do
      let(:component_order) { 'abc' }

      it_behaves_like 'invalid', :order, validate: false
    end

    context 'with order less than zero' do
      let(:component_order) { -5 }

      it_behaves_like 'invalid', :order, validate: false
    end

    context 'with unknown type' do
      let(:component_type) { 'massive_attack' }

      it_behaves_like 'invalid', :type, validate: false
    end

    context 'with non-boolean value for boolean type' do
      let(:component_type) { 'boolean' }
      let(:component_value) { 'nonbool' }

      it_behaves_like 'invalid', :value, validate: false
    end

    context 'with non-string value for string type' do
      let(:component_type) { 'string' }
      let(:component_value) { true }

      it_behaves_like 'invalid', :value, validate: false
    end

    context 'with non-references values for relation type' do
      let(:component_type) { 'relation' }
      let(:component_value) do
        [{ 'non_id' => 123 }]
      end

      it_behaves_like 'invalid', :value, validate: false
    end

    context 'with unknown referenced post(s) as a value' do
      let(:component_type) { 'relation' }
      let(:component_value) do
        [{ 'id' => (Component.maximum(:id) || 0) + 1000 }]
      end

      it_behaves_like 'invalid', :value, validate: false
    end

    context 'without key for custom field' do
      let(:component_custom_fields) do
        { '' => 'value' }
      end

      it_behaves_like 'invalid', :custom_fields, validate: false

      example 'bla bla' do
        outcome
        puts 'something'
      end
    end

    context 'without value for custom field' do
      let(:component_custom_fields) do
        { 'key' => '' }
      end

      it_behaves_like 'invalid', :custom_fields, validate: false
    end
  end
end