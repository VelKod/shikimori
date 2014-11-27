describe DialogsController do
  describe '#index' do
    include_context :authenticated, :user
    let!(:message) { create :message, from: user, to: create(:user) }
    before { get :index, profile_id: user.to_param }

    it { should respond_with :success }
  end

  describe '#show' do
    include_context :authenticated, :user
    let(:target_user) { create :user }
    let!(:message_1) { create :message, from: user, to: target_user }
    let!(:message_2) { create :message, from: target_user, to: user }

    before { get :show, profile_id: user.to_param, id: target_user.to_param(true) }

    it { should respond_with :success }
  end

  describe '#destroy' do
    include_context :authenticated, :user
    let(:target_user) { create :user }
    let!(:message_1) { create :message, from: user, to: target_user }
    let!(:message_2) { create :message, from: target_user, to: user }

    before { delete :destroy, profile_id: user.to_param, id: message_1 }

    it { should respond_with :success }
    it { expect(response.content_type).to eq 'application/json' }
  end
end
