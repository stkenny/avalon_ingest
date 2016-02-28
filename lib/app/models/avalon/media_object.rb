class Avalon::MediaObject < ActiveRecord::Base

  has_many :parts, class_name: 'Avalon::MasterFile'

  def destroy
    self.parts.each(&:destroy)
    self.parts.clear
    super
  end

  def finished_processing?
    self.parts.all?{ |master_file| master_file.finished_processing? }
  end

  def succeeded?
    self.parts.all?{ |master_file| master_file.succeeded? }
  end

  def failed?
    self.parts.any? { |master_file| master_file.failed? }
  end
end
