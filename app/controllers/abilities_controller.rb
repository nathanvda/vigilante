class AbilitiesController < ApplicationController

  before_filter :check_permissions

  def index
    @abilities = Ability.order(:name)
  end

  def show
    @ability = Ability.find(params[:id])
  end


private



end
