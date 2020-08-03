# A little mess here :)

FORMAT = '%Y-%m-%d'
ADDRESSES = 10_000
THREADS = 5
PUTS = false

def ip_generator(index)
  IPAddr.new(index,Socket::AF_INET).to_s
end

def random_name(index)
  "#{rand(36**8).to_s(36)}_#{index}"
end

def events_slice
  return Event.count if Event.count < THREADS
  Event.count / THREADS
end

def generate_addresses(addresses_number)
  sql = 'INSERT INTO addresses (ip, banned_at) VALUES '
  addresses_number.times do |address_index|
    ip = "'#{ip_generator(address_index)}'"
    banned_at = "'#{address_index.days.ago.strftime(FORMAT)}'"
    sql << "(#{ip}, #{banned_at}), "
    puts "Address: #{address_index}" if PUTS
  end
  ActiveRecord::Base.connection.execute(sql[0...-2])
end

def generate_events(events_number)
  sql = 'INSERT INTO events (name, address_id) VALUES '
  last_address_id = Address.last.id
  Address.pluck(:id).each do |address_id|
    events_number.times do |index|
      name = "'#{random_name(index)}'"
      sql << "(#{name}, #{address_id}), "
      puts "Address_id: #{address_id}/#{last_address_id}, Event: #{index}" if PUTS
    end
  end
  ActiveRecord::Base.connection.execute(sql[0...-2])
end

def generate_emails(emails_number)
  last_event_id = Event.last.id
  threads = []
  events_arrays_array = Event.pluck(:id).each_slice(events_slice)
  last_batch_index = events_arrays_array.to_a.length - 1
  allowed_to_connect_to_database_by_index = 0
  events_arrays_array.each_with_index do |event_ids, index|
    threads << Thread.new do
      show_puts = PUTS && last_batch_index == index
      sql = 'INSERT INTO emails (value, last_detected_at, event_id) VALUES '
      event_ids.each do |event_id|
        emails_number.times do |index|
          value = "'#{random_name(index)}@gmail.com'"
          last_detected_at = "'#{index.days.ago.strftime(FORMAT)}'"
          sql << "(#{value}, #{last_detected_at}, #{event_id}), "
          puts "Event_id: #{event_id}/#{last_event_id}, Email: #{index}" if show_puts
        end
      end
      while allowed_to_connect_to_database_by_index != index; end
      puts "Adding to database: thread index #{allowed_to_connect_to_database_by_index}/#{last_batch_index}"
      ActiveRecord::Base.connection.execute(sql[0...-2])
      allowed_to_connect_to_database_by_index += 1
    end
  end
  threads.each(&:join)
end

def generate_requests(requests_number)
  last_event_id = Event.last.id
  threads = []
  events_arrays_array = Event.pluck(:id).each_slice(events_slice)
  last_batch_index = events_arrays_array.to_a.length - 1
  allowed_to_connect_to_database_by_index = 0
  events_arrays_array.each_with_index do |event_ids, index|
    threads << Thread.new do
      show_puts = PUTS && last_batch_index == index
      sql = 'INSERT INTO requests (detected_at, event_id) VALUES '
      event_ids.each do |event_id|
        requests_number.times do |index|
          detected_at = "'#{index.days.ago.strftime(FORMAT)}'"
          sql << "(#{detected_at}, #{event_id}), "
          puts "Event_id: #{event_id}/#{last_event_id}, Request: #{index}" if show_puts
        end
      end
      while allowed_to_connect_to_database_by_index != index; end
      puts "Adding to database: thread index #{allowed_to_connect_to_database_by_index}/#{last_batch_index}"
      ActiveRecord::Base.connection.execute(sql[0...-2])
      allowed_to_connect_to_database_by_index += 1
    end
  end
  threads.each(&:join)
end

puts '===== Removing all data ====='
Request.delete_all
Email.delete_all
Event.delete_all
Address.delete_all

puts '===== Creating Addresses ====='
generate_addresses ADDRESSES
puts '===== Creating Events ====='
generate_events 1 # events number per address
puts '===== Creating Emails ====='
generate_emails 50 # emails number per event
puts '===== Creating Requests ====='
generate_requests 250 # requests number per event

puts '===== SUM UP ====='
puts "Addresses: #{Address.count}"
puts "Events: #{Event.count}"
puts "Email: #{Email.count}"
puts "Request: #{Request.count}"
