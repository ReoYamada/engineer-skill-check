require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
  let(:employee) { create(:employee, office_id: offise.id, department_id: department.id) }
  let(:department) { create(:department) }
  let(:offise) { create(:office) }
  let(:params) { { profile: attributes_for(:profile, employee_id: employee.id) } }

  before do
    session_params =  { employees: { account: employee.account, password: employee.password } }
    post "/login", params: session_params
  end

  describe '社員プロフィール参照ページ' do
    before do
      get employee_profiles_path(employee)
    end

    it '正常なレスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
    
    it '社員番号を取得できること' do
      expect(response.body).to include employee.number
    end

    it '氏名を取得できること' do
      expect(response.body).to include employee.first_name
      expect(response.body).to include employee.last_name
    end

    it '部署が取得できること' do
      expect(response.body).to include department.name
    end
  end

  describe '社員プロフィール登録' do
    it '正常なレスポンスを返すこと' do
      expect{
        post employee_profiles_path(employee), params: params
      }.to change(Profile, :count).by(1)
      expect(response).to redirect_to employees_path
    end
  end
end

