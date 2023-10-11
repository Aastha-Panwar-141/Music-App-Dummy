class ShareTransferWorker
    include Sidekiq::Worker

    def perform(start_date, end_date)
        puts "working from #{start_date} to #{end_date}"
    end
end