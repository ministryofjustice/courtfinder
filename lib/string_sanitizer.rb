class StringSanitizer


  def initialize(string)
    @string = string
  end

  def sanitize
    sanitize_html_escapes
    sanitize_html
    
    @string
  end


  private

  def sanitize_html
    @string = Sanitize.fragment(@string)
  end


  def sanitize_html_escapes
    @string.gsub!("\r\n", ' ')
    @string.gsub!("\n", ' ')
    @string.gsub!(/&.{2,6};/, ' ')
  end
end