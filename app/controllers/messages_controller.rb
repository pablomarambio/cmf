class MessagesController < ApplicationController

  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
    user = User.find_by_username(params[:username])
    payment = Payment.find_by_id_and_random(params[:payment_id],params[:payment_random])
    redirect_to root_path, :flash => { :error => "Your payment was not be found, Retry."} unless payment && payment.paid? && user
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new(params[:message])
    @message.user = User.find_by_username(params[:username])
    @payment = Payment.find_by_id_and_random(params[:payment_id],params[:payment_random])
    if @payment.paid? && @payment.user_id == @message.user.id
      @message.payment_id = @payment.id
      @message.secure_token = SecureRandom.hex(8)
      if @message.save
        UserMailer.receiver_notification(@message.user.id,@message.id).deliver
        redirect_to root_path, notice: 'Message was successfully created.'
      else
        render action: "new" 
      end
    else
      redirect_to root_path, :flash => { :error => "Your payment was not be found, Retry."}
    end
  end

  def update
    @message = Message.find(params[:id])

    if @message.update_attributes(params[:message])
      redirect_to @message, notice: 'Message was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to messages_url
  end

end
