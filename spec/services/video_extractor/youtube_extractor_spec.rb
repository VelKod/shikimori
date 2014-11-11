describe VideoExtractor::YoutubeExtractor do
  let(:service) { VideoExtractor::YoutubeExtractor.new url }

  describe :fetch do
    subject { service.fetch }

    context :valid_url do
      context :common_case do
        let(:url) { 'http://www.youtube.com/watch?v=VdwKZ6JDENc' }

        its(:hosting) { should eq :youtube }
        its(:image_url) { should eq 'http://img.youtube.com/vi/VdwKZ6JDENc/mqdefault.jpg' }
        its(:player_url) { should eq 'http://youtube.com/v/VdwKZ6JDENc' }
      end

      context :with_time do
        let(:url) { 'http://www.youtube.com/watch?v=VdwKZ6JDENc#t=123' }

        its(:hosting) { should eq :youtube }
        its(:image_url) { should eq 'http://img.youtube.com/vi/VdwKZ6JDENc/mqdefault.jpg' }
        its(:player_url) { should eq 'http://youtube.com/v/VdwKZ6JDENc?start=123' }
      end

      context :params_after do
        let(:url) { 'http://youtube.com/watch?v=VdwKZ6JDENc&ff=vcxvcx' }
        its(:player_url) { should eq 'http://youtube.com/v/VdwKZ6JDENc' }
      end

      context :params_before do
        let(:url) { 'http://youtube.com/watch?sdfdsf=dfdfs&v=VdwKZ6JDENc' }
        its(:player_url) { should eq 'http://youtube.com/v/VdwKZ6JDENc' }
        it { should be_present }
      end

      context :params_surrounded do
        let(:url) { 'http://youtube.com/watch?sdfdsf=dfdfs&v=VdwKZ6JDENc&ff=vcxvcx#t=123' }
        its(:player_url) { should eq 'http://youtube.com/v/VdwKZ6JDENc?start=123' }
        it { should be_present }
      end
  end

    context :invalid_url do
      let(:url) { 'http://vk.com/video98023184_165811692zzz' }
      it { should be_nil }
    end
  end
end
