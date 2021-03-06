describe Animes::Filters::ByRating do
  subject { described_class.call scope, terms }

  let(:scope) { Anime.order :id }

  let!(:anime_1) { create :anime, rating: :r }
  let!(:anime_2) { create :anime, rating: :r }
  let!(:anime_3) { create :anime, rating: :g }
  let!(:anime_4) { create :anime, rating: :r_plus }

  context 'positive' do
    context 'r' do
      let(:terms) { 'r' }
      it { is_expected.to eq [anime_1, anime_2] }
    end

    context 'r' do
      let(:terms) { 'g' }
      it { is_expected.to eq [anime_3] }
    end

    context 'r,g' do
      let(:terms) { 'r,g' }
      it { is_expected.to eq [anime_1, anime_2, anime_3] }
    end
  end

  context 'negative' do
    context '!r' do
      let(:terms) { '!r' }
      it { is_expected.to eq [anime_3, anime_4] }
    end

    context '!g' do
      let(:terms) { '!g' }
      it { is_expected.to eq [anime_1, anime_2, anime_4] }
    end

    context '!r,!g' do
      let(:terms) { '!r,!g' }
      it { is_expected.to eq [anime_4] }
    end
  end

  context 'both' do
    context '!r,!g' do
      let(:terms) { 'r,!g' }
      it { is_expected.to eq [anime_1, anime_2] }
    end

    context '!r,!g' do
      let(:terms) { '!r,g' }
      it { is_expected.to eq [anime_3] }
    end
  end

  context 'invalid parameter' do
    let(:terms) { %w[s !s].sample }
    it { expect { subject }.to raise_error InvalidParameterError }
  end

  context 'invalid scope' do
    let(:scope) { [Manga.all, Ranobe.all].sample }
    let(:terms) { 'S' }
    it { expect { subject }.to raise_error InvalidParameterError }
  end
end
