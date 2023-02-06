require 'rails_helper'

RSpec.describe 'Employees', type: :system do
  let(:office) { create(:office) }
  let(:department) { create(:department) }
  let!(:employee) { create(:employee, office_id: office.id, department_id: department.id) }
  let!(:existence_employee) { create(:employee, number: 'existence', account: 'existence', office_id: office.id, department_id: department.id) }

  before do
    driven_by(:rack_test)
    visit login_path
    fill_in 'employees_account', with: employee.account
    fill_in 'employees_password', with: employee.password
    click_on 'ログイン'
  end

  describe '社員一覧ページテスト' do
    before do
      click_on '社員紹介'
    end

    it '社員紹介をクリックしたとき社員一覧ページにアクセスすること' do
      expect(current_path).to eq employees_path
    end

    it 'ページに社員番号が表示されること' do
      expect(page).to have_content employee.number
    end

    it 'ページに氏名が表示されること' do
      expect(page).to have_content employee.first_name
      expect(page).to have_content employee.last_name
    end

    it 'ページに部署が表示されること' do
      expect(page).to have_content department.name
    end
  end

  describe '社員情報新規登録テスト' do
    before do
      click_on '新規追加'
    end

    it '新規追加をクリックしたとき社員情報登録画面にアクセスすること' do
      expect(current_path).to eq new_employee_path
    end

    describe '入力内容テスト' do
      before do
        fill_in 'employee_number', with: 'new_number'
        fill_in 'employee_first_name', with: 'new_first_name'
        fill_in 'employee_last_name', with: 'new_last_name'
        fill_in 'employee_account', with: 'new_account'
        fill_in 'employee_password', with: 'new_password'
        fill_in 'employee_email', with: 'new_email@example.com'
        fill_in 'employee_date_of_joining', with: '2023-01-01'
        select '総務', from: 'employee_department_id'
        select '東京', from: 'employee_office_id'
      end

      context '入力内容が正常' do
        it '登録が成功し一覧ページに表示されること' do
          expect{
            click_on '保存'
            expect(current_path).to eq employees_path
            expect(page).to have_content 'new_number'
            expect(page).to have_content 'new_first_name'
            expect(page).to have_content 'new_last_name'
          }.to change(Employee, :count).by(1)
        end
      end
      
      context '社員番号が未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          expect{
            fill_in 'employee_number', with: ''
            click_on '保存'
            expect(page).to have_content '社員番号 を入力してください'
          }.to change(Employee, :count).by(0)
        end
      end

      context '社員番号が既に登録されている' do
        it '登録が失敗しエラーメッセージが表示される' do
          expect{
            fill_in 'employee_number', with: 'existence'
            click_on '保存'
            expect(page).to have_content '社員番号 はすでに存在します'
          }.to change(Employee, :count).by(0)
        end
      end

      context '氏名（姓）が未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          expect{
            fill_in 'employee_last_name', with: ''
            click_on '保存'
            expect(page).to have_content '氏名（姓） を入力してください'
          }.to change(Employee, :count).by(0)
        end
      end

      context '氏名（名）が未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          expect{
            fill_in 'employee_first_name', with: ''
            click_on '保存'
            expect(page).to have_content '氏名（名） を入力してください'
          }.to change(Employee, :count).by(0)
        end
      end

      context 'アカウントが未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          expect{
            fill_in 'employee_account', with: ''
            click_on '保存'
            expect(page).to have_content 'アカウント を入力してください'
          }.to change(Employee, :count).by(0)
        end
      end

      context 'アカウントが既に登録されている' do
        it '登録が失敗しエラーメッセージが表示される' do
          expect{
            fill_in 'employee_account', with: 'existence'
            click_on '保存'
            expect(page).to have_content 'アカウント はすでに存在します'
          }.to change(Employee, :count).by(0)
        end
      end

      context 'メールアドレスが未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          expect{
            fill_in 'employee_email', with: ''
            click_on '保存'
            expect(page).to have_content 'メールアドレス を入力してください'
          }.to change(Employee, :count).by(0)
        end
      end

      context '入社年月日が未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          expect{
            fill_in 'employee_date_of_joining', with: ''
            click_on '保存'
            expect(page).to have_content '入社年月日 を入力してください'
          }.to change(Employee, :count).by(0)
        end
      end
    end
  end

  describe '社員情報編集テスト' do
    before do
      click_on '編集', match: :first 
    end

    it '編集をクリックしたとき社員情報編集画面にアクセスすること' do
      expect(current_path).to eq edit_employee_path(employee)
    end

    it '編集前情報が入力されていること' do
      expect(page).to have_field 'employee_number', with: employee.number
      expect(page).to have_field 'employee_first_name', with: employee.first_name
      expect(page).to have_field 'employee_last_name', with: employee.last_name
      expect(page).to have_field 'employee_email', with: employee.email
      expect(page).to have_field 'employee_date_of_joining', with: employee.date_of_joining.to_s
      expect(page).to have_content department.name
      expect(page).to have_content office.name
    end

    describe '入力内容テスト' do
      before do
        fill_in 'employee_number', with: 'edit_number'
        fill_in 'employee_first_name', with: 'edit_first_name'
        fill_in 'employee_last_name', with: 'edit_last_name'
        fill_in 'employee_account', with: 'edit_account'
        fill_in 'employee_password', with: 'edit_password'
        fill_in 'employee_email', with: 'edit_email@example.com'
        fill_in 'employee_date_of_joining', with: '2023-01-01'
        select '総務', from: 'employee_department_id'
        select '東京', from: 'employee_office_id'
      end

      context '入力内容が正常' do
        it '登録が成功し一覧ページに表示されること' do
          click_on '保存'
          expect(current_path).to eq employees_path
          expect(page).to have_content 'edit_number'
          expect(page).to have_content 'edit_first_name'
          expect(page).to have_content 'edit_last_name'
        end
      end
      
      context '社員番号が未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          fill_in 'employee_number', with: ''
          click_on '保存'
          expect(page).to have_content '社員番号 を入力してください'
        end
      end

      context '社員番号が既に登録されている' do
        it '登録が失敗しエラーメッセージが表示される' do
          fill_in 'employee_number', with: 'existence'
          click_on '保存'
          expect(page).to have_content '社員番号 はすでに存在します'
        end
      end

      context '氏名（姓）が未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          fill_in 'employee_last_name', with: ''
          click_on '保存'
          expect(page).to have_content '氏名（姓） を入力してください'
        end
      end

      context '氏名（名）が未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          fill_in 'employee_first_name', with: ''
          click_on '保存'
          expect(page).to have_content '氏名（名） を入力してください'
        end
      end

      context 'アカウントが未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          fill_in 'employee_account', with: ''
          click_on '保存'
          expect(page).to have_content 'アカウント を入力してください'
        end
      end

      context 'アカウントが既に登録されている' do
        it '登録が失敗しエラーメッセージが表示される' do
          fill_in 'employee_account', with: 'existence'
          click_on '保存'
          expect(page).to have_content 'アカウント はすでに存在します'
        end
      end

      context 'メールアドレスが未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          fill_in 'employee_email', with: ''
          click_on '保存'
          expect(page).to have_content 'メールアドレス を入力してください'
        end
      end

      context '入社年月日が未入力' do
        it '登録が失敗し未入力エラーメッセージが表示されること' do
          fill_in 'employee_date_of_joining', with: ''
          click_on '保存'
          expect(page).to have_content '入社年月日 を入力してください'
        end
      end
    end
  end

  describe '社員情報削除テスト' do
    it '削除をクリックすると、社員情報が非表示になること' do
      expect{
        click_on '削除', match: :first
        expect(page).to have_content '社員「hege」を削除しました。'
      }.to change(Article, :count).by(0)
    end
  end
end
