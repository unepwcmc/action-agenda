# frozen_string_literal: true

desc 'Clean up orphaned ActiveStorage files'
task active_storage_clean_up: :environment do
  ActiveStorage::Blob.unattached.each(&:purge_later)
end
