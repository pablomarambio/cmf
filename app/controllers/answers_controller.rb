class AnswersController < ApplicationController
  before_filter :find_answer, :except => [:index, :new, :create]

  def index
    @answers = Answer.all
  end

  def show
  end

  def new
    @message = Message.find(params[:message_id])
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
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
