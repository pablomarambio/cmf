class PaymentsController < ApplicationController

  def create
    @payment = Payment.new(params[:payments])
    user = User.find(params[:user_id])
    @payment.amount = user.threshold
    @payment.user = user
    if @payment.save
      redirect_to payment_router_path(:id => @payment.id, :random => @payment.random, :status => params[:status])
    else
      redirect_to root_path, :flash => { :error => "Payment cannot be created." }
    end
  end

  def payment_router
    @payment = Payment.find_by_id_and_random(params[:id],params[:random])
    if params[:status] == "ok"
      @payment.status = "done"
      @payment.save
      redirect_to new_message_path(:username => @payment.user.username), :flash => { :notice => "Your payment was successful, now write your petition" }
    else
      redirect_to root_path, :flash => { :error => "Your payment has failed, retry" } 
    end
  end

end
