
  desc '爬取精品贴'
  task :'crawler:tieba_highlights' => :environment do
    # This is a custom task.
    tieba_base = URI.encode 'http://tieba.baidu.com/f/good?kw=十字军之王&ie=utf-8&cid=0&pn=0'
    per_page = 50

    has_next = true


    uri = URI.parse tieba_base
    html = open(uri).read
    Highlight.destroy_all if html.present?
    while has_next do
      puts uri
      res = Nokogiri(html)

      highlights = res.css('li.j_thread_list.clearfix > div.t_con.cleafix > div.col2_right.j_threadlist_li_right > div.threadlist_lz.clearfix')

      highlights.each do |highlight|
        title_node = highlight.at('div.threadlist_title.pull_left.j_th_tit > a.j_th_tit')
        member_node = highlight.at('div.threadlist_author.pull_right > span.tb_icon_author > a.j_user_card')

        title = title_node.content
        link = uri.merge title_node['href']
        author = member_node.content

        highlight = Highlight.find_or_create_by(title: title)

        member = Member.find_or_create_by(name: author)

        highlight.author = member
        highlight.link = link
        highlight.title = title
        highlight.save
        
        member.save
      end

      has_next = !res.css('a.next').empty?

      if has_next 
        query = Hash[URI.decode_www_form uri.query]
        query["pn"] = query["pn"].to_i + per_page
        uri.query = URI.encode_www_form query
      end
    end

  end


