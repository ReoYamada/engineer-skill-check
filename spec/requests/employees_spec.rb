require 'rails_helper'

RSpec.describe 'Employees', type: :request do
  let(:employee) { create(:employee, office_id: office.id, department_id: department.id) }
  let!(:quited_employee) { create(:employee, office_id: office.id, department_id: department.id) }
  let(:department) { create(:department) }
  let(:office) { create(:office) }
  let(:params) { { employee: attributes_for(:employee, office_id: office.id, department_id: department.id) } }

  before do
    session_params =  { employees: { account: employee.account, password: employee.password } }
    post "/login", params: session_params
  end

  describe '社員紹介ページ' do
    before do
      get employees_path
    end

    it '正常なレスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end

    it '社員番号が取得できること' do
      expect(response.body).to include employee.number
    end

    it '氏名が取得できること' do
      expect(response.body).to include employee.first_name
      expect(response.body).to include employee.last_name
    end

    it '部署が取得できること' do
      expect(response.body).to include department.name
    end
  end

  describe '社員情報登録ページ' do
    it '正常なレスポンスを返すこと' do
      get new_employee_path
      expect(response).to have_http_status(200)
    end
  end

  describe '社員情報登録' do
    it '正常なレスポンスを返すこと' do
      expect{
        post employees_path, params: params
      }.to change(Employee, :count).by(1)
      expect(response).to redirect_to employees_path
    end
  end

  describe '社員情報編集ページ' do
    before do
      get edit_employee_path(employee)
    end

    it '正常なレスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end

    it '編集前社員番号が取得できること' do
      expect(response.body).to include employee.number
    end

    it '編集前氏名が取得できること' do
      expect(response.body).to include employee.first_name
      expect(response.body).to include employee.last_name
    end

    it '編集前アカウントが取得できること' do
      expect(response.body).to include employee.account
    end

    it '編集前メールアドレスが取得できること' do
      expect(response.body).to include employee.email
    end

    it '編集前入社年月日が取得できること' do
      expect(response.body).to include employee.date_of_joining.to_s
    end
  end

  describe '社員情報編集' do
    it '正常なレスポンスを返すこと' do
      put employee_path(employee), params: params
      expect(response).to redirect_to employees_path
    end
  end

  describe '社員情報削除' do
    it '正常なレスポンスを返すこと' do
      delete employee_path(quited_employee)
      expect(response).to redirect_to employee_path
    end
  end
end
