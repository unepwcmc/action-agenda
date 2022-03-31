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
        showNavigationButtons: 'none',
        title: I18n.t('form.criteria.title'),
        description: I18n.t('form.criteria.description'),
        pages: [
          {
            elements: [
              {
                type: 'radiogroup',
                name: 'boundary',
                title: I18n.t('form.criteria.q1.title'),
                isRequired: true,
                popupdescription: I18n.t('form.criteria.q1.popupdescription_html'),
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
                title: I18n.t('form.criteria.q2.title'),
                description: I18n.t('form.criteria.q2.description'),
                isRequired: true,
                popupdescription: I18n.t('form.criteria.q2.popupdescription_html'),
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
                noneText: I18n.t('form.none')
              },
              {
                type: 'radiogroup',
                name: 'manager_id',
                title: I18n.t('form.criteria.q3.title'),
                isRequired: true,
                popupdescription: I18n.t('form.criteria.q3.popupdescription_html'),
                choices: Manager.form_options.pluck(:id, :name).map do |id, name|
                            {
                              value: id,
                              text: name
                            }
                         end
              },
              {
                type: 'radiogroup',
                name: 'five_year_commitment',
                title: I18n.t('form.criteria.q4.title'),
                isRequired: true,
                popupdescription: I18n.t('form.criteria.q4.popupdescription_html'),
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
                title: I18n.t('form.criteria.q5.title'),
                isRequired: true,
                popupdescription: I18n.t('form.criteria.q5.popupdescription_html'),
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
