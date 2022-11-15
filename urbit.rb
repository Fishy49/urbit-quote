require "sinatra"
require "nokogiri"
require "httparty"
require "reverse_markdown"

URBIT_URLS = [
  "https://developers.urbit.org/guides/core/hoon-school/A-intro",
  "https://developers.urbit.org/guides/core/hoon-school/B-syntax",
  "https://developers.urbit.org/guides/core/hoon-school/C-azimuth",
  "https://developers.urbit.org/guides/core/hoon-school/D-gates",
  "https://developers.urbit.org/guides/core/hoon-school/E-types",
  "https://developers.urbit.org/guides/core/hoon-school/F-cores",
  "https://developers.urbit.org/guides/core/hoon-school/G-trees",
  "https://developers.urbit.org/guides/core/hoon-school/H-libraries",
  "https://developers.urbit.org/guides/core/hoon-school/I-testing",
  "https://developers.urbit.org/guides/core/hoon-school/J-stdlib",
  "https://developers.urbit.org/guides/core/hoon-school/K-doors",
  "https://developers.urbit.org/guides/core/hoon-school/L-struct",
  "https://developers.urbit.org/guides/core/hoon-school/M-typecheck",
  "https://developers.urbit.org/guides/core/hoon-school/N-logic",
  "https://developers.urbit.org/guides/core/hoon-school/O-subject",
  "https://developers.urbit.org/guides/core/hoon-school/P-stdlib",
  "https://developers.urbit.org/guides/core/hoon-school/Q-func",
  "https://developers.urbit.org/guides/core/hoon-school/Q2-parsing",
  "https://developers.urbit.org/guides/core/hoon-school/R-metals",
  "https://developers.urbit.org/guides/core/hoon-school/S-math"
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
