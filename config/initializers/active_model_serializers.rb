ActiveSupport.on_load(:active_model_serializers) do
  ActiveModel::Serializer.root = 'content'
  ActiveModel::ArraySerializer.root = 'content'
end
