class ExampleMailer < ActionMailer::Base
  default from: params["email"]

  def sample_email()
    mail(to: "josiahrachaelbenji@gmail.com", subject: "Message from User")
  end
end

ExampleMailer.sample_email().deliver