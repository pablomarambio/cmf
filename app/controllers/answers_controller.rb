class AnswersController < ApplicationController
  before_filter :find_message, :except => [ :create, :set_evaluation]
  layout "public"

  def index
    @answers = Answer.all
  end

  def show
  end

  def new
    @user = User.find_by_username(params[:username])
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = Answer.new(params[:answer])
    @message = @answer.message
    if @answer.save
      UserMailer.requester_notification(@message.requester_email,@answer.id).deliver
      redirect_to root_path, notice: 'Your answer has been delivered.'
    else
      render action: "new"
    end
  end

  def update
    if @answer.update_attributes(params[:answer])
      redirect_to @answer, notice: 'Answer was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @answer.destroy
    redirect_to answers_url
  end

  def evaluate_answer
    @answer = Answer.find(params[:id])
    redirect_to root_path, :flash => { :error => "Sorry, couldn't find your petition" } if @answer.message.id != @message.id
  end

  def set_evaluation
    @answer = Answer.find(params[:id])
    @message = @answer.message
    if @answer.update_attributes(params[:answer])
      redirect_to root_path, notice: 'Thanks for evaluate the experience!'
    else
      render action: "evaluate_answer"
    end
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_message
    @message = Message.find_by_secure_token(params[:token])
    if @message.nil?
      flash[:error] = "We couldn't find your petition, please try again"
      redirect_to root_path and return
    end
  end

end
