class Services::CommitmentProps
  include Rails.application.routes.url_helpers

  def initialize(commitment, form_option_text_service = Services::FormOptionText.new)
    @commitment = commitment
    @form_option_text_service = form_option_text_service
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
            document: [{ name: progress_document.document.filename,
                         content: rails_blob_path(progress_document.document, only_path: true) }],
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
                visibleIf: 'false'
              },
              {
                type: 'text',
                name: 'name',
                title: I18n.t('form.commitments.page1.q1.title'),
                description: I18n.t('form.commitments.page1.q1.description'),
                isRequired: true,
                popupdescription: I18n.t('form.commitments.page1.q1.popupdescription_html'),
                defaultValue: @commitment.name || '',
                validators: [
                  { 
                    type: 'regex',
                    text: I18n.t('form.commitments.page1.q1.validation'),  
                    regex: regex_10_word_maximum
                  }
                ]
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
                           {
                             value: id,
                             text: @form_option_text_service.call(name, 'objective')
                           }
                         end.compact
              },
              {
                type: 'text',
                name: 'responsible_group',
                title: I18n.t('form.commitments.page1.q4.title'),
                defaultValue: @commitment.responsible_group || '',
                popupdescription: I18n.t('form.commitments.page1.q4.popupdescription_html')
              }
            ]
          },
          {
            name: I18n.t('form.commitments.page2.name'),
            title: 'Location',
            description: I18n.t('form.commitments.page2.description'),
            elements: [
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
                    placeHolder: '00.00000000',
                    hideNumber: true,
                    defaultValue: @commitment.latitude || '',
                    validators: [
                      { 
                        type: 'regex',
                        text: I18n.t('form.commitments.page2.q3.validation'),  
                        regex: regex_latitude
                      }
                    ]
                  },
                  {
                    type: 'text',
                    name: 'longitude',
                    title: I18n.t('form.commitments.page2.q4.title'),
                    titleLocation: 'left',
                    placeHolder: '00.00000000',
                    hideNumber: true,
                    defaultValue: @commitment.longitude || '',
                    validators: [
                      { 
                        type: 'regex',
                        text: I18n.t('form.commitments.page2.q4.validation'),  
                        regex: regex_longitude
                      }
                    ]
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
                    acceptedTypes: '.zip,.kml,.kml+xml,.xx',
                    popupdescription: I18n.t('form.commitments.page2.q5.popupdescription_html'),
                    defaultValue: if @commitment.geospatial_file.attached?
                                    [{ name: @commitment.geospatial_file.filename,
                                       type: @commitment.geospatial_file.content_type }]
                                  else
                                    []
                                  end
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
              },
              {
                type: 'comment',
                name: 'area_owner_and_role',
                title: I18n.t('form.commitments.page2.q8.title'),
                description: I18n.t('form.commitments.page2.q8.description'),
                defaultValue: @commitment.area_owner_and_role || ''
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
                choices: committed_year_and_implementation_year_choices,
                optionsCaption: I18n.t('form.commitments.page3.q1.caption'),
                popupdescription: I18n.t('form.commitments.page3.q1.popupdescription_html')
              },
              {
                type: 'dropdown',
                name: 'duration_years',
                title: I18n.t('form.commitments.page3.q2.title'),
                defaultValue: @commitment.duration_years || '',
                choices: duration_years_choices,
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
                choices: ['Committed', 'In progress', 'Implemented fully'],
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
                             text: @form_option_text_service.call(name, 'action')
                           }
                         end.compact,
                otherText: 'Other'
              },
              {
                type: 'dropdown',
                name: 'implementation_year',
                title: I18n.t('form.commitments.page4.q3.title'),
                defaultValue: @commitment.implementation_year || '',
                choices: committed_year_and_implementation_year_choices,
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
                             text: @form_option_text_service.call(name, 'threat')
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
                    visibleIf: 'false'
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
                    visibleIf: 'false'
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
              },
              {
                type: 'checkbox',
                name: 'shareable',
                titleLocation: 'hidden',
                defaultValue: !!@commitment.shareable,
                choices: [
                  {
                    value: true,
                    text: I18n.t('form.commitments.page5.q2.option_text')
                  }
                ]
              }
            ]
          }
        ]
      }
    }
  end

  def duration_years_choices
    choices = (5..40).to_a
    choices << '40+'
    choices
  end

  def committed_year_and_implementation_year_choices
    choices = (2010..2030).to_a
    choices << 'after 2030'
    choices.unshift('before 2010')
    choicest
  end

  def regex_10_word_maximum
    # https://stackoverflow.com/questions/1526881/use-a-regularexpressionvalidator-to-limit-a-word-count
    '^\s*(\S+\s+|\S+$){1,10}$'
  end

  def regex_latitude
    # https://stackoverflow.com/questions/3518504/regular-expression-for-matching-latitude-longitude-coordinates
    '^([+-])?(?:90(?:\\.0{1,6})?|((?:|[1-8])[0-9])(?:\\.[0-9]{1,6})?)$'
  end

  def regex_longitude
    # https://stackoverflow.com/questions/3518504/regular-expression-for-matching-latitude-longitude-coordinates
    '^([+-])?(?:180(?:\\.0{1,6})?|((?:|[1-9]|1[0-7])[0-9])(?:\\.[0-9]{1,6})?)$'
  end
end
