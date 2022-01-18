class Services::CriteriumProps
  def initialize(criterium)
    @criterium = criterium
  end

  def call
    {
      progressBarType: 'buttons',
      showProgressBar: 'top',
      completeText: 'Submit',
      requiredText: '',
      title: I18n.t('form.criteria.title'),
      description: I18n.t('form.criteria.description'),
      pages: [
        {
          navigationTitle: 'criteria',
          elements: [
            {
              type: 'radiogroup',
              name: 'boundary',
              title: I18n.t('form.criteria.q1.label'),
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
              title: I18n.t('form.criteria.q2.label'),
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
              title: I18n.t('form.criteria.q3.label'),
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
              title: I18n.t('form.criteria.q4.label'),
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
              ],
              colCount: 2
            },
            {
              type: 'radiogroup',
              name: 'progress_report',
              title: I18n.t('form.criteria.q5.label'),
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
              ],
              colCount: 2
            }
          ]
        }
      ]
    }
  end
end
