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

    email_obj.last_detected_at = request_obj.detected_at
    email_obj.save! && request_obj.save!
  end

  def detected_attack?
    return true if banned?
    return false unless reached_limits?

    address.ban!
    true
  end

  private

  def banned?
    address.banned_at.present? && address.banned_at > CSDApp.ip_ban_time.seconds.ago
  end

  # Reached limits methods

  def reached_limits?
    datetime = CSDApp.sample_period.seconds.ago
    reached_emails_limit?(datetime) && reached_requests_limit?(datetime)
  end

  def reached_emails_limit?(datetime)
    event.emails.where('last_detected_at > ?', datetime).count > CSDApp.ip_emails_limit
  end

  def reached_requests_limit?(datetime)
    event.requests.where('detected_at > ?', datetime).count > CSDApp.ip_requests_limit
  end

  # Models objects

  def address
    @address ||= Address.find_or_create_by(ip: ip)
  end

  def event
    @event ||= address.events.find_or_create_by(name: event_name)
  end

  def email_obj
    @email_obj ||= event.emails.find_or_initialize_by(value: email)
  end

  def request_obj
    @request_obj ||= event.requests.new(detected_at: DateTime.now)
  end
end
