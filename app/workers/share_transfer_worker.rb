class ShareTransferWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(action)
    send(action)
  end
  
  def share_req
    byebug
    requests = ShareRequest.where(status: 'pending')
    requests.each do |share_request|
      if share_request.created_at < (Time.now - 3.days)
        share_request.update(status: 'rejected')
      else
        render json:{error: "no request pending!"}
      end
    end
    
    # puts 'Hello World!'
    # puts 'share transfer worker!'
  end
  
end