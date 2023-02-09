require 'rails_helper'

RSpec.describe Employee, type: :model do
  let!(:existence_employee) do
    create(:employee, number: 'existence', account: 'existence', office_id: office.id, department_id: department.id)
  end
  let(:employee) { build(:employee, office_id: office.id, department_id: department.id) }
  let(:department) { create(:department) }
  let(:office) { create(:office) }

  it '入力内容が全て存在すれば有効であること' do
    expect(employee.valid?).to eq true
  end

  it '社員番号が無ければ無効であること' do
    employee.number = ''
    expect(employee.valid?).to eq false
  end

  it '社員番号が既に登録済みであれば無効であること' do
    employee.number = 'existence'
    expect(employee.valid?).to eq false
  end

  it '姓が無ければ無効であること' do
    employee.last_name = ''
    expect(employee.valid?).to eq false
  end

  it '名が無ければ無効であること' do
    employee.first_name = ''
    expect(employee.valid?).to eq false
  end

  it 'アカウントが無ければ無効であること' do
    employee.account = ''
    expect(employee.valid?).to eq false
  end

  it 'アカウントが既に登録済みであれば無効であること' do
    employee.account = 'existence'
    expect(employee.valid?).to eq false
  end

  it 'パスワードが無ければ無効であること' do
    employee.password = ''
    expect(employee.valid?).to eq false
  end

  it 'メールアドレスが無ければ無効であること' do
    employee.email = ''
    expect(employee.valid?).to eq false
  end

  it '入社年月日が無ければ無効であること' do
    employee.date_of_joining = ''
    expect(employee.valid?).to eq false
  end

  it '部署が無ければ無効であること' do
    employee.department_id = ''
    expect(employee.valid?).to eq false
  end

  it 'オフィスが無ければ無効であること' do
    employee.office_id = ''
    expect(employee.valid?).to eq false
  end
end
