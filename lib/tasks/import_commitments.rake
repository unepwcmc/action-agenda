require 'csv'

namespace :import do
  desc "import CSV data into database"
  task :commitments, [:csv_file] => [:environment] do |t, args|
    Country.import 
    import_csv_file(args.csv_file)
    puts "local Commitments successfully imported"
    import_from_cbd
    puts "CBD Commitments successfully imported"
  end

  def import_csv_file file
    Commitment.import file
  end


  def self.import_from_cbd
    (1..8).each do |page|
      response = HTTParty.get("https://www.cbd.int/api/v2019/actions?q=%7B%22actionDetails.actionCategories%22%3A%7B%22%24all%22%3A%5B%7B%22identifier%22%3A%22LAND-ECOSYSTEMS%22%7D%5D%7D%7D&sk=#{page}&s=%7B%22meta.modifiedOn%22%3A-1%7D&f=%7B%22actionDetails.actionCategories%22%3A1%2C%22actionDetails.aichiTargets%22%3A1%2C%22actionDetails.sdgs%22%3A1%2C%22actionDetails.thematicAreas%22%3A1%2C%22actionDetails.operationalAreas%22%3A1%2C%22contacts.country.identifier%22%3A1%2C%22meta%22%3A1%2C%22action.name%22%3A1%2C%22action.description%22%3A1%2C%22action.image%22%3A1%7D&l=10")
      
      raw_json = JSON.parse response.body
      raw_json.each do |cbd_com|
        
        cbd_id = cbd_com["_id"]
        cbd_action = cbd_com["action"]
        next if cbd_com.nil?
        country = !cbd_com["contacts"][0]["country"].nil? ? Country.find_by(iso: cbd_com["contacts"][0]["country"]["identifier"].upcase)
                  : Country.find_by(iso: "--")

        aichi_targets = cbd_com["actionDetails"]["aichiTargets"].map{ |at| at["identifier"] }.join(';').downcase
        
        our_com = Commitment.new(name: cbd_action["name"]["en"],
                                 description: cbd_action["description"]["en"],
                                 country_ids: [country.id],
                                 committed_year: cbd_com["meta"]["createdOn"].to_date.year,
                                 related_biodiversity_targets: aichi_targets
                                )
        our_com.links.build(url: "https://www.cbd.int/action-agenda/contributions/action?action-id=#{cbd_id}")
        our_com.save!
        our_com.state = :live
        our_com.save
      end
    end
  end
end
