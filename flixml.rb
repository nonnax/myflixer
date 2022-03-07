#!/usr/bin/env ruby
# Id$ nonnax 2022-02-27 15:41:22 +0800
require 'rubytools/cubadoo'

NAVLINKS=%w[movie tv].zip(%w[movies tv-shows]).to_h

class << self
  attr_accessor :active
end

def link_img_banner_ 
  tagz do 
    p_{ a_( href: "/" ){img_ src: "/images/banner.jpg", style:"width:100%"} }
  end
end

def nav_links_
  tagz do
    p_{ a_( href: "/" ){img_ src: "/images/banner.jpg", style:"width:100%"} }
    div_(class: 'navbar') {
      NAVLINKS.each do |k, v|
        div_{
          link_opts={href: "/#{k}"}
          @active ||= ARGV.pop
          link_opts.merge!(class: 'active') if k.match?(/#{@active}/)
          a_( **link_opts ){ v }
        }
      end
    }
  end
end

def layout(&block)
  tagz do
    html_ do
      head_ {
        title_ 'tv ni mang tomas'
        link_(rel: 'stylesheet', type: "text/css",  href: '/css/style.css')
      }
      body_ {
        div_(id: 'header') { 
          nav_links_
        }
        div_(id: 'content', &block)
        div_(class: 'footer'){ link_img_banner_ }
      }
    end
  end
end

doc=
layout do
  tagz do
    ARGF.each_line(chomp: true) do |l|
      unless l.match?(/\t/)
        # File.write('active.txt', l)
        next
      end
      div_(class: 'item') do
        l.split(/\t/) => [img, title, href]
        a_( href: ){img_ src: img, title: }
        br_
        a_( href: ){title}
      end
    end
  end
end

puts doc
