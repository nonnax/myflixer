#!/usr/bin/env ruby
# Id$ nonnax 2022-02-27 15:41:22 +0800
require 'rubytools/cubadoo'

NAVLINKS=%w[movie tv].zip(%w[movies tv-shows]).to_h

def layout(&block)
  tagz do 
    html_ do
      head_ do
        link_(rel: 'stylesheet', type: "text/css",  href: '/css/style.css')
      end
      body_ do
        div_(id: 'header') do 
          a_( href: "/"){ img_ src: "/images/banner.jpg", style:"width:100%" }
          br_
          p_(id: 'navlinks') do
            NAVLINKS.each do |k, v|
              a_( href: "/"+k){ v }
              span_{' '}
            end
          end
        end
        div_(id: 'content', &block)
        div_(class: 'footer') do
            a_( href: "/"){ img_ src: "/images/banner.jpg", style:"width:100%" }
        end
      end
    end
  end
end

doc=layout do
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
