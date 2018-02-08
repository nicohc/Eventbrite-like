class UsersController < ApplicationController
  def home
  end

  def new
    @user= User.new
  end

  def create
    @user = User.new(user_params)
    if  @user.save
      log_in @user
      flash[:success] = "Bienvenue, Vous êtes bien inscrits." #Permet d'afficher une pop-up de confirmation de l'inscription.
      redirect_to @user  #Si la création du nouveau profil est bien réalisée, alors on fait afficher le profil crée via la fonction SHOW
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      flash[:danger] = 'Accès refusé !'
      redirect_to root_path
    end
  end

  def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          #Si l'update est bien réalisée (true), alors on redirige vers la page du profil.
          redirect_to @user
        else
          render 'edit'
        end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
    #On redirige vers l'index
  end



  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
