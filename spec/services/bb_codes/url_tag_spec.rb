describe BbCodes::UrlTag do
  subject { BbCodes::UrlTag.instance.format text }

  describe '#format' do
    let(:url) { 'http://site.com/site-url' }

    context 'without text' do
      let(:text) { "[url]#{url}[/url]" }

      context 'short url' do
        it { should eq "<a href=\"#{url}\">#{url.without_http}</a>" }
      end

      context 'long url' do
        let(:url) { 'http://site.com/' + ('x' * BbCodes::UrlTag::MAX_SHORT_URL_SIZE) }
        it { should eq "<a href=\"#{url}\">site.com</a>" }
      end

      context 'shikimori url' do
        let(:url) { 'http://shikimori.org/animes' }
        it { should eq "<a href=\"#{url}\">/animes</a>" }
      end

      context 'encoded url' do
        let(:url) { 'http://shikimori.org/%D0%92%D0%B8%D0%BD%D0%BD%D0%B8' }
        it { should eq "<a href=\"#{url}\">/Винни</a>" }
      end
    end

    context 'with text' do
      let(:text) { "[url=#{url}]text[/url]" }
      it { should eq "<a href=\"#{url}\">text</a>" }
    end

    context 'just link' do
      context 'common case' do
        let(:text) { url }
        it { should eq "<a href=\"#{url}\">#{url.without_http}</a>" }
      end

      context 'with format' do
        let(:text) { "#{url}.json" }
        it { should eq "<a href=\"#{url}.json\">#{url.without_http}.json</a>" }
      end

      context 'space format' do
        let(:text) { "#{url} test" }
        it { should eq "<a href=\"#{url}\">#{url.without_http}</a> test" }
      end

      context 'with dot' do
        let(:text) { "#{url}." }
        it { should eq "<a href=\"#{url}\">#{url.without_http}</a>." }
      end

      context 'with comma' do
        let(:text) { "#{url}, test" }
        it { should eq "<a href=\"#{url}\">#{url.without_http}</a>, test" }
      end

      context 'with bracket' do
        let(:text) { "#{url})" }
        it { should eq "<a href=\"#{url}\">#{url.without_http}</a>)" }
      end

      context 'in tag' do
        let(:text) { "[zz]#{url}[/zz]" }
        it { should eq "[zz]#{url}[/zz]" }
      end

      context 'russian link' do
        let(:text) { 'http://www.hentasis.com/tags/%D3%F7%E8%F2%E5%EB%FC%ED%E8%F6%FB/' }
        it { should eq '<a href="http://www.hentasis.com/tags/%D3%F7%E8%F2%E5%EB%FC%ED%E8%F6%FB/">www.hentasis.com</a>' }
      end
    end
  end
end
