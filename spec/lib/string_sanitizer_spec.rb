require 'spec_helper'

describe StringSanitizer do

  describe '#sanitize' do

    it 'should sanitize html' do
      expect(StringSanitizer.new('<p>This <b>link</b> <a href="my_url">here</a><hr />.').sanitize).to eq ' This link here  .'
    end

    it 'should sanitize carriage return new lines' do
      expect(StringSanitizer.new("this\r\nshould all be\r\non one line").sanitize).to eq "this should all be on one line"
    end

    it 'should sanitize new lines' do
      expect(StringSanitizer.new("this\nshould all be\non one line").sanitize).to eq "this should all be on one line"
    end

    it 'should sanitize html escape characters' do
      orig = "-&amp;-&euro;-&nbsp;-&#122;-&#32;"
      expect(StringSanitizer.new(orig).sanitize).to eq '- - - - - '
    end

    it 'should sanitze a string containing all types' do
      orig = "<p>This \r\n<b>link</b> <a href=\"my_url\">here: &euro;&amp;&pound;</a><hr />"
      expect(StringSanitizer.new(orig).sanitize).to eq ' This  link here:      '
    end
  end
end