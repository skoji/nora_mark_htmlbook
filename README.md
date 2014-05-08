# NoraMark_HTMLBook

[<img src="https://secure.travis-ci.org/skoji/nora_mark_htmlbook.png" />](http://travis-ci.org/skoji/nora_mark_htmlbook)
[<img src="https://coveralls.io/repos/skoji/nora_mark_htmlbook/badge.png" />](https://coveralls.io/r/skoji/nora_mark_htmlbook)
[![Dependency Status](https://gemnasium.com/skoji/nora_mark_htmlbook.svg)](https://gemnasium.com/skoji/nora_mark_htmlbook)


[HTMLBook](https://github.com/oreillymedia/HTMLBook) generator plugin for [NoraMark](https://github.com/skoji/noramark)

## Installation

Add this line to your application's Gemfile:

    gem 'nora_mark_htmlbook'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nora_mark_htmlbook

## Usage

### From command line

    $ nora2htmlbook < text.nora > result.html

### Explicitly load your code

```ruby
require 'nora_mark'
require 'nora_mark_htmlbook'

NoraMark::Extensions.register_generator(NoraMark::Htmlbook::Generator)
puts NoraMark::Document.parse(markup_text).htmlbook
```

### Specify in frontmatter in the markup text

```
---
title: document title
generator: htmlbook
---

# Chapter 1

Lorem ipsum dolor sit amet, consectetuer adipiscing elit.  

## Section 1

Donec hendrerit tempor tellus. Donec pretium posuere tellus. Proin quam nisl, tincidunt et, mattis eget, convallis nec, purus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla posuere. Donec vitae dolor. Nullam tristique diam non turpis. Cras placerat accumsan nulla. Nullam rutrum. Nam vestibulum accumsan nisl.

```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nora_mark_htmlbook/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
