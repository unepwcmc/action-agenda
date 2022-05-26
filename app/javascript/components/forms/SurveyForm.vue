<template>
  <div>
    <div v-if="showProgressBar" class="progress-bar"></div>
    <survey class="survey-container" :survey="survey" />
    <form-navigation
      v-bind="{
        complete,
        dataModel,
        disabled,
        exit,
        isFirstPage,
        isLastPage,
        modalQuestionBody,
        modalText,
        navigationText,
        prevPage,
        nextPage,
      }"
      :key="randomKey"
    />
    <error-banner
      v-if="hasErrors"
      v-bind="{ errorText }"
      :key="errorKey"
    />
  </div>
</template>

<script>
import * as SurveyVue from "survey-vue";
import * as widgets from "surveyjs-widgets";
import Turbolinks from "turbolinks";
import axios from "axios";
import { setAxiosHeaders } from "../../helpers/axios-helpers";
import "survey-vue/modern.css";
import FormNavigation from "./Navigation";
import ErrorBanner from "../banners/ErrorBanner";
import { DirectUpload } from "activestorage";

SurveyVue.StylesManager.applyTheme("modern");
SurveyVue.Serializer.addProperty("question", "popupdescription:text");
SurveyVue.Serializer.addProperty("page", "popupdescription:text");

widgets.select2tagbox(SurveyVue);

const Survey = SurveyVue.Survey;

