describe Topics::Factory do
  describe '.build' do
    let(:factory) { Topics::Factory.new is_preview }
    subject(:view) { factory.build topic }

    let(:section) { nil }
    let(:is_preview) { false }

    context 'common topic' do
      let(:topic) { build :entry }

      it { expect(view).to be_a Topics::View }
      it { expect(view.is_preview).to eq false }

      context 'preview' do
        let(:is_preview) { true }
        it { expect(view.is_preview).to eq true }
      end
    end

    context 'review' do
      let(:topic) { build :review_comment }
      it { expect(view).to be_a Topics::ReviewView }
    end

    context 'cosplay' do
      let(:topic) { build :cosplay_comment }
      it { expect(view).to be_a Topics::CosplayView }
    end

    context 'contest' do
      let(:topic) { build :contest_comment, linked: build_stubbed(:contest) }
      it { expect(view).to be_a Topics::ContestView }
    end

    context 'anime news' do
      context 'generated' do
        let(:topic) { build :anime_news, generated: true }
        it { expect(view).to be_a Topics::GeneratedNewsView }
      end

      context 'not generated' do
        let(:topic) { build :anime_news, generated: false }
        it { expect(view).to be_a Topics::View }
      end
    end
  end
end
