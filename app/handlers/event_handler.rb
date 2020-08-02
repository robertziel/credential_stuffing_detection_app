class EventHandler
  include ActiveModel::Validations

  attr_accessor :email, :ip, :event_name

  validates :email, :ip, :event_name, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :ip, format: { with: VALID_IP_REGEX }

  def initialize(params)
    @email = params[:email]
    @ip = params[:ip]
    @event_name = params[:event_name]
  end

  def save
    return false unless valid?

    email_obj = address.emails.find_or_initialize_by(value: email)
    email_obj.events << Event.new(name: event_name)
    email_obj.save! # TODO: Assign right last_detected_at to event_obj
  end

  def detected_attack?
    # TODO: test both  banned_at nil and present
    return true if address.banned_at.present? && address.banned_at > CSDApp.ip_ban_time.seconds

    false # TODO: Detect if limits reached
  end

  private

  def address
    @address ||= Address.find_or_create_by(ip: ip)
  end

  def valid_params?
    true
  end
end
