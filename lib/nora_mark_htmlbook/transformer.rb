module NoraMark
  module Htmlbook
    def self.transformer
      TransformerFactory.create do
        modify type: :Root do
          first_page = @node.first_child
          first_page.add_attr 'data-type' => [ 'book' ]
          title = @frontmatter.nil? ? nil : @frontmatter['title']
          first_page.prepend_child(
                                   block('h1', title)
                                   ) unless title.nil?
          
        end
        modify 'part' do
          @node.name = 'div'
          @node.add_attr 'data-type' => ['part']
        end
        
        modify type: :HeadedSection do
          if @node.level == 1
            node_type = @node.p[0] || "chapter"
            node_type = node_type.text unless node_type.is_a? String
            if (['chapter',
                 'appendix',
                 'afterword',
                 'bibliography',
                 'glossary',
                 'preface',
                 'foreword',
                 'introduction',
                 'halftitlepage',
                 "titlepage",
                 "copyright-page",
                 "dedication",
                 "colophon",
                 "acknowledgments",
                 "afterword",
                 "conclusion",
                 "index",
                ].member? node_type)
              @node.add_attr 'data-type' => [ node_type ]
            end
          else
            @node.level = @node.level - 1
            @node.add_attr 'data-type' => [ "sect#{@node.level}" ]     
          end
        end
        modify "sidebar" do
          @node.name = "aside"
          @node.add_attr "data-type" => ["sidebar"]
          if !@node.p[0].nil?
            @node.prepend_child block('h5', @node.p[0].text)
          end
        end
        
      end
    end
  end
end
