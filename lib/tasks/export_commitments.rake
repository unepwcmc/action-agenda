namespace :export do
  desc "export commitements data"
  task :published_commitments => [:environment] do
    results = Commitment.published.where(commitment_source: %w[csv form])
              .eager_load(:managers,
                           :actions,
                           :countries,
                           :user,
                           :objectives,
                           :threats,
                           :links).as_json(
                             only: %i[
                               id
                               area_owner_and_role
                               committed_year
                               current_area_ha
                               description
                               duration_years
                               geospatial_file
                               implementation_year
                               latitude
                               longitude
                               name
                               responsible_group
                               stage
                               created_at
                               updated_at
                             ],
                             include: {
                               managers: { only: %i[id name] },
                               actions: { only: %i[id name] },
                               countries: { only: %i[id name iso] },
                               user: { only: %i[id email] },
                               objectives: { only: %i[id name] },
                               threats: { only: %i[id name] },
                               links: { only: %i[id url] }
                             }
                           )
    f = File.new('/home/luca/Projects/action-agenda/commitments.txt', 'w')
    f << JSON.pretty_generate(results)
    f.close
  end
end
