require 'httparty'
require 'json'
require './lib/roadmap'
class Kele
  include HTTParty
  include Roadmap
  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { email: email, password: password })
    raise 'Invalid email or password' if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url("users/me"), headers: { "authorization" => @auth_token })
    @user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    # alex's mentor id 946
    response = self.class.get(api_url("mentors/#{mentor_id.to_s}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page = nil)
    if page == nil
      response = self.class.get(api_url("message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(api_url("message_threads?page=#{page}"), headers: { "authorization" => @auth_token })
    end
    @get_messages = JSON.parse(response.body)
  end

  def create_message(sender_email, recipient_id, subject, message)
    response = self.class.post(api_url("messages"), headers: { "authorization" => @auth_token }, body: {"sender_email": sender_email, "recipient_id": recipient_id, "subject": subject, "stripped-text": message })
    puts response
  end

  private

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
end
