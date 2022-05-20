require 'csv'

namespace :import do
  desc "import CSV data into database"
  task :commitments, [:csv_file] => [:environment] do |t, args|
    Country.import
    Rake::Task['add_country_boundaries'].invoke
    import_csv_file(args.csv_file)
    puts "local Commitments successfully imported"
    Services::CbdImporter.new.call
    puts "CBD Commitments successfully imported"
  end

  def import_csv_file file
    Commitment.import file
  end
end
