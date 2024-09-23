class NpmDepsController < ApplicationController
  def index
  end

  def fetch
    response = HTTParty.get('https://registry.npmjs.org/'+ params[:name]+'/latest')
    render json: response, :status => :ok
  end
end
