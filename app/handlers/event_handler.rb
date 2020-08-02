class EventHandler
  attr_reader :email, :ip, :name

  def initialize(params)
    @email = params[:email]
    @ip = params[:ip]
    @name = params[:event_name]
  end

  def save
    email_obj = address.emails.find_or_initialize_by(value: email)
    email_obj.events << Event.new(name: name)

    email_obj.save! # TODO: Assign right last_detected_at to event_obj
  end

  def detected_attack?
    # TODO: test both  banned_at nil and present
    return true if address.banned_at.present? && address.banned_at > CSDApp.ip_ban_time.seconds

    false # TODO: Detect if limits reached
  end

  def errors
    [] # TODO: add validation errors
  end

  private

  def address
    @address ||= Address.find_or_create_by(ip: ip)
  end

  def valid_params?
    true
  end
end
