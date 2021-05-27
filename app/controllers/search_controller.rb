class SearchController < ApplicationController
  skip_load_and_authorize_resource

  def search
    @query = params[:query]
    @resource = params[:resource]
    @search_result = model_klass(@resource).search(@query) if @query
  end

  private

  def model_klass(class_name)
    class_name == 'all' ? ThinkingSphinx : class_name.classify.constantize
  end
end
