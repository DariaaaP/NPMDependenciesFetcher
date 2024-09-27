class DepsCollectorController < ApplicationController
  def index;end
  def fetch_deps_all
    package_name = params[:name]
    @dependencies = FetchDependenciesAll.fetch_dependencies(package_name)
    render json: @dependencies, status: :ok
  end
end
