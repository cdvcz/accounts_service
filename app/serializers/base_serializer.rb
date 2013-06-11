class BaseSerializer < ActiveModel::Serializer

  def attributes
    object
  end
end
