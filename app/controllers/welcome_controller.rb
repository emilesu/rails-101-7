class WelcomeController < ApplicationController
  def index
    flash[:warning] = "已发送！"
  end
end
