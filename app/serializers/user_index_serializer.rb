class UserIndexSerializer < ActiveModel::Serializer
  attributes :id, :slug, :truncated_quote, :truncated_name, :view

  def view
    view_object = {}
    
  end
end
