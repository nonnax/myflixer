#!/usr/bin/env ruby
# Id$ nonnax 2022-02-27 15:41:22 +0800
require 'rubytools/cubadoo'

NAVLINKS=%w[movie tv].zip(%w[movies tv-shows]).to_h

def layout(&block)

  link_img_banner_ = tagz do 
    p_{ a_( href: "/" ){img_ src: "/images/banner.jpg", style:"width:100%"} }
  end
  nav_links_ = tagz do
    p_(id: 'navlinks') {
      NAVLINKS.each do |k, v|
        a_( href: "/#{k}" ){ v }
        span_{' '}
      end
    }
  end

  tagz do
    html_ do
      head_ {
        link_(rel: 'stylesheet', type: "text/css",  href: '/css/style.css')
      }
      body_ {
        div_(id: 'header') { 
          link_img_banner_
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
        a_( href: "/"+l){ h2_{ "#{l}"} } unless l.match?(/index/)
        next
      end
      div_ do
        l.split(/\t/) => [img, title, href]
        a_( href: ){img_ src: img, title: }
        br_
        a_( href: ){title}
      end
    end
  end
end

puts doc
