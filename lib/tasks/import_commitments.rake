require 'csv'

namespace :import do
  desc "import CSV data into database"
  task :commitments, [:csv_file] => [:environment] do |t, args|
    import_csv_file(args.csv_file)
    puts "Commitments successfully imported"
  end

  def import_csv_file file
    Commitment.import file, 'utf-8'
  end
end
