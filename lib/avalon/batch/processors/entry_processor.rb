module Avalon
  module Batch
    module Processors
      class EntryProcessor < Entry

        def media_object
          @media_object ||= MediaObject.new(avalon_uploader: @manifest.package.user.user_key, 
                                            collection: @manifest.package.collection).tap do |mo|
            mo.workflow.origin = 'batch'
            if Avalon::BibRetriever.configured? and fields[:bibliographic_id].present?
              begin
                mo.descMetadata.populate_from_catalog!(fields[:bibliographic_id].first, Array(fields[:bibliographic_id_label]).first)
              rescue Exception => e
                @errors.add(:bibliographic_id, e.message)
              end
            else
              mo.update_datastream(:descMetadata, fields.dup)
            end
          end
          @media_object
        end

        def process!(opts={})
          media_object.save

          @files.each do |file_spec|
            master_file = MasterFile.new
            master_file.save(validate: false) #required: need pid before setting mediaobject
            master_file.mediaobject = media_object
            files = self.class.gatherFiles(file_spec[:file])
            self.class.attach_structure_to_master_file(master_file, file_spec[:file])
            master_file.setContent(files)
            master_file.absolute_location = file_spec[:absolute_location] if file_spec[:absolute_location].present?
            master_file.label = file_spec[:label] if file_spec[:label].present?
            master_file.poster_offset = file_spec[:offset] if file_spec[:offset].present?
         
            #Make sure to set content before setting the workflow 
            master_file.set_workflow(file_spec[:skip_transcoding] ? 'skip_transcoding' : nil)
            if master_file.save
              media_object.save(validate: false)
              master_file.process(files)
            else
              logger.error "Problem saving MasterFile(#{master_file.pid}): #{master_file.errors.full_messages.to_sentence}"
            end
          end
          context = {media_object: { pid: media_object.pid, access: 'private' }, mediaobject: media_object, user: @manifest.package.user.user_key, hidden: opts[:hidden] ? '1' : nil }
          HYDRANT_STEPS.get_step('access-control').execute context
          media_object.workflow.last_completed_step = 'access-control'

          if opts[:publish]
            media_object.publish!(@manifest.package.user.user_key)
            media_object.workflow.publish
          end

          unless media_object.save
            logger.error "Problem saving MediaObject: #{media_object}"
          end

          media_object
        end
      end
    end
  end
end


        
