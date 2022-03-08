require 'csv'

class Parser
  # each row
  # extract to arrays of lat and lon
  # get mean for each
  # export as csv with country code, lat and lon
  def parse
    csv_file = "#{Rails.root}/lib/data/seeds/new_countries.csv"
    CSV.foreach(csv_file, headers: true) do |row, row_number|
      byebug
    end
  end
end