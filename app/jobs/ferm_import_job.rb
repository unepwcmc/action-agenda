class FermImportJob < ApplicationJob
  queue_as :import

  def perform
    Services::FermImporter.new.call
  end
end
