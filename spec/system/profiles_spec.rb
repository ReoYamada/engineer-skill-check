require 'rails_helper'

RSpec.describe 'Profiles', type: :system do
  let(:office) { create(:office) }
  let(:department) { create(:department) }
  let!(:employee) { create(:employee, office_id: office.id, department_id: department.id) }

  before do
    driven_by(:rack_test)
    visit login_path
    fill_in 'employees_account', with: employee.account
    fill_in 'employees_password', with: employee.password
    click_on 'ログイン'
  end
  
  describe 'プロフィールページテスト' do
    before do
      click_on employee.number
    end

    it '社員番号をクリックしたとき、プロフィールページにアクセスすること' do
      expect(current_path).to eq employee_profiles_path(employee.id)
    end

    it 'プロフィールページに社員番号が表示されていること' do
      expect(page).to have_content employee.number
    end

    it 'プロフィールページに氏名が表示されていること' do
      expect(page).to have_content employee.first_name
      expect(page).to have_content employee.last_name
    end

    it 'プロフィールページに部署が表示されていること' do
      expect(page).to have_content department.name
    end
  end

  describe 'プロフィール投稿テスト' do
    before do
      visit employee_profiles_path(employee.id)
      click_on 'プロフィールを作成'
    end

    context 'プロフィール内容が正常' do
      it '投稿が成功し社員一覧ページにアクセスすること' do
        expect{
          fill_in 'profile_profile', with: 'hogehoge'
          click_on '保存'
          expect(current_path).to eq employees_path
          expect(page).to have_content 'プロフィールを登録しました'
        }.to change(Profile, :count).by(1)
      end
    end

    context 'プロフィール内容が未入力' do
      it '投稿が失敗し未入力エラーメッセージが表示されること' do
        expect{
          fill_in 'profile_profile', with: ''
          click_on '保存'
          expect(page).to have_content 'プロフィール を入力してください'
        }.to change(Profile, :count).by(0)
      end
    end

    context 'プロフィール内容が300文字を超える' do
      it '投稿が失敗し文字数エラーメッセージが表示されること' do
        expect{
          fill_in 'profile_profile', with: 'a' * 301
          click_on '保存'
          expect(page).to have_content 'プロフィール は300文字以内で入力してください'
        }.to change(Profile, :count).by(0)
      end
    end
  end
end
