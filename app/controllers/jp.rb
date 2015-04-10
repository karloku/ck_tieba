CkTieba::App.controllers :jp do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  
  get :index do
    expires 1.day

    @highlights = Highlight.all.to_a

    @highlights.sort_by! do |highlight|
      highlight.author.point
    end.reverse!

    render 'jp/index'
  end
end
