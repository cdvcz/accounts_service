class BaseController < ActionController::API

  ##
  # Seznam zaznamu
  def index
    search    = resource_class.search(params[:search])
    resources = search.paginate(page: params[:page])

    render json: resources,
           meta: { total_entries: resources.total_entries,
                   total_pages: resources.total_pages }
   end

  ##
  # Detail zaznamu
  def show
    resource = resource_class.find(params[:id])
    render json: resource
  end

  ##
  # Vytvori novy zaznam
   def create
    resource = resource_class.create(resource_params)
    if resource.save
      render json: resource
    else
      render json: { content: { errors: resource.errors } },
             status: :unprocessable_entity
    end
  end

  ##
  # Upravi zaznam
  def update
    resource = resource_class.find(params[:id])
    if resource.update_attributes(resource_params)
      render json: {},
             status: 204
    else
      render json: { content: {errors: resource.errors} },
             status: :unprocessable_entity
    end
  end

  ##
  # Smaze zaznam
  def destroy
    resource = resource_class.find(params[:id])
    resource.destroy
    render json: {},
           status: 204
  end

  protected

  def resource_name
    resource_name = params[:controller].singularize.camelize
   end

  def resource_class
    resource_name.constantize
  end

  def resource_params
    params[resource_name.underscore.to_sym]
  end
end
