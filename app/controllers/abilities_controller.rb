class AbilitiesController < ApplicationController

  before_action :check_permissions

  def index
    @abilities = Ability.order(:name)
  end

  def show
    @ability = Ability.find(params[:id])
  end

  def new
    @ability = Ability.new
  end

  def create
    @ability = Ability.new(ability_params)
    if @ability.save
      flash[:notice] = t('ability.created')
      redirect_to :action => :index
    else
      render 'new'
    end
  end


  def edit
    @ability = Ability.find(params[:id])
  end

  def update
    @ability = Ability.find(params[:id])

    if @ability.update_attributes(ability_params)
      flash[:notice] = t('ability.saved')
      redirect_to :action => :index
    else
      render 'edit'
    end
  end

  protected

  def ability_params
    params.require(:ability).permit(:name, :description,
      :ability_permissions_attributes => [:id, :permission_id, :_destroy,
                                          :permission_attributes => [:id, :allowed_action, :_destroy]
                                         ]
    )
  end


end
