require "spec_helper"

describe NotificationsMailer do
  it "composes mail that contains user-submitted feedback form values" do
    form_params = {
        :feedback => {
            "rating" => 5,
            "text" => "what a beautiful site"
            },
        "browser" => "Chrome",
        "service" => "Court finder",
        "referrer" => "some-page-on-the-site"
    }
    email = NotificationsMailer.new_message(form_params)
    email.body.raw_source.should include(form_params[:feedback]["text"])
  end
end
