class CbdImportJob < ApplicationJob
  queue_as :import

  def perform
    Services::CbdImporter.new.call
  end
end
