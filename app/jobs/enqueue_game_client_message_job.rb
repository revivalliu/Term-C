
# Probably going to remove...

class EnqueueGameClientMessageJob < ActiveJob::Base
  queue_as :game_client_messages

  def perform(*args)
    # Do something later
    Thread.new {
      sleep(10)
      puts args.inspect
    }
  end
end
