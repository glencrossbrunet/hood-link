module ApplicationHelper
  include UrlHelper
  include AuthHelper
  
  def persist(model)
    if model.save
      render json: model.to_json
    else
      render json: model.errors.full_messages, status: 422
    end
  end
end
