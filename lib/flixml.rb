#!/usr/bin/env ruby
# Id$ nonnax 2022-02-27 15:41:22 +0800
# NOTE: ARGV sets @active page for navlink

require 'tagu'

NAVLINKS=%w[movie tv].zip(%w[movies tv-shows]).to_h

class << self
  attr_accessor :active
end

# def link_img_banner_
  # tagu(true) do
    # p!{ a!( href: "/" ){img! src: "/images/banner.jpg", style:"width:100%"} }
  # end
# end

def layout(**opts, &block)
  tagu(true) do
    div!(id: 'header') { 
      p!{ a!( href: "/" ){img! src: "/images/banner.jpg", style:"width:100%"} }
      div!(class: 'navbar') {
        NAVLINKS.each do |k, v|
          div!{
            link_opts={href: "/#{k}"}
            link_opts.merge!(class: 'active') if k.match?(/#{opts[:active]}/)
            a!( **link_opts ){ v }
          }
        end
        # nil
       }
     }
    div!(id: 'container', &block)
  end
end
