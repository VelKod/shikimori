describe Dialog do
  let(:user) { build_stubbed :user }
  let(:target_user) { build_stubbed :user }
  let(:message) { build_stubbed :message, from: user, to: target_user, read: false }
  subject(:dialog) { Dialog.new user, message }

  describe '#target_user' do
    context 'message from user' do
      its(:target_user) { should eq target_user }
    end

    context 'message to user' do
      let(:message) { build_stubbed :message, to: user, from: target_user }
      its(:target_user) { should eq target_user }
    end
  end

  describe '#created_at' do
    its(:created_at) { should eq message.created_at }
  end

  describe '#read' do
    context 'message from user' do
      its(:read) { should be_truthy }
    end

    context 'message to user' do
      let(:message) { build_stubbed :message, to: user, from: target_user, read: false }
      its(:read) { should be_falsy }
    end
  end

  describe '#my_message?' do
    context 'message from user' do
      its(:my_message?) { should be_truthy }
    end

    context 'message to user' do
      let(:message) { build_stubbed :message, to: user, from: target_user }
      its(:my_message?) { should be_falsy }
    end
  end

  describe '#messages' do
    let!(:message_to) { create :message, from: target_user, to: user }
    let!(:message_from) { create :message, from: user, to: target_user }
    its(:messages) { should eq [message_to, message_from] }
  end

  describe '#destroy' do
    let(:user) { create :user }
    let(:target_user) { create :user }
    let!(:message_to) { create :message, from: target_user, to: user }
    let!(:message_from) { create :message, from: user, to: target_user }

    before { dialog.destroy }

    it { expect(message_from.reload.src_del).to be_truthy }
    it { expect(message_to.reload.dst_del).to be_truthy }
  end
end
