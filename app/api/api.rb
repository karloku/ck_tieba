module CkTieba
  class API < Grape::API
    version 'v1', using: :header, vendor: 'loku'
    format :json
    prefix :api

    resource :highlights do
      get do
        highlights = Highlight.all.to_a

        highlights.sort_by! do |highlight|
          highlight.author.point
        end.reverse!

        present highlights, with: Entities::Highlight
      end
    end

    resource :members do
      get do 
        order = params[:order].to_s.to_sym
        if !Member.new.respond_to?(order)
          order = :point_may_use
        end

        members = Member.where(:score.gt => 0).to_a.sort_by! do |member|
          atr = member.send(order) 
          atr.respond_to?(:>) && atr.respond_to?(:<) ? atr : atr.to_s
        end.reverse!

        present members, with: Entities::Member
      end
    end

    module Entities
      class Highlight < Grape::Entity
        expose :member do |highlight, options| 
          highlight.author.name
        end
        expose :title
        expose :link
      end

      class Member < Grape::Entity
        expose :name
        expose :link
        expose :score
        expose :calculated_level
        expose :highlights_count
        expose :role_desc
        expose :is_modder_desc do |member, options|
          member.is_modder? ? '是' : '否'
        end
        expose :point_may_use
      end
    end



  end
end