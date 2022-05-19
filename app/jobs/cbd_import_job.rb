class CbdImportJob < ApplicationJob
  discard_on StandardError

  queue_as :default

  def perform
    Services::CbdImporter.new.call
  end
end
