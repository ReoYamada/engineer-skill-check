require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  let!(:article){ create(:article, author: employee.id ) }
  let(:office){ create(:office) }
  let(:department){ create(:department) }
  let!(:employee){ create(:employee, office_id: office.id, department_id: department.id) }
  let(:params) { { article: attributes_for(:article) } }

  before do
    session_params =  { employees: { account: employee.account, password: employee.password } }
    post "/login", params: session_params
  end

  describe 'お知らせ一覧ページ' do
    before do
      get articles_path
    end

    it '正常なレスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end

    it 'お知らせタイトルが取得できること' do
      expect(response.body).to include article.title
    end

    it 'お知らせ投稿日が取得できること' do
      expect(response.body).to include article.created_at.to_s(:datetime_jp)
    end
  end

  describe 'お知らせ登録ページ' do
    it '正常なレスポンスを返すこと' do
      get new_article_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'お知らせ登録' do
    it '正常なレスポンスを返すこと' do
      expect{
        post articles_path, params: params
      }.to change(Article, :count).by(1)
      expect(response).to redirect_to articles_path
    end
  end

  describe 'お知らせ編集ページ' do
    before do
      get edit_article_path(article)
    end

    it '正常なレスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end

    it '編集前お知らせタイトルが取得できること' do
      expect(response.body).to include article.title
    end

    it '編集前お知らせ内容が取得できること' do
      expect(response.body).to include article.content
    end
  end

  describe 'お知らせ編集' do
    it '正常なレスポンスを返すこと' do
      put article_path(article), params: params
      expect(response).to redirect_to articles_path
    end
  end

  describe 'お知らせ削除' do
    it '正常なレスポンスを返すこと' do
      expect{
        delete article_path(article)
      }.to change(Article, :count).by(-1)
      expect(response).to redirect_to articles_path
    end
  end
end
