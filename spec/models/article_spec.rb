require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article) { build(:article, author:employee) }
  let(:employee) { create(:employee, office_id: office.id, department_id: department.id) }
  let(:department) { create(:department) }
  let(:office) { create(:office) }

  it 'タイトルが存在し50文字以内であれば有効であること' do
    article.title = 'a' * 50
    expect(article.valid?).to eq true
  end

  it 'タイトルが無ければ無効であること' do
    article.title = ''
    expect(article.valid?).to eq false
  end

  it 'タイトルが50文字を超えると無効であること' do
    article.title = 'a' * 51
    expect(article.valid?).to eq false
  end
end
