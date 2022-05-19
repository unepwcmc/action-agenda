class CbdImportJob < ApplicationJob
  discard_on StandardError

  queue_as :imports

  def perform
    Services::CbdImporter.new.call
  end
end
