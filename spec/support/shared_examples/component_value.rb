# Проверяет, что `value_object` ведёт себя как объект-значение компонента.
# Не проверяет работу непосредственно аксессора хранения значения (value).
#
# При установке параметра `container` в true не запускаются тесты, специфичные для компонентов с единичным значением.
#
# @example
#
#   describe SomeValue do
#     it_behaves_like 'component value' do
#       subject(:value_object){  create :some_value }
#     end
#   end
#
shared_examples_for 'component value' do |container: false|
  describe '#component' do
    subject(:component) { value_object.component }
    let!(:parent_component) { create :component, value: value_object }

    it 'returns parent component' do
      expect(component).to eql parent_component
    end
  end

  describe 'Validation' do
    context 'without #value' do
      before { subject.value = nil }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end unless container

  end
end