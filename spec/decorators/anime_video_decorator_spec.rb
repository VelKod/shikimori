describe AnimeVideoDecorator do
  let(:decorator) { AnimeVideoDecorator.new video }

  describe '#player_url' do
    subject { decorator.player_url }
    let(:video) { create :anime_video, url: url }

    context 'vk' do
      context 'with_rejected_broken_report' do
        let!(:rejected_report) { create :anime_video_report, kind: 'broken', state: 'rejected', anime_video: video }

        context 'with_?' do
          let(:url) { 'http://www.vk.com?id=1' }
          it { should eq "#{url}&quality=360" }
        end

        context 'without_?' do
          let(:url) { 'http://www.vk.com' }
          it { should eq "#{url}?quality=360" }
        end
      end

      context 'with_rejected_wrong_report' do
        let!(:rejected_report) { create :anime_video_report, kind: 'wrong', state: 'rejected', anime_video: video }
        let(:url) { 'http://www.vk.com?id=1' }

        it { should eq url }
      end

      context 'without_reports' do
        let(:url) { 'http://www.vk.com?id=1' }
        it { should eq url }
      end
    end

    context 'sibnet' do
      let(:url) { "http://video.sibnet.ru/shell.swf?videoid=621188" }
      context 'with_rejected_broken_report' do
        let!(:rejected_report) { create :anime_video_report, kind: 'broken', state: 'rejected', anime_video: video }
        it { should eq url }
      end

      context 'without_reports' do
        it { should eq url }
      end
    end
  end

  #describe 'description' do
    #let(:anime) { build :anime, description: 'test' }
    #subject { decorator.description }

    #context 'first_episode' do
      #it { should eq BbCodeFormatter.instance.format_description('test', anime) }
    #end

    #context 'second_episode' do
      #before { allow_any_instance_of(AnimeVideoDecorator).to receive(:current_episode).and_return 2 }
      #it { should eq BbCodeFormatter.instance.format_description('test', anime) }
    #end
  #end

  #describe '#watch_increment_delay' do
    #let(:anime) { build :anime, duration: duration }
    #subject { decorator.watch_increment_delay }

    #context 'with_duration' do
      #let(:duration) { 2 }
      #it { should eq anime.duration * 60000 / 3 }
    #end

    #context 'without_duration' do
      #let(:duration) { 0 }
      #it { should be_nil }
    #end
  #end

  #describe 'videos' do
    #subject { decorator.videos }
    #let(:anime) { build :anime }
    #let(:episode) { 1 }

    #context 'anime_without_videos' do
      #it { should be_blank }
    #end

    #context 'anime_with_one_video' do
      #let(:video) { build(:anime_video, episode: episode) }
      #before { anime.anime_videos << video }
      #it { should eq episode => [video] }
    #end

    #context 'anime_with_two_videos' do
      #let(:video_1) { build(:anime_video, episode: episode) }
      #let(:video_2) { build(:anime_video, episode: episode) }
      #before { anime.anime_videos << [video_1, video_2] }
      #it { should eq episode => [video_1, video_2] }
    #end

    #context 'no_working' do
      #let(:video_1) { build(:anime_video, episode: episode, state: :broken) }
      #before { anime.anime_videos << [video_1] }
      #it { should be_empty }
    #end

    #context 'only_working' do
      #let(:video_1) { build(:anime_video, episode: episode, state: 'working') }
      #let(:video_2) { build(:anime_video, episode: episode, state: 'broken') }
      #let(:video_3) { build(:anime_video, episode: episode, state: 'wrong') }
      #before { anime.anime_videos << [video_1, video_2, video_3] }
      #it { should eq episode => [video_1] }
    #end
  #end

  #describe 'last_episode' do
    #subject { AnimeVideoDecorator.new(anime).last_episode }
    #let(:anime) { build :anime }
    #context 'without_video' do
      #it { should be_nil }
    #end

    #context 'with_video' do
      #let(:video_1) { build :anime_video, episode: 1 }
      #let(:video_2) { build :anime_video, episode: 2 }
      #before { anime.anime_videos << [video_1, video_2] }
      #it { should eq 2 }
    #end
  #end

  #describe 'current_author' do
    #subject { AnimeVideoDecorator.new(anime).current_author }
    #let(:anime) { build :anime }
    #before { allow_any_instance_of(AnimeVideoDecorator).to receive(:current_video).and_return video }

    #context 'current_video_nil' do
      #let(:video) { nil }
      #it { should be_blank }
    #end

    #context 'author_nil' do
      #let(:video) { build :anime_video, author: nil }
      #it { should be_blank }
    #end

    #context 'author_valid' do
      #let(:video) { build :anime_video, author: build(:anime_video_author, name: 'test') }
      #it { should eq 'test' }
    #end

    #context 'author_very_long' do
      #let(:video) { build :anime_video, author: build(:anime_video_author, name: 'test12345678901234567890') }
      #it { should eq 'test1234567890123...' }
    #end
  #end

  #describe 'last_date' do
    #subject { AnimeVideoDecorator.new(anime).last_date }
    #let(:last_date) { DateTime.now }

    #context 'with_video' do
      #let(:anime) { build :anime, anime_videos: [build(:anime_video, created_at: last_date)] }
      #it { should eq last_date }
    #end

    #context 'without_video' do
      #let(:anime) { build :anime, created_at: last_date }
      #it { should eq last_date }
    #end
  #end
end
