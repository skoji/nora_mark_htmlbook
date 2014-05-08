# -*- encoding: utf-8 -*-
require 'nora_mark'
require File.dirname(__FILE__) + '/spec_helper.rb'
require 'nokogiri'
require File.dirname(__FILE__) + '/nokogiri_test_helper.rb'

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

describe 'html_book plugin' do
  describe 'explicitly load extension' do
    before(:all) do
      NoraMark::Extensions.register_generator(:htmlbook)
    end
    describe 'book component elements' do
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
      it 'generate part' do
        text = "part {\n# Chapter 1\n## Section 1\ndocument\n}"
        parsed = NoraMark::Document.parse(text, lang: 'ja')
        xhtml = parsed.htmlbook
        body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')    
        expect(body.selector_and_children)
          .to eq(
                 ["body[data-type='book']",
                  ["div[data-type='part']", 
                   ["section[data-type='chapter']",
                    ['h1', 'Chapter 1'],
                   ["section[data-type='sect1']",
                    ['h1', 'Section 1'],
                    ['div.pgroup',
                     ['p', 'document']]]]]]
                 )
        
      end
    end
    describe 'block elements' do
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
      it 'generate admotions' do
        text = <<EOF
note(Helpful Info) {
Please take note of this important information
}
warning {
Make sure to get your AsciiDoc markup right!
}
EOF
        parsed = NoraMark::Document.parse(text)
        xhtml = parsed.htmlbook
        body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')
        expect(body.selector_and_children)
          .to eq(
                 ["body[data-type='book']",
                  ["div[data-type='note']",
                   ['h1', 'Helpful Info'],
                   ['p', 'Please take note of this important information']],
                  ["div[data-type='warning']",
                   ['p', 'Make sure to get your AsciiDoc markup right!']]]
                 )
      end
      it 'generate example' do
        text = <<EOF
example(Hello World in Ruby) {
  puts 'Hello, World'
}

EOF
        parsed = NoraMark::Document.parse(text)
        xhtml = parsed.htmlbook
        body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')
        expect(body.selector_and_children)
          .to eq(
                 ["body[data-type='book']",
                  ["div[data-type='example']",
                   ['h1', 'Hello World in Ruby'],
                   ['p', 'puts \'Hello, World\'']]]
                 )
      end
      it 'generate code listing' do
        text = <<EOF
example(Hello World in Ruby) {
code {//ruby
puts 'Hello, World'
//}
}

EOF
        parsed = NoraMark::Document.parse(text)
        xhtml = parsed.htmlbook
        body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')
        expect(body.selector_and_children)
          .to eq(
                 ["body[data-type='book']",
                  ["div[data-type='example']",
                   ['h1', 'Hello World in Ruby'],
                   ["pre.code-ruby[data-type='programlisting'][data-code-language='ruby']",
                    "puts 'Hello, World'"]]]
                 )
      end
    end
    describe 'inline element' do
      it 'generate footnote' do
        text = <<EOF
Five out of every six people who try AsciiDoc prefer it to Markdown [footnote{Totally made-up statistic}]
EOF
        parsed = NoraMark::Document.parse(text)
        xhtml = parsed.htmlbook
        body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')
        expect(body.selector_and_children)
          .to eq(
                 ["body[data-type='book']",
                  ["p", 'Five out of every six people who try AsciiDoc prefer it to Markdown ', ["span[data-type='footnote']", "Totally made-up statistic"]]]
                 )
      end
    end
  end
  describe 'declare generator in the frontmatter' do
    before(:each) do
      NoraMark::Extensions.unregister_generator(:htmlbook)
    end
    it 'generate body with data-book' do
      text = "---\ntitle: the title.\ngenerator: htmlbook\n---\ndocument."
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

  end
end
