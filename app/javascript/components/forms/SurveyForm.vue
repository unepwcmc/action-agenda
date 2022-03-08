<template>
  <div>
    <survey class="survey-container" :survey="survey" />
    <form-navigation
      v-bind="{
        complete,
        dataModel,
        exit,
        isFirstPage,
        isLastPage,
        modalQuestionBody,
        modalText,
        navigationText,
        prevPage,
        nextPage,
      }"
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
      errors: {},
      isFirstPage: true,
      isLastPage: false,
      options: {},
      errorKey: Math.random(),
      survey: model,
      progressFilesSignedIds: [],
      geospatialFile: "",
    };
  },

  mounted() {
    setAxiosHeaders(axios);
  },

  methods: {
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
        this.send(data);
      }
      Turbolinks.visit("/dashboard");
    },

    nextPage() {
      this.survey.nextPage();
    },

    onComplete(sender) {
      const data = sender.data;
      if (this.dataModel === "Commitment") {
        data["state"] = "live";
        this.appendFileSignedIds(data);
      }
      this.send(data);
    },

    appendFileSignedIds(data) {
      if (this.geospatialFile) { data["geospatial_file"] = this.geospatialFile };
      this.progressFilesSignedIds.forEach((signedId, index) => {
        data['progress_documents_attributes'][index]['document'] = signedId;
      });
    },

    onAfterRenderQuestion(survey, options) {
      //Return if there is no description to show in popup
      if (!options.question.popupdescription) return;

      //Add a button and description div;
      const btn = document.createElement("button");
      const description = document.createElement("div");
      const header = options.htmlElement.querySelector("h5");

      btn.type = "button";
      btn.className = "tooltip trigger";
      description.className = "tooltip popup";
      description.innerHTML = options.question.popupdescription;

      header.appendChild(btn);
      btn.onclick = () =>
        header.lastChild === description
          ? header.removeChild(description)
          : header.appendChild(description);
    },

    onCurrentPageChanged() {
      this.isFirstPage = this.survey.isFirstPage;
      this.isLastPage = this.survey.isLastPage;
    },

    onDynamicPanelRemoved(survey, options) {
      this.progressFilesSignedIds.splice(options.panelIndex, 1)
    },

    onUpdateQuestionCssClasses(survey, options) {
      // errors
      if (this.formData.errors?.includes(options.question.name)) {
        options.cssClasses.mainRoot += " form__question--errors";
      }

      // multiselect
      const multiselectQs = [
        "cbd_objective_ids",
        "stakeholder_ids",
        "objective_ids",
        "manager_ids",
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

    onUploadFiles(survey, options) {
      //TODO set cors settings on the bucket for this to work with S3
      const file = options.files[0];
      const upload = new DirectUpload(
        file,
        "/rails/active_storage/direct_uploads"
      );
      options.callback(
        "success",
        options.files.map(function (file) {
          return {
            file: file,
            content: file.filename,
          };
        })
      );
      console.log("FILE", file, options);
      upload.create((error, blob) => {
        if (error) {
          console.log(error);
        } else {
          if (options.name === "geospatial_file") {
            this.geospatialFile = blob.signed_id;
          } else {
            this.progressFilesSignedIds.push(blob.signed_id);
          }
        }
      });
    },

    prevPage() {
      this.survey.prevPage();
    },

    send(data) {
      if (this.dataModel === "Criterium") {
        this.assignNoneValues(data);
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
