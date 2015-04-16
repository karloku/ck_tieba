CkTieba::App.controllers :members do
  
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
    expires 1.hour
    order = params[:order].to_s.to_sym
    if !Member.new.respond_to?(order)
      order = :point_may_use
    end

    @members = Member.where(:score.gt => 0).to_a.sort_by! do |member|
      atr = member.send(order) 
      atr.respond_to?(:>) && atr.respond_to?(:<) ? atr : atr.to_s
    end.reverse!
    
    render 'members/index'
  end

end
