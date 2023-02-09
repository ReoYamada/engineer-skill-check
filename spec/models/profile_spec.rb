require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile) { build(:profile, employee_id: employee.id) }
  let(:employee) { create(:employee, office_id: office.id, department_id: department.id) }
  let(:department) { create(:department) }
  let(:office) { create(:office) }

  it 'プロフィールが1文字以上300文字以内であれば有効であること' do
    profile.profile = 'a' * 1
    expect(profile.valid?).to eq true
    profile.profile = 'a' * 300
    expect(profile.valid?).to eq true
  end

  it 'プロフィールが無ければ無効であること' do
    profile.profile = ''
    expect(profile.valid?).to eq false
  end

  it 'プロフィールが300文字を超えると無効であること' do
    profile.profile = 'a' * 301
    expect(profile.valid?).to eq false
  end
end
