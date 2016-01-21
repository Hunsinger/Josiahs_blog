class ContactMailer < ApplicationMailer
	default from: "notification@josiah.com"

	def contact_email(name, email, phone, message)

		@name = name
		@email = email
		@phone = phone
		@message = message

		mail(from: email, to: "josiahrachaelbenji@gmail.com", subject: "#{name} sent you an email from your blog")
	end
end