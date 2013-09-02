class AbilitiesController < ApplicationController

  before_filter :check_permissions

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
    @ability = Ability.new(params[:ability])
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

    if @ability.update_attributes(params[:ability])
      flash[:notice] = t('ability.saved')
      redirect_to :action => :index
    else
      render 'edit'
    end
  end

private


end
