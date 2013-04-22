class MessagesController < ApplicationController
  layout "public"

  def new
    @message = Message.new
    @user = User.find_by_username(params[:username])
    redirect_to request[:referer], :flash => { :error => "Your payment was not be found, Retry."} unless @user
  end

  def create
    @message = Message.new(params[:message])
    @user = User.find_by_username(params[:username])
    redirect_to request[:referer], :flash => { :error => "Your payment was not be found, Retry."} unless @user
    @message.user = @user
    @message.secure_token = SecureRandom.hex(8)
    if @message.save
      UserMailer.receiver_notification(@message.user.id,@message.id).deliver
      redirect_to public_profile_path(params[:username]), notice: 'Message was successfully created.'
    else
      render action: "new" 
    end
  end

  def find_payment
    @payment = Payment.find_by_id_and_random(params[:payment_id],params[:payment_random])
    if @payment.nil? || !@payment.paid?
      flash[:error] = "Your payment was not be found, Retry."
      redirect_to root_path and return
    end
  end
end
