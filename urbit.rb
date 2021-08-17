require "sinatra"
require "nokogiri"
require "httparty"
require "reverse_markdown"

URBIT_URLS = [
  "https://urbit.org/docs/hoon/hoon-school/list-of-numbers/",
  "https://urbit.org/docs/hoon/hoon-school/nouns/",
  "https://urbit.org/docs/hoon/hoon-school/hoon-syntax/",
  "https://urbit.org/docs/hoon/hoon-school/conditionals/",
  "https://urbit.org/docs/hoon/hoon-school/gates/",
  "https://urbit.org/docs/hoon/hoon-school/recursion/",
  "https://urbit.org/docs/hoon/hoon-school/lists/",
  "https://urbit.org/docs/hoon/hoon-school/fibonacci/",
  "https://urbit.org/docs/hoon/hoon-school/the-subject-and-its-legs/",
  "https://urbit.org/docs/hoon/hoon-school/ackermann/",
  "https://urbit.org/docs/hoon/hoon-school/arms-and-cores/",
  "https://urbit.org/docs/hoon/hoon-school/caesar/",
  "https://urbit.org/docs/hoon/hoon-school/doors/",
  "https://urbit.org/docs/hoon/hoon-school/bank-account/",
  "https://urbit.org/docs/hoon/hoon-school/generators/",
  "https://urbit.org/docs/hoon/hoon-school/atoms-auras-and-simple-cell-types/",
  "https://urbit.org/docs/hoon/hoon-school/type-checking-and-type-inference/",
  "https://urbit.org/docs/hoon/hoon-school/structures-and-complex-types/",
  "https://urbit.org/docs/hoon/hoon-school/libraries/",
  "https://urbit.org/docs/hoon/hoon-school/molds/",
  "https://urbit.org/docs/hoon/hoon-school/trees-sets-and-maps/",
  "https://urbit.org/docs/hoon/hoon-school/type-polymorphism/",
  "https://urbit.org/docs/hoon/hoon-school/iron-polymorphism/",
  "https://urbit.org/docs/hoon/hoon-school/lead-polymorphism/",
  "https://urbit.org/docs/hoon/hoon-school/behn/",
  "https://urbit.org/docs/hoon/hoon-school/gall/",
  "https://urbit.org/docs/hoon/hoon-school/egg-timer/",
  "https://urbit.org/docs/hoon/hoon-school/list-of-numbers/"
]

LINK_REGEXP = /(\[([a-z|\s]+)\]\(\/[\S]+\))/

get "/quote" do
  raw_html = HTTParty.get(URBIT_URLS.sample).body
  doc = Nokogiri::HTML(raw_html)

  paragraphs = doc.css('article p').map do |paragraph|
    paragraph if paragraph.to_html.length > 250
  end.compact

  paragraph_html = paragraphs.sample.to_html

  markdown = ReverseMarkdown.convert(paragraph_html)
  
  # strip links
  matches = markdown.scan(LINK_REGEXP)
  matches.each do |match|
    markdown = markdown.gsub(match[0], "`#{match[1]}`")
  end

  markdown
end
