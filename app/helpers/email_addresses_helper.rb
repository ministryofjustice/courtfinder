module EmailAddressesHelper
  def format_email_address(addr)
    ("<a href='mailto:#{addr}' property='email'>#{addr}</a>").html_safe
  end
end
