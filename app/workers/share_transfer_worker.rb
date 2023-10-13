class ShareTransferWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform
    models = ["ShareRequest", "SongRequest"]
    models.each do |model|
      model_class = model.constantize
      pending_requests = model_class.where(status: 'pending')
      # pending_requests = ShareRequest.where(status: 'pending')
      if pending_requests.present?
        pending_requests.each do |share_request|
          if share_request.created_at < 3.days.ago
            share_request.update(status: 'closed')
          end
        end
      end
    end
  end
  
end