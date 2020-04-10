class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@#{Rails.configuration.default_email_domain}"
  layout 'mailer'

  def add_env_if_needed(email_subject)
    env = Rails.configuration.cmr_env
    if env != 'ops'
      email_subject = email_subject + " (#{env.upcase})"
    end
  end
end
