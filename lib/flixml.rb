#!/usr/bin/env ruby
# Id$ nonnax 2022-02-27 15:41:22 +0800
# NOTE: ARGV sets @active page for navlink

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
          link_opts.merge!(class: 'active') if k.match?(/#{@active}/)
          a_( **link_opts ){ v }
        }
      end
    }
  end
end

def layout(&block)
  tagz do
    div_(id: 'header') { nav_links_}
    div_(id: 'content', &block)
  end
end

