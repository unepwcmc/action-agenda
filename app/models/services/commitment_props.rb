class Services::CommitmentProps
  def initialize(commitment)
    @commitment = commitment
  end

  def call
    {
      config:
      {
        action: @commitment.new_record? ? '/commitments.json' : "/commitments/#{ @commitments.id }.json",
        method: @commitment.new_record? ? 'post' : 'put',
        root_key: 'commitment'
      },
      survey: {
        showPrevButton: false,
        showQuestionNumbers: 'onPage',
        showProgressBar: 'top',
        requiredText: '',
        pages: [
          {
            name: 'generalPage',
            elements: [
              {
                type: 'text',
                name: 'name',
                title: 'Enter commitment name',
                description:
                  '(To save or continue with this form, you’ll need to provide a name for your commitment)',
                isRequired: true
              },
              {
                type: 'comment',
                name: 'description',
                title: 'Please provide a description for your commitment'
              },
              {
                type: 'checkbox',
                name: 'objectiveIds',
                title: 'Please select the primary management objectives for the area',
                description: 'Multi select option',
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
                title:
                  'Who will be responsible for deciding how the area is being managed?',
                description: 'Multi select option',
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
                otherText: 'Other'
              },
              {
                type: 'comment',
                name: 'jointGovernanceType',
                visibleIf: "{managerIds} contains 'Joint governance'",
                title: 'Specify the type of joint governance',
                hideNumber: true
              },
              {
                type: 'text',
                name: 'responsibleGroup',
                title: 'Name of the group responsible for decisions'
              }
            ],
            title: 'General Info',
            description:
              '‘Commitment’ refers to what you intend to do, for example establishing a new protected area, or working to improve the management of an existing area. ‘Area’ refers to the geographical area that is (or will be) under management as a result of this commitment.’'
          },
          {
            name: 'locationPage',
            elements: [
              {
                type: 'tagbox',
                name: 'countryIds',
                title: 'Select commitment location by country',
                description: 'Multi select option',
                # defaultValue: [],
                choicesByUrl: {
                  url: 'https://surveyjs.io/api/CountriesExample'
                },
                optionsCaption: '-Select a country-'
              },
              {
                type: 'expression',
                name: 'latlongHeading',
                title: 'Please provide the latitude and longitude of the area'
              },
              {
                type: 'text',
                name: 'latitude',
                title: 'Latitude',
                titleLocation: 'left',
                hideNumber: true
              },
              {
                type: 'text',
                name: 'longitude',
                title: 'Longitude',
                titleLocation: 'left',
                hideNumber: true
              },
              {
                type: 'file',
                name: 'geospatialFilename',
                title:
                  'If you have spatial data you would like to share, please upload it here.',
                description: '(Optional field)',
                hideNumber: true,
                allowImagesPreview: false,
                maxSize: 26_214_400
              },
              {
                type: 'text',
                name: 'areaHa',
                title: 'How many hectares does/will the area cover?'
              }
            ],
            title: 'Location'
          },
          {
            name: 'durationPage',
            elements: [
              {
                type: 'dropdown',
                name: 'committedYear',
                title: 'Please state the year the commitment was made',
                # defaultValue: [],
                choices: %w[
                  2022
                  2021
                  2020
                  2019
                  2018
                  2017
                  2016
                  2015
                  2014
                  2013
                  2012
                ],
                optionsCaption: '-Select-'
              },
              {
                type: 'dropdown',
                name: 'duration',
                title:
                  'How many years do you expect the commitment to be in place for?',
                  # defaultValue: [],
                choices: %w[
                  5
                  6
                  7
                  8
                  9
                  10
                  11
                  12
                  13
                  14
                  15
                ],
                optionsCaption: '-Select-'
              }
            ],
            title: 'Duration'
          },
          {
            name: 'stagePage',
            elements: [
              {
                type: 'radiogroup',
                name: 'stage',
                title: 'Please select the stage of implementation of your commitment',
                # defaultValue: [],
                choices: ['Committed', 'In progress', 'Implemented']
              },
              {
                type: 'checkbox',
                name: 'actionIds',
                title:
                  'What actions do you intend/or have taken to implement the commitment?',
                description: 'Multi select option',
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
                title: 'Please state the first year of commitment actions',
                # defaultValue: [],
                choices: %w[
                  2022
                  2021
                  2020
                  2019
                  2018
                  2017
                  2016
                  2015
                  2014
                  2013
                  2012
                ]
              },
              {
                type: 'checkbox',
                name: 'threatIds',
                title:
                  'What are the main threats that your commitment is seeking to address?',
                description: 'Multi select option',
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
                title:
                  'Please provide the name and URL of any other websites containing information on your commitment.',
                description: '(Optional field)',
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
                confirmDeleteText: 'Are you sure you want to delete this website?',
                panelAddText: 'Add another'
              }
            ],
            title: 'Stage'
          },
          {
            name: 'progressPage',
            elements: [
              {
                type: 'paneldynamic',
                name: 'progressItems',
                title: 'Upload your progress documentation',
                description: '(Optional field)',
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
                confirmDeleteText: 'Are you sure you want to delete this file?',
                panelAddText: 'Add another'
              }
            ],
            title: 'Progress'
          }
        ],
      }
    }
  end
end
