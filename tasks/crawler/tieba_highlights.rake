
  
  task :'crawler:tieba_highlights' => :environment do
    # This is a custom task.
    tieba_base = 'http://tieba.baidu.com'
    highlighted_res =  Oj.load RestClient.get('https://www.kimonolabs.com/api/5xt6k5so?apikey=3Rlu8iIwO65BiRlIvObBZWTSpoTeZjFM'), symbol_keys: true
    
    highlights_j = highlighted_res[:results][:Highlighted]


    highlights_j.each do |highlight_j|

      title = highlight_j[:title]
      highlight = Highlight.find_or_create_by(title: title)

      author = highlight_j[:author]
      link = highlight_j[:link]

      member = Member.find_or_create_by(name: author)

      highlight.author = member
      highlight.link = link
      highlight.title = title
      highlight.save
      
      member.save
    end
  end


