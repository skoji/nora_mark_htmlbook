# -*- encoding: utf-8 -*-
require 'nora_mark'
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/nora_mark_htmlbook.rb'
require 'nokogiri'
require File.dirname(__FILE__) + '/nokogiri_test_helper.rb'

describe 'html_book plugin' do
  before do
    NoraMark::Extensions.register_generator(NoraMark::Htmlbook::Generator)
  end
  
  it 'generate body with data-book' do
    text = "---\ntitle: the title.\n---\ndocument."
    parsed = NoraMark::Document.parse(text, lang: 'ja')
    xhtml = parsed.htmlbook
    body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')
    expect(body.selector_and_children)
      .to eq(
             ["body[data-type='book']",
              ['h1', 'the title.'],
              ['div.pgroup',
               ['p', 'document.']]]
             )
  end
  it 'generate chapter  ' do
    text = "---\ntitle: the title.\n---\n# chapter title\ndocument."
    parsed = NoraMark::Document.parse(text, lang: 'ja')
    xhtml = parsed.htmlbook
    body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')    
    expect(body.selector_and_children)
      .to eq(
             ["body[data-type='book']",
              ['h1', 'the title.'],
              ["section[data-type='chapter']",
               ['h1', 'chapter title'],
               ['div.pgroup',
                ['p', 'document.']]]]
             )
  end
  it 'generate chapter and section' do
    text = "---\ntitle: the title.\n---\n# chapter title\n## section title\ndocument."
    parsed = NoraMark::Document.parse(text, lang: 'ja')
    xhtml = parsed.htmlbook
    body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')    
    expect(body.selector_and_children)
      .to eq(
             ["body[data-type='book']",
              ['h1', 'the title.'],
              ["section[data-type='chapter']",
               ['h1', 'chapter title'],
               ["section[data-type='sect1']",
                ['h1', 'section title'],
                ['div.pgroup',
                 ['p', 'document.']]]]]
             )
  end
  it 'generate appendix and section' do
    text = "---\ntitle: the title.\n---\n#(appendix) appendix title\n## section title\ndocument."
    parsed = NoraMark::Document.parse(text, lang: 'ja')
    xhtml = parsed.htmlbook
    body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')    
    expect(body.selector_and_children)
      .to eq(
             ["body[data-type='book']",
              ['h1', 'the title.'],
              ["section[data-type='appendix']",
               ['h1', 'appendix title'],
               ["section[data-type='sect1']",
                ['h1', 'section title'],
                ['div.pgroup',
                 ['p', 'document.']]]]]
             )
  end

  it 'generate sidebar' do
    text = <<EOF
---
title: the title.
---
sidebar(Amusing Digression) {
Did you know that in Boston, they call it "soda", and in Chicago, they call it "pop"?
}
EOF
    parsed = NoraMark::Document.parse(text)
    xhtml = parsed.htmlbook
    body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')
    expect(body.selector_and_children)
      .to eq(
             ["body[data-type='book']",
              ['h1', 'the title.'],
              ["aside[data-type='sidebar']",
               ['h5', 'Amusing Digression'],
               ['p', 'Did you know that in Boston, they call it "soda", and in Chicago, they call it "pop"?']]]
             )
  end

end
