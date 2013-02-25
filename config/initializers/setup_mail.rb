ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "mythreshold.com",  
  :user_name            => "mythreshold.noreply",  
  :password             => "mythreshold123",  
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}  
