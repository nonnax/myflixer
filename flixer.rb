#!/usr/bin/env ruby
# Id$ nonnax 2022-02-17 13:07:07 +0800
require 'mechanize'
require 'pp'
require 'rubytools/numeric_ext'
require 'rubytools/cache'
require 'rubytools/string_ext'
require 'rubytools/thread_ext'
require 'rubytools/xxhsum'
require 'json'

URL_ROOT='https://myflixer.to'


def get_pages
  t, *pages=ARGV

  pages.map!(&:to_i)
  t ||= 'tv'

  page_set = 15_000.pages_of(5)
  pages.each do |i|
    res=Cache.cached([t,pages.join].join, ttl: 300*6) do
      work page_set[i], t: t
    end
    puts res
  end
end

def work page_set, t: 'mov'
  
  type = %w[tv-show movie].grep(/#{t}/).first
  t = type.sub('-show', '')

  pages=[]
  th=page_set.map do |i|
      Thread.new(type, i) do |type, i| 
        url="https://myflixer.to/#{type}?page=#{i}"
        agent=Mechanize.new
        page=agent.get(url)
        agent=Mechanize.new
        page=agent.get(url)
        pages<<page.dup
      end
  end
  th.each(&:join)

  pages.map do |page|
    page
      .search('//img[contains(@class,"film-poster-img")]')
      .map do |e| 
        ea=e.attributes 
         [
          ea['data-src'], 
          ea['alt'], 
          e.parent
            .search('a')
            .map do |a| 
              [].tap do |url_build|
                url = a.attributes["href"].value
                url_build << url
                url_build.prepend(URL_ROOT) if url.match(/^\//)
              end.join 
            end
            .last          
          ]
         .map(&:to_s) =>[image, title, link ]

         # {image:, title:, link: }
         [image, title, link ].join("\t")
      end
  end
rescue => e
  p [:error, e, page_set] 
  return nil    
end

# get_pages
# .map{|a| [URL_ROOT, a.attributes["href"].value].join }

# found = pages.first.links.select{|e| !e.text.empty? && e.href.to_s.match(/genre\//) }
# found.each do |pg|
  # puts pg.text.strip
# end
# 
# re=Regexp.new "#{t}\/"
# 
# pages.map do |page|
  # page
  # .links
  # .select{|e| !e.text.empty? && e.href.to_s.match(re) }
  # .sort_by{|e| e.text}
# end
# .flatten
# .each do |pg|
    # # p (pg.methods - Object.methods)
    # puts [pg.text, pg.resolved_uri.to_s].join("\t")
    # # puts pg.text
  # end

# pp found.click
# pages.map do |page|
  # page.search('//img[contains(@class,"film-poster-img")]')
      # .map{|e|
          # ea=e.attributes
          # puts [ea['alt'], ea['data-src']]
                # .map(&:to_s)
                # .join("\t")
       # }
# end
def get_rows(page=1, **h, &block)
  links={}
  get_page(page, **h).each do |page|
    page.map.with_index{|r, i|
      r=>{image:, title:, link:}
      key=image.xxhsum
      links[key]=[link, image]
      block.call( [title, link, image])
    }
  end
end

# get_pages
