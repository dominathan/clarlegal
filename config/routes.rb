Claregal::Application.routes.draw do

  root 'home_pages#home'

  resources :users do
    resources :lawfirms do
      resources :practicegroups
      resources :staffings
      resources :case_types
    end
  end

  resources :sessions,         only: [:new, :create, :destroy]

  resources :clients do
    resources :cases do #nested routes so it has to be clients/3/cases/4....etc for parameters
      resources :staffs
      resources :fees
      resources :timings
      resources :originations
      resources :venues
      resources :checks
    end
  end

  match '/about', to: 'home_pages#about', via: 'get'
  match '/contact', to: 'home_pages#contact', via: 'get'
  match '/signup', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/joinlawfirm', to: 'lawfirm_sessions#new', via: 'get'   #route for joinin lawfirm
  match '/joinlawfirm/commit', to: 'lawfirm_sessions#create', via: 'post'
  match '/lawfirm/cases', to: 'lawfirms#show_lawfirm_cases', via: 'get' #to show current_user.lawfirm.cases
  match '/user/cases', to:  'cases#user_cases', via: 'get' #show all cases of current_user


  # May the Graphs Begin
  match '/practice_group/cases', to: "graphs#practice_group_pie", via: 'get'
  match '/practice_group/revenues', to: "graphs#practice_group_revenue_pie_low", via: 'get'

  match '/revenue_by_year', to: "graphs#case_revenue_by_year", via: 'get'
  match '/revenue_by_year/fast', to: "graphs#case_revenue_by_year_fast", via: 'get'
  match '/revenue_by_year/slow', to: "graphs#case_revenue_by_year_slow", via: 'get'

  match '/revenue_by_year/practice_group', to: "graphs#rev_by_year_by_pg", via: 'get'
  match '/revenue_by_year/practice_group/high', to: "graphs#rev_by_year_by_pg_high", via: 'get'
  match '/revenue_by_year/practice_group/low', to: "graphs#rev_by_year_by_pg_low", via: 'get'





  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
