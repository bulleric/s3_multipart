module S3Multipart
  class Upload 
    include Mongoid::Document
    extend S3Multipart::TransferHelpers

    field :key, type: String
    field :upload_id, type: String
    field :name, type: String
    field :location, type: String
    field :uploader, type: String

    attr_accessible :key, :upload_id, :name, :location, :uploader

    def execute_callback(stage, session)
      controller = S3Multipart::Uploader.deserialize(uploader)

      case stage
      when :begin
        controller.on_begin_callback.call(self, session)
      when :complete
        controller.on_complete_callback.call(self, session)
      end
    end

  end
end
