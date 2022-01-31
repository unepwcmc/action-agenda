class Services::CommitmentProps  
  def initialize(commitment)
    @commitment = commitment
  end

  def call
    {
      config:
      {
        action: @commitment.new_record? ? '/commitments.json' : "/commitments/#{@commitment.id}.json",
        method: @commitment.new_record? ? 'post' : 'put',
        root_key: 'commitment'
      },
      survey: {
        progressBarType: 'buttons',
        requiredText: '',
        showNavigationButtons: 'none',
        showPrevButton: false,
        showProgressBar: 'top',
        showQuestionNumbers: 'onPage',
        pages: [
          {
            name: I18n.t('form.commitments.page1.name'),
            title: I18n.t('form.commitments.page1.title'),
            description: I18n.t('form.commitments.page1.description'),
            elements: [
              {
                type: 'text',
                title: 'hidden field',
                name: 'criterium_id',
                defaultValue: @commitment.criterium_id,
                # a bit of a hacky way to make it work
                visibleIf: "{ criterium_id } contains '-1'"
              },
              {
                type: 'text',
                name: 'name',
                title: I18n.t('form.commitments.page1.q1.title'),
                description: I18n.t('form.commitments.page1.q1.description'),
                isRequired: true
              },
              {
                type: 'comment',
                name: 'description',
                title: I18n.t('form.commitments.page1.q2.title')
              },
              {
                type: 'checkbox',
                name: 'objective_ids',
                title: I18n.t('form.commitments.page1.q3.title'),
                description: I18n.t('form.commitments.page1.q3.description'),
                # defaultValue: [],
                choices: Objective.commitment_form_options.pluck(:id, :name).map do |id, name|
                          if name != 'None of the above'
                            {
                              value: id,
                              text: name
                            }
                          else
                            nil
                          end
                         end.compact,
              },
              {
                type: 'checkbox',
                name: 'manager_ids',
                title: I18n.t('form.commitments.page1.q4.title'),
                description: I18n.t('form.commitments.page1.q3.description'),
                # defaultValue: [],
                choices: Manager.commitment_form_options.pluck(:id, :name).map do |id, name|
                          if name != 'None of the above'
                            {
                              value: id,
                              text: name
                            }
                          else
                            nil
                          end
                         end.compact,
                otherText: I18n.t('form.none')
              },
              {
                type: 'comment',
                name: 'joint_governance_description',
                visibleIf: "{ manager_ids } contains 'Joint governance'",
                title: I18n.t('form.commitments.page1.q5.title'),
                hideNumber: true
              },
              {
                type: 'text',
                name: 'responsible_group',
                title: I18n.t('form.commitments.page1.q6.title')
              }
            ]
          },
          {
            name: I18n.t('form.commitments.page2.name'),
            title: 'Location',
            elements: [
              # currently not working
              {
                type: 'tagbox',
                name: 'country_ids',
                title: I18n.t('form.commitments.page2.q1.title'),
                description: I18n.t('form.commitments.page2.q1.description'),
                choices: Country.pluck(:id, :name).map do |id, name|
                           {
                             value: id,
                             text: name
                           }
                         end,
                optionsCaption: I18n.t('form.commitments.page2.q1.caption')
              },
              {
                type: 'expression',
                name: 'latlongHeading',
                title: I18n.t('form.commitments.page2.q2.title')
              },
              {
                type: 'text',
                name: 'latitude',
                title: I18n.t('form.commitments.page2.q3.title'),
                titleLocation: 'left',
                hideNumber: true
              },
              {
                type: 'text',
                name: 'longitude',
                title: I18n.t('form.commitments.page2.q4.title'),
                titleLocation: 'left',
                hideNumber: true
              },
              {
                type: 'file',
                name: 'geospatial_file',
                title: I18n.t('form.commitments.page2.q5.title'),
                description: I18n.t('form.commitments.page2.q5.tdescription'),
                hideNumber: true,
                allowImagesPreview: false,
                maxSize: 26_214_400
              },
              {
                type: 'text',
                name: 'current_area_ha',
                title: I18n.t('form.commitments.page2.q6.title')
              }
            ]
          },
          {
            name: I18n.t('form.commitments.page3.name'),
            elements: [
              {
                type: 'dropdown',
                name: 'committed_year',
                title: I18n.t('form.commitments.page3.q1.title'),
                # defaultValue: [],
                choices: (2012..Date.today.year).to_a.reverse,
                optionsCaption: I18n.t('form.commitments.page3.q1.caption')
              },
              {
                type: 'dropdown',
                name: 'duration_years',
                title: I18n.t('form.commitments.page3.q2.title'),
                # defaultValue: [],
                choices: (5..15).to_a,
                optionsCaption: I18n.t('form.commitments.page3.q2.caption')
              }
            ],
            title: 'Duration'
          },
          {
            name: I18n.t('form.commitments.page4.name'),
            title: 'Stage',
            elements: [
              {
                type: 'radiogroup',
                name: 'stage',
                title: I18n.t('form.commitments.page4.q1.title'),
                # defaultValue: [],
                choices: ['Committed', 'In progress', 'Implemented']
              },
              {
                type: 'checkbox',
                name: 'action_ids',
                title: I18n.t('form.commitments.page4.q2.title'),
                description: I18n.t('form.commitments.page4.q2.description'),
                # defaultValue: [],
                choices: Action.commitment_form_options.pluck(:id, :name).map do |id, name|
                          if name != 'None of the above'
                            {
                              value: id,
                              text: name
                            }
                          else
                            nil
                          end
                         end.compact,
                otherText: 'Other'
              },
              {
                type: 'dropdown',
                name: 'implementation_year',
                title: I18n.t('form.commitments.page4.q3.title'),
                # defaultValue: [],
                choices: (2012..Date.today.year).to_a.reverse
              },
              {
                type: 'checkbox',
                name: 'threat_ids',
                title: I18n.t('form.commitments.page4.q4.title'),
                description: I18n.t('form.commitments.page4.q4.description'),
                # defaultValue: [],
                choices: Threat.commitment_form_options.pluck(:id, :name).map do |id, name|
                          if name != 'None of the above'
                            {
                              value: id,
                              text: name
                            }
                          else
                            nil
                          end
                         end.compact,
              },
              {
                type: 'paneldynamic',
                name: 'links_attributes',
                title: I18n.t('form.commitments.page4.q5.title'),
                description: I18n.t('form.commitments.page4.q4.description'),
                templateElements: [
                  {
                    type: 'text',
                    name: 'name',
                    titleLocation: 'hidden',
                    placeHolder: 'Website name'
                  },
                  {
                    type: 'text',
                    name: 'url',
                    titleLocation: 'hidden',
                    placeHolder: 'https://www.example.com'
                  }
                ],
                panelCount: 1,
                confirmDelete: true,
                confirmDeleteText: I18n.t('form.commitments.page4.q5.delete'),
                panelAddText: I18n.t('form.commitments.page4.q5.add')
              }
            ]
          },
          {
            name: I18n.t('form.commitments.page5.name'),
            title: 'Progress',
            elements: [
              {
                type: 'paneldynamic',
                name: 'progress_documents_attributes',
                title: I18n.t('form.commitments.page5.q1.title'),
                description: I18n.t('form.commitments.page5.q1.description'),
                templateElements: [
                  {
                    type: 'file',
                    name: 'document',
                    titleLocation: 'hidden',
                    maxSize: 26_214_400
                  },
                  {
                    type: 'comment',
                    name: 'progress_notes',
                    title: 'Option to include progress notes',
                    description: '(Optional field)'
                  }
                ],
                panelCount: 1,
                confirmDelete: true,
                confirmDeleteText: I18n.t('form.commitments.page5.q1.delete'),
                panelAddText: I18n.t('form.commitments.page5.q1.add')
              }
            ],
          }
        ]
      }
    }
  end
end
