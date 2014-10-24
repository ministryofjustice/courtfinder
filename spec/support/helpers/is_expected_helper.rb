module IsExpectedHelper
  # backport from RSpec 3
  def is_expected
    expect(subject)
  end
end
