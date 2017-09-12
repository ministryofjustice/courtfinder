module Features
  module SessionHelpers

    def sign_in(user = nil, password = nil)
      expect(page).to have_content('Sign in')

      password ||= password || 'password123'
      user ||= create(:user, password: password)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: password
      click_button 'Sign in'
    end

    def sign_out
      if example.metadata[:js]
        Capybara.reset_sessions!
      else
        visit '/admin'
        click_link 'Sign out'
        expect(page).to have_content('Signed out successfully')
      end
    end

  end
end
