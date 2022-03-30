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
                name: 'manager_ids',
                title: I18n.t('form.criteria.q3.title'),
                description: I18n.t('form.criteria.q3.description'),
                isRequired: true,
                popupdescription: I18n.t('form.criteria.q3.popupdescription_html'),
                choices: Manager.commitment_form_options.pluck(:id, :name).map do |id, name|
                          if name != 'Other'
                            {
                              # Hacky. Client has asked to now only have one manager type per commitment via the form
                              # This submits a single id as an array so the current has_and_belongs_to_many relationship still works.
                              # We have one commitment in the csv import that has two manager types
                              # We don't know what the CBD import data looks like for managers
                              # I would suggest leaving this until we know the CBD data structure for managers
                              # TO DO: make commitment belong_to manager if this matched the CBD data
                              value: [id],
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
