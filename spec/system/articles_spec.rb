require 'rails_helper'

RSpec.describe 'Articles', type: :system do
  let!(:article) { create(:article, author: employee.id ) }
  let(:office) { create(:office) }
  let(:department) { create(:department) }
  let!(:employee) { create(:employee, office_id: office.id, department_id: department.id) }

  before do
    driven_by(:rack_test)
    login_as(employee)
  end

  describe 'お知らせ一覧ページテスト' do
    before do
      click_on 'お知らせ'
    end

    it 'お知らせをクリックしたときお知らせ一覧ページにアクセスすること' do
      expect(current_path).to eq articles_path
    end

    it 'ページにお知らせタイトルが表示されていること' do
      expect(page).to have_content article.title
    end

    it 'ページにお知らせ投稿日が表示されていること' do
      expect(page).to have_content article.created_at.to_s(:datetime_jp)
    end
  end

  describe 'お知らせ投稿テスト' do
    before do
      visit articles_path
      click_on '新規投稿'
    end

    it '新規投稿をクリックしたとき投稿画面にアクセスすること' do
      expect(current_path).to eq new_article_path
    end

    describe '投稿内容テスト' do
      context '投稿内容が正常' do
        it '投稿が成功し一覧ページに表示されること' do
          expect{
            fill_in 'タイトル', with: 'title'
            click_on '投稿'
            expect(current_path).to eq articles_path
            expect(page).to have_content 'お知らせ「title」を登録しました'
            expect(page).to have_content 'title'
          }.to change(Article, :count).by(1)
        end
      end

      context 'タイトルが未入力' do
        it '投稿が失敗し未入力エラーメッセージが表示されること' do
          expect{
            fill_in 'タイトル', with: ''
            click_on '投稿'
            expect(page).to have_content 'タイトル を入力してください'
          }.to change(Article, :count).by(0)
        end
      end

      context 'タイトルが50文字を超える' do
        it '投稿が失敗し文字数エラーメッセージが表示されること' do
          expect{
            fill_in 'タイトル', with: 'a' * 51
            click_on '投稿'
            expect(page).to have_content 'タイトル は50文字以内で入力してください'
          }.to change(Article, :count).by(0)
        end
      end
    end
  end

  describe 'お知らせ編集テスト' do
    before do
      visit articles_path
      click_on '編集'
    end

    it '編集をクリックしたときお知らせ編集画面にアクセスすること' do
      expect(current_path).to eq edit_article_path(article)
    end

    describe '投稿内容テスト' do
      context '投稿内容が正常' do
        it '投稿が成功し一覧ページに表示されること' do
          fill_in 'タイトル', with: 'title'
          click_on '投稿'
          expect(current_path).to eq articles_path
          expect(page).to have_content 'お知らせ「title」を更新しました'
          expect(page).to have_content 'title'
        end
      end

      context 'タイトルが未入力' do
        it '投稿が失敗し未入力エラーメッセージが表示されること' do
          fill_in 'タイトル', with: ''
          click_on '投稿'
          expect(page).to have_content 'タイトル を入力してください'
        end
      end

      context 'タイトルが50文字を超える' do
        it '投稿が失敗し文字数エラーメッセージが表示されること' do
          fill_in 'タイトル', with: 'a' * 51
          click_on '投稿'
          expect(page).to have_content 'タイトル は50文字以内で入力してください'
        end
      end
    end
  end

  describe 'お知らせ削除テスト' do
    before do
      visit articles_path
    end

    it '削除ボタンをクリックすると、投稿内容が削除されること' do
      expect{
        click_on '削除'
        expect(page).to have_content 'お知らせ「hege」を削除しました。'
      }.to change(Article, :count).by(-1)
    end
  end
end
