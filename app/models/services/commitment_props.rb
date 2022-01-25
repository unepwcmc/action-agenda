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
        root_key: 'commitment',
        hidden_field: @commitment.criterium_id
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
                choices: [
                  'Sustainable use',
                  'Biodiversity conservation',
                  'Equitable sharing of benefits from the use of genetic resources',
                  'Restoration',
                  'Climate change adaptation and mitigation',
                  'Preservation of cultural values',
                  'Preservation of spiritual values',
                  'Preservation of traditional livelihoods',
                  'Certification of products',
                  'Recreation',
                  'Academic research'
                ]
              },
              {
                type: 'checkbox',
                name: 'managerIds',
                title: I18n.t('form.commitments.page1.q4.title'),
                description: I18n.t('form.commitments.page1.q3.description'),
                # defaultValue: [],
                choices: [
                  'Indigenous peoples',
                  'Local communities',
                  'For-profit organisations',
                  'Non-profit organisations',
                  'Individual landowners',
                  'Collaborative governance',
                  'Joint governance',
                  'Sub-national ministry or agency',
                  'Other'
                ],
                otherText: I18n.t('form.none')
              },
              {
                type: 'comment',
                name: 'jointGovernanceType',
                visibleIf: "{ managerIds } contains 'Joint governance'",
                title: I18n.t('form.commitments.page1.q5.title'),
                hideNumber: true
              },
              {
                type: 'text',
                name: 'responsibleGroup',
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
                name: 'geospatialFile',
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
                name: 'committedYear',
                title: I18n.t('form.commitments.page3.q1.title'),
                # defaultValue: [],
                choices: (2012..Date.today.year).to_a.reverse,
                optionsCaption: I18n.t('form.commitments.page3.q1.caption')
              },
              {
                type: 'dropdown',
                name: 'duration',
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
                name: 'actionIds',
                title: I18n.t('form.commitments.page4.q2.title'),
                description: I18n.t('form.commitments.page4.q2.description'),
                # defaultValue: [],
                choices: [
                  'Land/water protection',
                  'Land/water management',
                  'Species management',
                  'Education & awareness',
                  'Law & policy',
                  'Livelihood, economic & other incentives',
                  'Other'
                ],
                otherText: 'Other'
              },
              {
                type: 'dropdown',
                name: 'implementationYear',
                title: I18n.t('form.commitments.page4.q3.title'),
                # defaultValue: [],
                choices: (2012..Date.today.year).to_a.reverse
              },
              {
                type: 'checkbox',
                name: 'threatIds',
                title: I18n.t('form.commitments.page4.q4.title'),
                description: I18n.t('form.commitments.page4.q4.description'),
                # defaultValue: [],
                choices: [
                  'Residential & commercial development',
                  'Agriculture & aquaculture',
                  'Energy production & mining',
                  'Transportation & service corridors',
                  'Biological resource use',
                  'Human intrusions & disturbance',
                  'Natural system modifications',
                  'Invasive & other problematic species, genes & diseases',
                  'Pollution',
                  'Geological events',
                  'Climate change & severe weather',
                  'Other'
                ]
              },
              {
                type: 'paneldynamic',
                name: 'linksAttributes',
                title: I18n.t('form.commitments.page4.q5.title'),
                description: I18n.t('form.commitments.page4.q4.description'),
                templateElements: [
                  {
                    type: 'text',
                    name: 'linkName',
                    titleLocation: 'hidden',
                    placeHolder: 'Website name'
                  },
                  {
                    type: 'text',
                    name: 'linkUrl',
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
            elements: [
              {
                type: 'paneldynamic',
                name: 'progressItems',
                title: I18n.t('form.commitments.page5.q1.title'),
                description: I18n.t('form.commitments.page5.q1.description'),
                templateElements: [
                  {
                    type: 'file',
                    name: 'progressItemFilename',
                    titleLocation: 'hidden',
                    maxSize: 26_214_400
                  },
                  {
                    type: 'comment',
                    name: 'progressNotes',
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
            title: 'Progress'
          }
        ]
      }
    }
  end
end
