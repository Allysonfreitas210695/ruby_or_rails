class WelcomeController < ApplicationController
  def index
    # cookies[:user_name] = 'teste [cookies]'
    # session[:user_name] = 'teste [session]'
    @nome = params[:nome].present? ? params[:nome] : 'Sem params'
    @curso = 'Rails'
  end
end
