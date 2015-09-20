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
      params do
        optional :page, type: Integer, default: 0
      end
      get do 
        members = Member.includes(:highlights).where(:score.gte => 100).desc(:point_may_use).desc(:score).page(params.page).per(100)

        header 'X-Pagination-Current-Page', members.current_page
        header 'X-Pagination-Total-Items', members.count

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