class Services::CriteriumProps
  def initialize(criterium)
    @criterium = criterium
  end

  def call
    {
      config:
      {
        action: '/criteria.json',
        method: 'post',
        root_key: 'criterium'
      },
      survey:
      {
        completeText: 'Submit',
        requiredText: '',
        title: I18n.t('form.criteria.title'),
        description: I18n.t('form.criteria.description'),
        pages: [
          {
            elements: [
              {
                type: 'radiogroup',
                name: 'boundary',
                title: I18n.t('form.criteria.q1.label'),
                isRequired: true,
                choices: [
                  {
                    value: 'true',
                    text: I18n.t('form.criteria.q1.t')
                  },
                  {
                    value: 'false',
                    text: I18n.t('form.criteria.q1.f')
                  }
                ]
              },
              {
                type: 'checkbox',
                name: 'cbd_objective_ids',
                title: I18n.t('form.criteria.q2.label'),
                isRequired: true,
                choices: CbdObjective.pluck(:id, :name).map do |id, name|
                          if name != 'None of the above'
                            {
                              value: id,
                              text: name
                            }
                          else
                            nil
                          end
                         end.compact,
                hasNone: true,
                noneText: I18n.t('form.criteria.none')
              },
              {
                type: 'checkbox',
                name: 'stakeholder_ids',
                title: I18n.t('form.criteria.q3.label'),
                isRequired: true,
                choices: Stakeholder.pluck(:id, :name).map do |id, name|
                          if name != 'None of the above'
                            {
                              value: id,
                              text: name
                            }
                          else
                            nil
                          end
                         end.compact,
                hasNone: true,
                noneText: I18n.t('form.criteria.none')
              },
              {
                type: 'radiogroup',
                name: 'five_year_commitment',
                title: I18n.t('form.criteria.q4.label'),
                isRequired: true,
                choices: [
                  {
                    value: 'true',
                    text: I18n.t('form.criteria.q4.t')
                  },
                  {
                    value: 'false',
                    text: I18n.t('form.criteria.q4.f')
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
                    text: I18n.t('form.criteria.q5.t')
                  },
                  {
                    value: 'false',
                    text: I18n.t('form.criteria.q5.f')
                  }
                ],
                colCount: 2
              }
            ]
          }
        ]
      }
    }
  end
end
