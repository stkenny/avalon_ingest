class Avalon::MasterFile < ActiveRecord::Base
  belongs_to :media_object, class_name: 'Avalon::MediaObject'

  END_STATES = ['CANCELLED', 'COMPLETED', 'FAILED']

  def set_content(file)
    case file
    when Hash #Multiple files for pre-transcoded derivatives
      save_original( (file.has_key?('quality-high') && File.file?( file['quality-high'] )) ? file['quality-high'] : (file.has_key?('quality-medium') && File.file?( file['quality-medium'] )) ? file['quality-medium'] : file.values[0] )
      file.each_value {|f| f.close unless f.closed? }
    when ActionDispatch::Http::UploadedFile #Web upload
      save_original(file, file.original_filename)
    else #Batch or dropbox
      save_original(file)
    end
  end

  def process file=nil
    raise "MasterFile is already being processed" if status_code.present? && !finished_processing?
  end

  def status?(value)
    status_code == value
  end

  def failed?
    status?('FAILED')
  end

  def succeeded?
    status?('COMPLETED')
  end

  def finished_processing?
    END_STATES.include?(status_code)
  end

  def save_original(file, original_name=nil)
  end

end
