# ===========================================
# Portfolio Application Routes
# ===========================================

Rails.application.routes.draw do
  # Health check endpoint
  get "health", to: "health#show"

  # ===========================================
  # HTML Fragment API for HTMX (public portfolio)
  # ===========================================
  namespace :fragments do
    get "hero", to: "hero#show"
    get "about", to: "about#show"
    
    # Projects
    get "projects", to: "projects#index"
    get "projects/featured", to: "projects#featured"
    get "projects/filter/:technology", to: "projects#filter", as: :projects_filter
    get "projects/:id", to: "projects#show", as: :project
    
    # Skills
    get "skills", to: "skills#index"
    get "skills/:category", to: "skills#category", as: :skills_category
    
    # Experience
    get "experience", to: "experience#index"
    
    # Blog Posts
    get "posts", to: "posts#index"
    get "posts/search", to: "posts#search"
    get "posts/:slug", to: "posts#show", as: :post
    
    # Testimonials
    get "testimonials", to: "testimonials#index"
    
    # Contact form
    post "contact", to: "contacts#create"
    get "contact/success", to: "contacts#success"
    get "contact/error", to: "contacts#error"
    
    # Contact info (dynamic from settings)
    get "contact-info", to: "contact_info#show"
  end

  # ===========================================
  # Admin Panel (full Rails with ERB)
  # ===========================================
  namespace :admin do
    root to: "dashboard#index"
    
    # Dashboard
    get "dashboard", to: "dashboard#index"
    
    # Content management
    resources :projects do
      member do
        patch :toggle_featured
        patch :update_position
      end
      collection do
        patch :reorder
      end
    end
    
    resources :posts do
      member do
        patch :publish
        patch :unpublish
      end
    end
    
    resources :messages, only: [:index, :show, :destroy] do
      member do
        patch :mark_read
        patch :mark_unread
      end
      collection do
        patch :mark_all_read
      end
    end
    
    resources :skills do
      collection do
        patch :reorder
      end
    end
    
    resources :experiences do
      collection do
        patch :reorder
      end
    end
    
    resources :testimonials do
      member do
        patch :toggle_featured
      end
      collection do
        patch :reorder
      end
    end
    
    # Settings
    resource :settings, only: [:show, :update]
    
    # Analytics
    get "analytics", to: "analytics#index"
  end

  # ===========================================
  # Authentication
  # ===========================================
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # ===========================================
  # ActionCable WebSocket
  # ===========================================
  mount ActionCable.server => "/cable"
end
