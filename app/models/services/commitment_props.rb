class Services::CommitmentProps
  include Rails.application.routes.url_helpers

  def initialize(commitment)
    @commitment = commitment
  end

  def call
    {
      config: {
        action: @commitment.new_record? ? '/commitments.json' : "/commitments/#{@commitment.id}.json",
        method: @commitment.new_record? ? 'post' : 'put',
        root_key: 'commitment',
        geospatial_file: @commitment.geospatial_file.attached? ? @commitment.geospatial_file.signed_id : '',
        progress_document_json: @commitment.progress_documents.map do |progress_document|
          {
            id: progress_document.id,
            document: [{ name: progress_document.document.filename, content: rails_blob_path(progress_document.document, only_path: true) }],
            signed_id: progress_document.document.blob.signed_id,
            progress_notes: progress_document.progress_notes
          }
        end,
        links_json: @commitment.links.map do |link|
          {
            id: link.id,
            url: link.url
          }
        end
      },
      errors: @commitment.new_record? ? [] : @commitment.draft_errors,
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
                visibleIf: "false"
              },
              {
                type: 'text',
                name: 'name',
                title: I18n.t('form.commitments.page1.q1.title'),
                description: I18n.t('form.commitments.page1.q1.description'),
                isRequired: true,
                defaultValue: @commitment.name || ''
              },
              {
                type: 'comment',
                name: 'description',
                title: I18n.t('form.commitments.page1.q2.title'),
                defaultValue: @commitment.description || '',
                popupdescription: I18n.t('form.commitments.page1.q2.popupdescription_html')
              },
              {
                type: 'checkbox',
                name: 'objective_ids',
                title: I18n.t('form.commitments.page1.q3.title'),
                description: I18n.t('form.commitments.page1.q3.description'),
                defaultValue: @commitment.objective_ids || [],
                popupdescription: I18n.t('form.commitments.page1.q3.popupdescription_html'),
                choices: Objective.commitment_form_options.pluck(:id, :name).map do |id, name|
                           next unless name != 'None of the above'

                           {
                             value: id,
                             text: name
                           }
                         end.compact
              },
              {
                type: 'checkbox',
                name: 'manager_ids',
                title: I18n.t('form.commitments.page1.q4.title'),
                description: I18n.t('form.commitments.page1.q3.description'),
                defaultValue: @commitment.manager_ids || [],
                popupdescription: I18n.t('form.commitments.page1.q4.popupdescription_html'),
                choices: Manager.commitment_form_options.pluck(:id, :name).map do |id, name|
                           next unless name != 'None of the above'
                           {
                             value: id,
                             text: name
                           }
                         end.compact,
                otherText: I18n.t('form.none')
              },
              {
                type: 'comment',
                name: 'joint_governance_description',
                visibleIf: "{ manager_ids } contains 'Joint governance'",
                title: I18n.t('form.commitments.page1.q5.title'),
                hideNumber: true,
                defaultValue: @commitment.joint_governance_description || ''
              },
              {
                type: 'text',
                name: 'responsible_group',
                title: I18n.t('form.commitments.page1.q6.title'),
                defaultValue: @commitment.responsible_group || '',
                popupdescription: I18n.t('form.commitments.page1.q6.popupdescription_html')
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
                optionsCaption: I18n.t('form.commitments.page2.q1.caption'),
                defaultValue: @commitment.country_ids || []
              },
              {
                type: 'panel',
                name: 'latlong_geospatial_panel',
                elements: [
                  {
                    type: 'expression',
                    name: 'latlong_heading',
                    title: I18n.t('form.commitments.page2.q2.title'),
                    popupdescription: I18n.t('form.commitments.page2.q2.popupdescription_html')
                  },
                  {
                    type: 'text',
                    name: 'latitude',
                    title: I18n.t('form.commitments.page2.q3.title'),
                    titleLocation: 'left',
                    hideNumber: true,
                    defaultValue: @commitment.latitude || ''
                  },
                  {
                    type: 'text',
                    name: 'longitude',
                    title: I18n.t('form.commitments.page2.q4.title'),
                    titleLocation: 'left',
                    hideNumber: true,
                    defaultValue: @commitment.longitude || ''
                  },
                  {
                    type: 'file',
                    name: 'geospatial_file',
                    title: I18n.t('form.commitments.page2.q5.title'),
                    description: I18n.t('form.commitments.page2.q5.description'),
                    hideNumber: true,
                    storeDataAsText: false,
                    allowImagesPreview: false,
                    maxSize: 26_214_400,
                    acceptedTypes: '.zip,.kml,.kml+xml',
                    popupdescription: I18n.t('form.commitments.page2.q5.popupdescription_html'),
                    defaultValue: @commitment.geospatial_file.attached? ? [{name: @commitment.geospatial_file.filename, type: @commitment.geospatial_file.content_type }] : [],
                  }
                ]
              },
              {
                type: 'panel',
                name: 'current_area_ha_panel',
                elements: [
                  {
                    type: 'expression',
                    name: 'current_area_ha_heading',
                    title: I18n.t('form.commitments.page2.q6.title'),
                    popupdescription: I18n.t('form.commitments.page2.q6.popupdescription_html')
                  },
                  {
                    type: 'text',
                    name: 'current_area_ha',
                    title: I18n.t('form.commitments.page2.q7.title'),
                    titleLocation: 'left',
                    hideNumber: true,
                    defaultValue: @commitment.current_area_ha || ''
                  }
                ]
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
                defaultValue: @commitment.committed_year || '',
                choices: (2012..Date.today.year).to_a.reverse,
                optionsCaption: I18n.t('form.commitments.page3.q1.caption'),
                popupdescription: I18n.t('form.commitments.page3.q1.popupdescription_html')
              },
              {
                type: 'dropdown',
                name: 'duration_years',
                title: I18n.t('form.commitments.page3.q2.title'),
                defaultValue: @commitment.duration_years || '',
                choices: (5..15).to_a,
                optionsCaption: I18n.t('form.commitments.page3.q2.caption'),
                popupdescription: I18n.t('form.commitments.page3.q2.popupdescription_html')
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
                defaultValue: @commitment.stage || [],
                choices: ['Committed', 'In progress', 'Implemented'],
                popupdescription: I18n.t('form.commitments.page4.q1.popupdescription_html')
              },
              {
                type: 'checkbox',
                name: 'action_ids',
                title: I18n.t('form.commitments.page4.q2.title'),
                description: I18n.t('form.commitments.page4.q2.description'),
                defaultValue: @commitment.action_ids || [],
                popupdescription: I18n.t('form.commitments.page4.q2.popupdescription_html'),
                choices: Action.commitment_form_options.pluck(:id, :name).map do |id, name|
                           next unless name != 'None of the above'

                           {
                             value: id,
                             text: name
                           }
                         end.compact,
                otherText: 'Other'
              },
              {
                type: 'dropdown',
                name: 'implementation_year',
                title: I18n.t('form.commitments.page4.q3.title'),
                defaultValue: @commitment.implementation_year || '',
                choices: (2012..Date.today.year).to_a.reverse,
                popupdescription: I18n.t('form.commitments.page4.q3.popupdescription_html')
              },
              {
                type: 'checkbox',
                name: 'threat_ids',
                title: I18n.t('form.commitments.page4.q4.title'),
                description: I18n.t('form.commitments.page4.q4.description'),
                defaultValue: @commitment.threat_ids || [],
                popupdescription: I18n.t('form.commitments.page4.q4.popupdescription_html'),
                choices: Threat.commitment_form_options.pluck(:id, :name).map do |id, name|
                           next unless name != 'None of the above'

                           {
                             value: id,
                             text: name
                           }
                         end.compact
              },
              {
                type: 'paneldynamic',
                name: 'links_attributes',
                title: I18n.t('form.commitments.page4.q5.title'),
                description: I18n.t('form.commitments.page4.q5.description'),
                templateElements: [
                  {
                    type: 'text',
                    title: 'hidden field',
                    name: 'id',
                    # a bit of a hacky way to make it work
                    visibleIf: "false"
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
                popupdescription: I18n.t('form.commitments.page5.q1.popupdescription_html'),
                templateElements: [
                  {
                    type: 'text',
                    title: 'hidden field',
                    name: 'id',
                    # a bit of a hacky way to make it work
                    visibleIf: "false"
                  },
                  {
                    type: 'file',
                    name: 'document',
                    titleLocation: 'hidden',
                    allowImagesPreview: false,
                    storeDataAsText: false,
                    maxSize: 26_214_400,
                    acceptedTypes: '.doc,.docx,.pdf'
                  },
                  {
                    type: 'comment',
                    name: 'progress_notes',
                    title: 'Option to include progress notes',
                    description: '(Optional field)'
                  }
                ],
                minPanelCount: 1,
                confirmDelete: true,
                confirmDeleteText: I18n.t('form.commitments.page5.q1.delete'),
                panelAddText: I18n.t('form.commitments.page5.q1.add')
              }
            ]
          }
        ]
      }
    }
  end
end
