# inside app/jobs/hello_world_job.rb

require 'sidekiq-scheduler'

class HelloWorldJob 
  include Sidekiq::Worker
  queue_as :default
  
  def perform(*args)
    byebug
    # Simulates a long, time-consuming task
    sleep 5
    # Will display current time, milliseconds included
    p "hello from HelloWorldJob #{Time.now().strftime('%F - %H:%M:%S.%L')}"
  end
end
