class EventsController < ApplicationController
    def new
      @event= Event.new
    end

    def create
    	@event = Event.new(event_params)
    	@event.creator = current_user
    	if @event.save
        flash[:success] = "Votre événement a bien été créé !"
        #Si la création du nouvel évent est bien réalisée, alors on fait afficher l'event créé via la fonction SHOW
        redirect_to @event
    	else
        render 'new'
        p "Une erreur existe, veuillez recommencer."
    	end
    end

    def show
      @event = Event.find(params[:id])
    end

    def index
      @events = Event.all
    end

    def edit
      @event = Event.find(params[:id])
      #Condition pour éviter l'édition d'événements don on n'est pas le creator.
      if @event.creator.id != current_user.id
        flash[:danger] = 'Accès refusé ! '
        redirect_to root_path
      end
    end

    def update
      @event = Event.find(params[:id])
      if @event.update(event_params)
        #Si l'update est bien réalisée (true), alors on redirige vers la page de l'event.
        redirect_to @event
      else
        render 'edit'
      end
    end

    def destroy
      @event = Event.find(params[:id])
      @event.destroy
      redirect_to events_path
      #On redirige vers l'index
    end


    private
  	def event_params
      params.require(:event).permit(:title, :description, :date, :place)
    end


end
