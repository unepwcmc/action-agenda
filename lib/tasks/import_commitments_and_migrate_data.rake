desc 'import commitments and migrate data'
task import_commitments_and_migrate_data: :environment do
  Rake::Task['import:commitments'].invoke("#{Rails.root}/lib/data/seeds/commitments.csv")
  Rake::Task['migrate_data:add_commitment_country_to_commitment_countries'].invoke
  Rake::Task['migrate_data:add_commitment_link_to_commitment_links'].invoke
  Rake::Task['migrate_data:set_existing_commitments_to_live'].invoke
  Rake::Task['add_country_boundaries'].invoke
end