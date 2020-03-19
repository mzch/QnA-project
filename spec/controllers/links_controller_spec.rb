require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create :question, :with_links, user: user }

  describe 'DELETE #destroy' do
    context 'As an author' do
      before { login(user) }

      it 'delete the link' do
        expect { delete :destroy, params: { id: question.links.first.id, format: :js } }.to change(question.links, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: question.links.first.id, format: :js }
        expect(response).to render_template :destroy
        expect(response).to have_http_status :ok
      end
    end

    context 'As not an author' do
      before { login(user1) }

      it 'does not delete the link' do
        expect { delete :destroy, params: { id: question.links.first.id, format: :js } }.not_to change(question.links, :count)
      end

      it 'get flash alert message' do
        delete :destroy, params: { id: question.links.first.id, format: :js }
        expect(flash[:alert]).to eq 'Not enough permission: for delete'
      end

      it 'render destroy view' do
        delete :destroy, params: { id: question.links.first.id, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'As guest' do

      it 'does not delete the link' do
        expect { delete :destroy, params: { id: question.links.first.id, format: :js } }.not_to change(question.links, :count)
      end

      it 'responds with 401' do
        delete :destroy, params: { id: question.links.first.id, format: :js }
        expect(response).to have_http_status :unauthorized
      end

      it 'redirected to sign in page' do
        delete :destroy, params: { id: question.links.first.id }

        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end


