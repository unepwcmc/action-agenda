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
    <error-banner :errors="errors" :key="errorKey" />
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

    return {
      axiosDone: false,
      counter: 0,
      disabled: false,
      errors: {},
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
    numberedQuestionsByPage () {
      const counts = {}

      const pages = Array.from(this.survey.pages)

      pages.forEach((page, pageIndex) => {
        const visibleElements = page.elements.filter(element => element.visible)

        counts[pageIndex] = visibleElements.length
      })

      return counts
    }
  },

  methods: {
    addSideQuestionIndicator(options) {
      // Get data for text
      const questionNumber = options.question.no.slice(0, -1);
      if (!questionNumber) { return }
      
      const currentPageNumber = this.survey.currentPageNo;
      const questionsOnPage = this.numberedQuestionsByPage[currentPageNumber];

      const questionNumberText = `${questionNumber} of ${questionsOnPage}`;

      // Create element
      const questionNumberTextElement = document.createElement('div');
      questionNumberTextElement.className = 'question__side-number-indicator'
      questionNumberTextElement.innerHTML = questionNumberText;

      // Get question heading
      const header = options.htmlElement.querySelector(".sv-question__header");

      // Add element
      header.appendChild(questionNumberTextElement);
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
          }
        });
    },

    complete() {
      this.onComplete(this.survey);
    },

    exit() {
      if (this.dataModel === "Commitment") {
        const data = this.survey.data;
        this.appendFileSignedIds(data);
        this.addDestroyKeys(data);
        this.send(data);
      }
    },

    nextPage() {
      this.survey.nextPage();
      window.scrollTo(0, 0)
    },

    onComplete(sender) {
      const data = sender.data;
      if (this.dataModel === "Commitment") {
        data["state"] = "live";
        this.appendFileSignedIds(data);
        this.addDestroyKeys(data);
      }
      this.send(data);
    },

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

    appendFileSignedIds(data) {
      this.appendFileSignedId(
        data,
        "geospatial_file",
        this.geospatialFileSignedId
      );

      data["progress_documents_attributes"].forEach(
        (progress_documents_attributes) => {
          let signedId = "";
          if (progress_documents_attributes.document) {
            signedId =
              this.progressFilesSignedIds[
                progress_documents_attributes.document[0].name
              ];
          }
          this.appendFileSignedId(
            progress_documents_attributes,
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

    appendDocumentDestroy() {
      const documentJsonIds = this.formData.config.progress_document_json.map(
        (element) => element.id
      );
      const documentSurveyIds = this.survey.data[
        "progress_documents_attributes"
      ].map((element) => element.id);
      this.destroyedDocumentIds = documentJsonIds.filter(
        (item) => !documentSurveyIds.includes(item)
      );
    },

    appendLinksDestroy() {
      const linkJsonIds = this.formData.config.links_json.map(
        (element) => element.id
      );
      const linkSurveyIds = this.survey.data[
        "links_attributes"
      ].map((element) => element.id);
      this.destroyedLinkIds = linkJsonIds.filter(
        (item) => !linkSurveyIds.includes(item)
      );
    },

    onAfterRenderQuestion(survey, options) {
      this.addTooltip(options);
      this.addSideQuestionIndicator(options);
    },

    onCurrentPageChanged(survey, options) {
      this.isFirstPage = this.survey.isFirstPage;
      this.isLastPage = this.survey.isLastPage;
    },

    onDynamicPanelRemoved(survey, options) {
      if (options.question.name == 'links_attributes') {
        this.appendLinksDestroy();
      } else { 
        this.appendDocumentDestroy();
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

    onUpdatePageCssClasses(survey, options) {
      if (options.page.num > 1) {
        options.cssClasses.page.root += " form__page--not-first";
      }
    },

    onfileUploading() {
      this.randomKey++;
      this.disabled = true;
      this.showProgressBar = true;
    },

    onfileUploaded() {
      setTimeout(() => {
        this.randomKey++;
        this.disabled = false;
        this.showProgressBar = false;
      }, 100);
      clearTimeout();
    },

    async onUploadFiles(survey, options) {
      this.onfileUploading();
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
            this.onfileUploaded()
          )
        }
      });
    },

    prevPage() {
      this.survey.prevPage();
      window.scrollTo(0, 0)
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
