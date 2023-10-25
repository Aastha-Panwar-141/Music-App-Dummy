class SplitsController < ApplicationController

  def index
    splits = Split.all
    if splits.present?
      render json: splits
    else
      render json: {error: "There is no split!"}, status: :no_content
    end
  end
end
