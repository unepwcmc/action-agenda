class CbdImportJob < ApplicationJob
  queue_as :imports

  def perform
    Services::CbdImporter.new.call
  end
end
