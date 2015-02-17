class StaticPagesController < ApplicationController
  layout 'pages'

  def index
    @subscriber = Subscriber.new
  end

  def coming_soon
  end

  def pricing
  end
end
