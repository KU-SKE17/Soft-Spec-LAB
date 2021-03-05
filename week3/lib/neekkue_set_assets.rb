require 'net/http'

def find_first_tag(source, tag)
  st = source.index("<#{tag}") + 2 + tag.length
  ed = source.index("</#{tag}")
  source[st, ed - st]
end

def find_assets(source)
  i = 0
  loop do
    i += 1
    st = source.index('<tr') + 5
    source = source[st, source.length]
    break if i == 3
  end
  ed = source.index('<td style=') - 1
  source = source[1, ed]

  times = source.split('</').size
  i = 0
  loop do
    i += 1
    st = source.index('<td') + 5
    source = source[st, source.length]
    break if i == times - 1
  end
  ed = source.index('&')
  source[0, ed]
end

def print_company(url)
  uri = URI(url)
  source = Net::HTTP.get(uri)

  realty_name = find_first_tag(source, 'h3')
  assets = find_assets(source)
  puts "#{realty_name} : #{assets}"
end

def find_first_url(source)
  st = source.index('?') + 1
  ed = source.index('" target=""')
  iden = source[st, ed - st]
  'https://www.set.or.th/set/companyhighlight.do?'.to_s + iden
end

def remove_top(source, top, bottom)
  st = source.index(top) + top.length
  ed = source.index(bottom) + bottom.length
  source[st, ed - st]
end

def print_all
  uri = URI('https://www.set.or.th/set/commonslookup.do')
  source = Net::HTTP.get(uri)

  i = 0
  loop do
    i += 1
    source = remove_top(source, '<tr valign="top">', '</table>')
    url = find_first_url(source)
    # puts url
    print_company(url)
    break if i == 67
  end
end
print_all
