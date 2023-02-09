module LoginSupport
  def login_as(employee)
    visit login_path
    fill_in 'employees_account', with: employee.account
    fill_in 'employees_password', with: employee.password
    click_on 'ログイン'
  end
end