export default {
  name: "SurveyForm",

  components: {
    ErrorBanner,
    FormNavigation,
    Survey,
  },

  props: {
    errorText: {
      type: String,
      default: ''
    },

    formData: {
      type: Object,
      required: true,
    },

    modalQuestionBody: {
      type: String,
      required: true,
    },

    modalText: {
      type: Object,
      required: true,
    },

    dataModel: {
      type: String,
      required: true,
    },

    navigationText: {
      type: Object,
      required: true,
    },

    noneValues: {
      type: Object,
      default: () => ({}),
    },
  },

  data() {
    const model = new SurveyVue.Model(this.formData.survey);

    // call methods on library-provided events here
    model.onAfterRenderQuestion.add(this.onAfterRenderQuestion);
    model.onComplete.add(this.onComplete);
    model.onCurrentPageChanged.add(this.onCurrentPageChanged);
    model.onUpdateQuestionCssClasses.add(this.onUpdateQuestionCssClasses);
    model.onUpdatePageCssClasses.add(this.onUpdatePageCssClasses);
    model.onUploadFiles.add(this.onUploadFiles);
    model.onDynamicPanelRemoved.add(this.onDynamicPanelRemoved);
    model.onValueChanged.add(this.onValueChanged);

    return {
      axiosDone: false,
      counter: 0,
      disabled: false,
      errors: [],
      isFirstPage: true,
      isLastPage: false,
      options: {},
      errorKey: Math.random(),
      survey: model,
      progressFilesSignedIds: {},
      randomKey: Math.random(),
      geospatialFileSignedId: this.formData.config.geospatial_file,
      destroyedDocumentIds: [],
      destroyedLinkIds: [],
      showProgressBar: false,
      numberedQuestionsOnPage: undefined
    };
  },

  mounted() {
    setAxiosHeaders(axios);
    
    if (this.formData.config.progress_document_json) {
      this.survey.data = {
        ...this.survey.data,
        progress_documents_attributes:
          this.formData.config.progress_document_json,
        links_attributes:
          this.formData.config.links_json,
      };

      this.formData.config.progress_document_json.forEach((question) => {
        this.progressFilesSignedIds[question.document[0].name] =
          question.signed_id;
      });
    }
  },

  computed: {
    hasErrors () {
      return this.formData.errors?.length > 0 || this.errors.length > 0
    },

    numberedQuestionsByPage () {
      const counts = {}

      const pages = Array.from(this.survey.pages)

      pages.forEach((page, pageIndex) => {
        const visibleElements = page.elements.filter(element => {
          const hiddenNumber = element.hideNumber
          const hiddenTitle = element.titleLocation === 'hidden'
          const invisible = !element.visible
          const notAQuestion = element.getType() === 'html'

          const unnumberedCases = [
            hiddenNumber,
            hiddenTitle,
            invisible,
            notAQuestion
          ]

          if (unnumberedCases.some(kase => kase)) {
            return false
          }

          return true
        })

        counts[pageIndex] = visibleElements.length
      })

      return counts
    }
  },

  methods: {
    addDestroyKeys(data) {
      if (this.destroyedDocumentIds.length > 0) {
        this.destroyedDocumentIds.forEach((id) => {
          data["progress_documents_attributes"].push({
            id: id,
            _destroy: true,
          });
        });
      }

      if (this.destroyedLinkIds.length > 0) {
        this.destroyedLinkIds.forEach((id) => {
          data["links_attributes"].push({
            id: id,
            _destroy: true,
          });
        });
      }
    },

    addErrorClassToSubmittedQuestion(options) {
      // add error class if question present in this.errors (after submitting to backend)
      if (this.errors.includes(options.question.name)) {
        options.htmlElement.classList += " form__question--errors"
      }
    },

    addSideQuestionIndicator(options) {
      const questionNumberText = options.question.no
      if (!questionNumberText) { return }
      // Get data for text
      const questionNumber = questionNumberText.slice(0, -1);
      if (!questionNumber) { return }
      
      const currentPageNumber = this.survey.currentPageNo;
      const questionsOnPage = this.numberedQuestionsByPage[currentPageNumber];

      const indicatorText = `${questionNumber} of ${questionsOnPage}`;

      // Create element
      const indicatorTextElement = document.createElement('div');
      indicatorTextElement.className = 'question__side-number-indicator'
      indicatorTextElement.innerHTML = indicatorText;

      // Get question heading
      const header = options.htmlElement.querySelector(".sv-question__header");

      // Add element
      header.appendChild(indicatorTextElement);
    },

    addTooltip(options) {
      // Return if there is no description to show in popup
      if (!options.question.popupdescription) return;

      // Create tooltip elements
      const container = document.createElement("div");
      container.className = "tooltip";

      const button = document.createElement("button");
      button.type = "button";
      button.className = "tooltip__trigger";

      const popup = document.createElement("div");
      popup.className = "tooltip__popup";
      popup.innerHTML = options.question.popupdescription;

      // Get question heading
      const heading = options.htmlElement.querySelector("h5");

      // Add elements
      container.appendChild(button);
      heading.appendChild(container);

      container.onclick = () =>
        container.lastChild === popup
          ? container.removeChild(popup)
          : container.appendChild(popup);
    },

    appendDocumentDestroy() {
      const initialDocumentIds = this.formData.config.progress_document_json
        .map(element => element.id);

      const currentDocumentIds = this.survey.data.progress_documents_attributes
        .filter(element => element.document)
        .map((element) => element.id);

      this.destroyedDocumentIds = initialDocumentIds
        .filter(id => !currentDocumentIds.includes(id));
    },

    appendFileSignedIds(data) {
      this.appendFileSignedId(
        data,
        "geospatial_file",
        this.geospatialFileSignedId
      );

      data["progress_documents_attributes"].forEach(
        (progress_document_attributes) => {
          let signedId = "";
          if (progress_document_attributes.document) {
            signedId =
              this.progressFilesSignedIds[
                progress_document_attributes.document[0].name
              ];
          }
          this.appendFileSignedId(
            progress_document_attributes,
            "document",
            signedId
          );
        }
      );
    },

    appendFileSignedId(data, field, signedId) {
      if (data[field]) {
        data[field] = signedId;
      } else {
        data[field] = "";
      }
    },

    appendLinksDestroy() {
      const initialLinkIds = this.formData.config.links_json
        .map(element => element.id);
      
      const currentLinkIds = this.survey.data.links_attributes
        .map(element => element.id);
      
      this.destroyedLinkIds = initialLinkIds
        .filter(id => !currentLinkIds.includes(id));
    },

    assignNoneValues(data) {
      Object.keys(this.noneValues).forEach((question) => {
        if (data[question] && data[question][0] === "none") {
          data[question][0] = this.noneValues[question];
        }
      });
    },

    axiosCall() {
      axios(this.formData.config.action, this.options)
        .then((response) => {
          if (response.data.redirect_path) {
            // preferred to turbolink so JQery reloads on the commitment form
            window.location.replace(response.data.redirect_path);
          }
        })
        .catch((error) => {
          if (error.response) {
            this.errorKey++;
            this.errors = error.response.data.errors;

            if (this.isFirstPage) {
              this.nextPage()
              this.prevPage()
            } else {
              this.prevPage()
              this.nextPage()
            }
          }
        });
    },

    complete() {
      this.onComplete(this.survey);
    },

    exit() {
      if (this.dataModel === "Commitment") {
        const data = this.survey.data;
        this.processCommitmentBeforeSubmission(data)
        this.send(data);
      } else {
        window.location.replace('/dashboard')
      }
    },

    nextPage() {
      this.survey.nextPage();
      window.scrollTo(0, 0)
    },

    onAfterRenderQuestion(survey, options) {
      this.addErrorClassToSubmittedQuestion(options)  
      this.addTooltip(options);
      this.addSideQuestionIndicator(options);
    },

    onComplete(sender) {
      const data = sender.data;
      if (this.dataModel === "Commitment") {
        data["state"] = "live";
        this.processCommitmentBeforeSubmission(data)
      }
      this.send(data);
    },

    onCurrentPageChanged(survey, options) {
      this.isFirstPage = this.survey.isFirstPage;
      this.isLastPage = this.survey.isLastPage;
    },

    onDynamicPanelRemoved(survey, options) {
      if (options.question.name === 'links_attributes') {
        this.appendLinksDestroy();
      }
    },

    onFileUploaded() {
      setTimeout(() => {
        this.randomKey++;
        this.disabled = false;
        this.showProgressBar = false;
      }, 100);
      clearTimeout();
    },

    onFileUploading() {
      this.randomKey++;
      this.disabled = true;
      this.showProgressBar = true;
    },

    onUpdatePageCssClasses(survey, options) {
      if (options.page.num > 1) {
        options.cssClasses.page.root += " form__page--not-first";
      }
    },

    onUpdateQuestionCssClasses(survey, options) {
      // errors
      if (this.formData.errors?.includes(options.question.name)) {
        options.cssClasses.mainRoot += " form__question--errors";
      }

      // multiselect
      const multiselectQs = [
        "cbd_objective_ids",
        "objective_ids",
        "country_ids",
        "action_ids",
        "threat_ids",
      ];

      if (multiselectQs.includes(options.question.name)) {
        options.cssClasses.mainRoot += " form__question--multiselect";
      }
    },

    async onUploadFiles(survey, options) {
      this.onFileUploading();
      //TODO set cors settings on the bucket for this to work with S3
      const file = options.files[0];
      const upload = new DirectUpload(
        file,
        "/rails/active_storage/direct_uploads"
      );

      await upload.create((error, blob) => {
        if (error) {
          console.log(error);
        } else {
          if (options.name === "geospatial_file") {
            this.geospatialFileSignedId = blob.signed_id;
          } else {
            this.progressFilesSignedIds[blob.filename] = blob.signed_id;
          }

          // set file content as url to allow file download
          const url = `/rails/active_storage/blobs/${blob.signed_id}/${blob.filename}`;
          options.files[0]["content"] = url;

          options.callback(
            "success",
            options.files.map(function (file) {
              return {
                file: file,
                content: file.content,
              };
            }),
            this.onFileUploaded()
          )
        }
      });
    },

    onValueChanged(survey, options) {
      this.retainNullValues(options)
    },

    prevPage() {
      this.survey.prevPage();
      window.scrollTo(0, 0)
    },

    processCommitmentBeforeSubmission(data) {
      this.appendDocumentDestroy()
      this.appendFileSignedIds(data);
      this.addDestroyKeys(data);
    },

    retainNullValues(options) {
      const questionName = options.name
      const newValue = options.value

      // number - return since all numbers are likely valid
      if (typeof newValue === 'number') return

      // arrays and strings
      if (!newValue?.length) {
        if (Array.isArray(newValue)) {
          this.survey.mergeData({[questionName]: []})
        } else {
          this.survey.mergeData({[questionName]: ""})
        }
      }

      // geospatial file
      if (questionName === 'geospatial_file') {
        if (!options.value.length) {
          this.geospatialFileSignedId = ''
        }
      }

      // progress_documents
      if (questionName === 'progress_documents_attributes') {
        const newValues = options.value
          // remove item if there's no document
          // `addDestroyKeys` will handle _destroy keys on submission
          .filter(progressDocumentAttributes => progressDocumentAttributes.document)
          .map(progressDocumentAttributes => {
            if(!progressDocumentAttributes.progress_notes) {
              // include empty string for progress_notes if not present
              return { ...progressDocumentAttributes, progress_notes: '' }
            } else {
              // if document and progress notes are present, return as is
              return progressDocumentAttributes
            }
          })

        this.survey.mergeData({ progress_documents_attributes: newValues })
      }
    },

    send(data) {
      if (this.dataModel === "Criterium") {
        this.assignNoneValues(data);
      } else {
        // if shareable has been ticked, set it to true, else false
        data.shareable = !!data.shareable
      }

      this.options = {
        method: this.formData.config.method,
        data: { [this.formData.config.root_key]: data },
      };
      this.axiosCall();
    },
  },
};
</script>
