require 'test_helper'

class CbdCommitmentHashTest < ActiveSupport::TestCase
  test "builds valid params" do
    cbd_commitment_json = {
      "_id"=>"60a7c036f8d89100011ef313",
      "action"=>{
        "name"=>{
          "en"=>"Action for Bioculture and Its Diversity",
          "zh"=>"生物文化行动及其多样性"
        },
        "description"=>{
          "en"=>"Himalayan Folklore, Indigenous Knowledge and Peoples Networks, Federation of Kirant Indigenous Associations, Society for Wetland Biodiversity Conservation Nepal would like to express its commitment on biodiversity and biosafety to the agenda action through stepping up and bringing the collective commitment on biocultural diversity indications, wisdom, values expression of indigenous be harmony with Mother Nature and Earth.  \n\nWe indigenous peoples and local communities, including women and youth, will lobby and advocate for biocultural diversity, values and the importance of indicators to the post-2020 global biodiversity framework, to be adopted at UNCBD COP15, and 2050 vision Living in Harmony with Nature. We will promote communication, education and public awareness of the road maps and spirits of the Convention and its provisions, network with allies, such as other IPLCs and their organizations, for better understanding of the Convention on Biological Diversity and its Protocols. \n",
          "zh"=>"喜马拉雅民间传说、土著知识和人民网络、基兰特土著协会联合会、湿地生物多样性保护协会尼泊尔希望通过加紧并带来对生物文化多样性指示、智慧、土著人的价值观表达是与大自然母亲和地球和谐相处。 \n\n我们土著人民和当地社区，包括妇女和青年，将游说和倡导生物文化多样性、价值观和指标对 2020 年后全球生物多样性框架的重要性，该框架将在 UNCBD COP15 和 2050 年愿景中通过与自然和谐相处。我们将促进对《公约》及其条款的路线图和精神的传播、教育和公众意识，与其他 IPLC 及其组织等盟友建立联系，以更好地了解《生物多样性公约》及其议定书。"
        }
      },
      "actionDetails"=>{
        "sdgs"=>[
          {
            "identifier"=>"SDG-GOAL-02"
          }
        ],
        "thematicAreas"=>[
          {
            "identifier"=>"CBD-SUBJECT-ILC"
          }
        ],
        "operationalAreas"=>[
          {
            "identifier"=>"np"
          }
        ],
        "actionCategories"=>[
          {
            "identifier"=>"LAND-ECOSYSTEMS"
          }
        ]
      },
      "contacts"=>[
        {}
      ],
      "meta"=>{
        "modifiedBy"=>1,
        "createdBy"=>1,
        "modifiedOn"=>"2022-05-21T14:14:13.913Z",
        "createdOn"=>"2022-05-21T14:14:13.913Z",
        "version"=>1,
        "status"=>"published"
      }
    }
    commitment = Commitment.new
    commitment_params = Services::CbdCommitmentHash.new(cbd_commitment_json, commitment).call
    commitment.assign_attributes(commitment_params)
    commitment.save!
    commitment.reload

    assert commitment.name == cbd_commitment_json.dig('action', 'name', 'en')
    assert commitment.description == cbd_commitment_json.dig('action', 'description', 'en')
    assert commitment.cbd_id == cbd_commitment_json.dig('_id')
    assert commitment.countries.first.iso == '--'
    assert commitment.links.first.url == "https://www.cbd.int/action-agenda/contributions/action?action-id=#{cbd_commitment_json.dig('_id')}"
  end
end
