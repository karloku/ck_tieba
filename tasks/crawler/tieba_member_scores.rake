
  
  task :'crawler:tieba_member_scores' => :environment do
    # This is a custom task.
    require 'open-uri'

    url_base = 'http://tieba.baidu.com'
    url_template = 'http://tieba.baidu.com/f/like/furank?kw=%CA%AE%D7%D6%BE%FC%D6%AE%CD%F5&pn='
    range = (1..100).to_a
    range.each do |page|
      url = url_template + page.to_s
      puts url
      doc = Nokogiri::HTML(open(url))

      member_nodes = doc.css('tr.drl_list_item')

      member_nodes.each do |member_node|

        name = member_node.at('td.drl_item_name').content

        member = Member.find_or_create_by(name: name)

        link = member_node.at('td.drl_item_name a').attribute('href')
        score = member_node.at('td.drl_item_exp').content

        member.name = name
        member.link = File.join(url_base, link)
        member.score = score

        if !member.save
          puts member.errors.full_messages
        end

      end
    end
  end


