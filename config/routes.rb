Claregal::Application.routes.draw do

  root 'static_pages#index'

  match '/new_subscriber',     to: 'subscribers#create',      via: 'post'

  match '/signup',             to: 'users#new',               via: 'get'
  match '/signin',             to: 'sessions#new',            via: 'get'
  match '/signout',            to: 'sessions#destroy',        via: 'delete'
  match '/joinlawfirm',        to: 'lawfirm_sessions#new',    via: 'get'   #route for joinin lawfirm
  match '/joinlawfirm/commit', to: 'lawfirm_sessions#create', via: 'post'


  #----------------------------------------------------------------------#
  get '/settlement_calculators', to: "settlement_calculators#calculate", as: :calculate

  resources :sessions,                only: [:new, :create, :destroy]
  resources :account_activations,     only: [:edit]
  resources :password_resets,         only: [:new, :create, :edit, :update]
  resources :lawfirm_password_resets, only: [:new, :edit, :create, :update]

  resources :users do
    resources :lawfirms do
      member do
        get :index_lawfirm_users
        post :toggle_dashboard
      end
      resources :practicegroups do
        member do
          get :group_case_list
        end
      end
      resources :staffings
      resources :case_types
      resources :overheads
    end
  end
  match '/staffings/import',    to: "staffings#import_staffing", via: 'post'
  match '/clients/import',      to: "clients#import_clients",    via: 'post'
  match '/matter_types/import', to: "case_types#import_matters", via: 'post'

  resources :clients do
    resources :cases do
      resources :staffs
      resources :fees
      resources :timings
      resources :originations
      resources :venues
      resources :checks
      resources :closeouts
      resources :matters
      resources :related_cases
    end
  end

  match '/new_case',               to: 'cases#new_case',          via: 'get' #for creating a new case directly, more ux friendly
  match '/new_case/create',        to:'cases#create_case',        via: 'get' #same as above
  match '/new_case/create',        to:'cases#create_case',        via: 'post' #same as above
  match '/new_closed_case',        to: 'cases#new_closed_case',   via: 'get' #for creating a new closed case directly, more ux friendly
  match '/new_closed_case/create', to:'cases#create_closed_case', via: 'get' #same as above
  match '/new_closed_case/create', to:'cases#create_closed_case', via: 'post' #same as above

  match '/lawfirm/cases',          to: 'lawfirms#show_lawfirm_cases', via: 'get' #to show current_user.lawfirm.cases
  match '/user/cases',             to:  'cases#user_cases',       via: 'get' #show all cases of current_user
#--------------------------Actual GRAPH ROUTES----------------------------------------------------

  get   'dashboard',                               to: "graphs#dashboard"

  resources :graph_actuals do
    member do
      get :revenue_by_year
      get :revenue_by_pg
      get :revenue_by_fee_type
      get :revenue_by_origination
      get :revenue_by_client
      get :closed_case_load_by_year
      get :individual_practice_group
      get "/revenue_by_month/:year/", to: :revenue_by_month, as: "revenue_by_month"
      get :revenue_by_attorney
    end
  end

  #--------------------------Expected GRAPH ROUTES----------------------------------------------------
  resources :graphs do
    member do
      get :revenue_by_client_estimate
      get :revenue_by_attorney_estimate
      get :practice_group_revenue_pie_low
    end
  end

  match '/practice_group/cases',                   to: "graphs#practice_group_pie",             via: 'get'
  match '/practice_group/:id/revenue',             to: "graph_individual_prac_groups#expected_individual_pg_rev", as: 'expected_individual_pg_rev', via: 'get'

  match '/revenue_by_year/practice_group',         to: "graphs#rev_by_year_by_pg",          via: 'get'
  match '/revenue_by_year/practice_group/high',    to: "graphs#rev_by_year_by_pg_high",     via: 'get'
  match '/revenue_by_year/practice_group/low',     to: "graphs#rev_by_year_by_pg_low",      via: 'get'

  match '/revenue_by_year/fee_type/medium',        to: 'graphs#rev_by_fee_type_medium',     via: 'get'
  match '/revenue_by_year/fee_type/high',          to: 'graphs#rev_by_fee_type_high',       via: 'get'
  match '/revenue_by_year/fee_type/low',           to: 'graphs#rev_by_fee_type_low',        via: 'get'

  match '/revenue_by_origination',                 to: 'graphs#fee_received_by_referral_medium', via: 'get'


  match '/revenue_by_year',                 to: 'graph_drilldowns#rev_by_year',             via: 'get'
  match '/revenue_year',                    to: 'graph_drilldowns#rev_year',                via: 'get'

  #I do not know why this is here, but when I remove it everything breaks
  match '/revenue_by_referral_source',      to: 'graphs#rev_by_fee_type_medium',            via: 'get'

end
