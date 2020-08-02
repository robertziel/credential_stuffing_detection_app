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

    email_obj.events << event_obj
    email_obj.last_detected_at = event_obj.detected_at
    email_obj.save!
  end

  def detected_attack?
    banned? || reached_limits?
  end

  private

  def banned?
    address.banned_at.present? && address.banned_at > CSDApp.ip_ban_time.seconds
  end

  def reached_limits?
    false
  end

  def address
    @address ||= Address.find_or_create_by(ip: ip)
  end

  def email_obj
    @email_obj ||= address.emails.find_or_initialize_by(value: email)
  end

  def event_obj
    @event_obj ||= Event.new(name: event_name, detected_at: DateTime.now)
  end
end
