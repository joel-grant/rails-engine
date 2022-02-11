class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :id_not_found

  private
    def id_not_found
      render json: "ID #{params[:id]} does not exist!  We are displeased.", status: 404
    end
end
