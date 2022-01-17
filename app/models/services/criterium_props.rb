class Services::CriteriumProps
  def initialize(criterium)
    @criterium = criterium
  end

  def call
    {
      pages: [
        {
          navigationTitle: 'criteria',
          elements: [
            {
              type: 'radiogroup',
              name: 'boundary',
              title: 'Does/will the area have a clearly-defined boundary?',
              isRequired: true,
              choices: [
                {
                  value: 'true',
                  text:
                    'The area has, or will have, a clearly defined boundary'
                },
                {
                  value: 'false',
                  text:
                    'The area does not and will not have a clearly defined boundary'
                }
              ]
            },
            {
              type: 'checkbox',
              name: 'cbd_objectives',
              title:
                'Please select the objectives of the Convention on Biological Diversity that your commitment contributes to',
              isRequired: true,
              choices: [
                'Conservation of biological diversity',
                'Sustainable use',
                'Fair and equitable sharing of benefits from the utilization of genetic resources'
              ],
              hasNone: true,
              noneText: 'None of the above'
            },
            {
              type: 'checkbox',
              name: 'stakeholders',
              title: 'Who is making the commitment?',
              isRequired: true,
              choices: [
                'Local communities',
                'Indigenous peoples',
                'Non-governmental organization (NGO)',
                'Private sector (business and industry)',
                'Sub-national or local government'
              ],
              hasNone: true,
              noneText: 'None of the above'
            },
            {
              type: 'radiogroup',
              name: 'five_year_commitment',
              title: 'Is the duration of the commitment at least 5 years?',
              isRequired: true,
              choices: [
                {
                  value: 'true',
                  text: 'Yes'
                },
                {
                  value: 'false',
                  text: 'No'
                }
              ]
            },
            {
              type: 'radiogroup',
              name: 'progress_report',
              title:
                'Are you able to submit annual progress reports to this platform?',
              isRequired: true,
              choices: [
                {
                  value: 'true',
                  text: 'Yes'
                },
                {
                  value: 'false',
                  text: 'No'
                }
              ]
            }
          ]
        },
        {
          navigationTitle: 'Commitment form',
          elements: [
            {
              type: 'radiogroup',
              name: 'question4',
              choices: %w[
                item1
                item2
                item3
              ]
            }
          ]
        }
      ],
      progressBarType: "buttons",
      showProgressBar: "top",
      completeText: 'Submit',
      requiredText: ''
    }
  end
end
