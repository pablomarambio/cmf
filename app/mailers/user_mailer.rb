class UserMailer < ActionMailer::Base
  default from: "mythreshold.noreply@gmail.com"

  def receiver_notification(user_id,message_id)
    @user = User.find(user_id)
    @message = Message.find(message_id)
    mail(:to => @user.email, :subject => "[My Threshold] You have a new message")
  end

  def applicant_notification(user_email,message)
    @message = message
    mail(:to => user_email, :subject => "[My Threshold] Your petition has been answered")
  end

end
