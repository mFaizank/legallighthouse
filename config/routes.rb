Rails.application.routes.draw do
  devise_for :admins, path: 'admin', path_names: { sign_in: '' }, only: :sessions
  devise_for :users
  devise_for :lawyers, controllers: { registrations: 'lawyers/registrations' }

  resources :applications, only: [:new, :create]
  get 'application_form', to: 'applications#new', as: 'application_form', locale: 'en'
  get 'formulaire_de_candidature', to: 'applications#new', as: 'formulaire_de_candidature', locale: 'fr'

  scope :admin do
    resources :applications, only: [:index, :show]
    get 'applications/:id/approve', to: 'applications#approve', as: 'approve_application'
    get 'applications/:id/reject', to: 'applications#reject', as: 'reject_application'
  end

  namespace :admin do
    resources :lawyers, only: :index
    resources :users, only: :index
  end

  resources :lawyers, only: [:index, :show]
  resources :areas, except: [:index, :show]
  scope '/areas/:id' do
    resources :services, only: :new
  end
  resources :services, except: :new

  get 'lawyers/search'
  get 'lawyers/name_search'
  # get '/lawyers', to: 'lawyers#index'
  # get '/lawyers/:id', to: 'lawyers#show', as: 'lawyer'
  get 'profile/edit', to: 'lawyers#edit', as: 'edit_profile'
  put 'profile', to: 'lawyers#update', as: 'profile'
  get 'profile/list', to: 'lawyers#list', as: 'list_profile'
  get 'profile/unlist', to: 'lawyers#unlist', as: 'unlist_profile'
  get 'profile/preview', to: 'lawyers#preview', as: 'preview_profile'
  get '/lawyer/:public_id', to: 'lawyers#public_show', as: 'public_lawyer'
  get '/avocat/:public_id', to: 'lawyers#public_show', as: 'avocat_publique'
  get '/lawyers/:lawyer_id/consultation_requests/new', to: 'consultation_requests#new', as: 'new_consultation_request'
  post '/lawyers/:lawyer_id/consultation_requests', to: 'consultation_requests#create', as: 'consultation_requests'

  get '/consultation_requests/user', to: 'consultation_requests#user_index', as: 'user_consultation_requests'
  get '/consultation_requests/lawyer', to: 'consultation_requests#lawyer_index', as: 'lawyer_consultation_requests'
  put '/consultation_requests/:id/cancel', to: 'consultation_requests#cancel', as: 'cancel_consultation_request'
  get '/consultation_requests/:id/accept', to: 'consultation_requests#accept', as: 'accept_consultation_request'
  put '/consultation_requests/:id/accept', to: 'consultation_requests#accepted'
  get '/consultation_requests/:id/decline', to: 'consultation_requests#decline', as: 'decline_consultation_request'
  put '/consultation_requests/:id/decline', to: 'consultation_requests#declined'

  get '/consultations/user', to: 'consultations#user_index', as: 'user_consultations'
  get '/consultations/lawyer', to: 'consultations#lawyer_index', as: 'lawyer_consultations'
  get '/consultations/:id/confirm', to: 'consultations#confirm', as: 'confirm_consultation'
  put '/consultations/:id/confirm', to: 'consultations#confirmed'

  resources :lawyer_quotes, only: [:index, :show, :edit, :update]
  delete 'lawyer_quotes/:id/cancel', to: 'lawyer_quotes#cancel', as: 'cancel_quote'

  get '/users/:user_id/quotes/new', to: 'lawyer_quotes#new', as: 'new_quote'
  post '/users/:user_id/quotes', to: 'lawyer_quotes#create', as: 'user_quotes'

  resources :consultation_requests, only: :show
  resources :quotes, only: [:index, :show] do
    resources :payment_requests do
      collection do
        get 'disbursement'
        post 'request_disbursement'
      end
    end
    resources :payments do
      collection do
        get 'charge_flat_fee_lawyer'
      end
    end
  end

  put 'quotes/accept', to: 'quotes#accept', as: 'accept_quote'
  put 'quotes/reject', to: 'quotes#reject', as: 'reject_quote'
  put 'quotes/request_modification', to: 'quotes#request_modification', as: 'request_quote_modification'

  resources :clients, only: [:index, :show]

  resources :leads, only: [:create]
  resources :lawyer_leads, only: [:create]

  get '/notre_plateforme', to: 'high_voltage/pages#show', as: 'notre_plateforme', defaults: { id: 'how_it_works' }
  get '/pour_les_avocats', to: 'high_voltage/pages#show', as: 'pour_les_avocats', defaults: { id: 'lawyers' }
  get '/notre_vision', to: 'high_voltage/pages#show', as: 'notre_vision', defaults: { id: 'vision' }
  get '/notre_equipe', to: 'high_voltage/pages#show', as: 'notre_equipe', defaults: { id: 'team' }

  get '/contact', to: 'contacts#new', as: 'contact'
  resources :contacts, only: [:create]

  get '/legal/terms_of_use', to: redirect('/terms_of_use.pdf')
  get '/legal/privacy_policy', to: redirect('/privacy_policy.pdf')
  get '/legale/termes_et_conditions', to: redirect('/termes_et_conditions.pdf')
  get '/legale/politique_de_confidentialite', to: redirect('/politique_de_confidentialite.pdf')

  post 'bank_accounts/create' => 'bank_accounts#create', as: :bank_accounts_create
  post 'credit_cards/create' => 'credit_cards#create', as: :credit_card_create
  get 'credit_cards/new' => 'credit_cards#new', as: :new_credit_card
  get 'bank_accounts/new' => 'bank_accounts#new', as: :new_bank_account
  get 'credit_cards' => 'credit_cards#index', as: :credit_cards
  get 'bank_accounts' => 'bank_accounts#index', as: :bank_accounts
  get 'credit_cards/destroy/:id/:customer_id' => 'credit_cards#destroy', as: :credit_card_delete
  get 'bank_accounts/destroy/:id' => 'bank_accounts#destroy', as: :bank_account_delete
  get 'credit_cards/:id/update_default_card/:customer_id' => 'credit_cards#update_default_card', as: :update_default_card
  get 'bank_accounts/:id/update_default_bank_account' => 'bank_accounts#update_default_bank_account', as: :update_default_bank_account
  get 'payments/:id/pay_fee_to_lawyer' => 'payments#pay_fee_to_lawyer', as: :pay_fee_to_lawyer
  get 'payments/lawyer_history' => 'payments#lawyer_history', as: :lawyer_history
  get 'payments/client_history' => 'payments#client_history', as: :client_history
end
