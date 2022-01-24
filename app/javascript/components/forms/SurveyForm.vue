<template>
  <div class="survey-commitment">
    <survey :survey="survey" />
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
  </div>
</template>

<script>
import * as SurveyVue from "survey-vue";
import Turbolinks from "turbolinks";
import axios from "axios";
import { setAxiosHeaders } from "../../helpers/axios-helpers";
import "survey-vue/modern.css";
import FormNavigation from "./Navigation"

SurveyVue.StylesManager.applyTheme("modern");

const Survey = SurveyVue.Survey;

export default {
  name: "SurveyForm",

  components: { 
    FormNavigation,
    Survey
  },

  props: {
    formData: {
      type: Object,
      required: true,
    },

    modalQuestionBody: {
      type: String,
      required: true
    },
  
    modalText: {
      type: Object,
      required: true
    },

    dataModel: {
      type: String,
      required: true
    },

    navigationText: {
      type: Object,
      required: true
    },

    noneValues: {
      type: Object,
      default: () => ({})
    }
  },

  data () {
    const model = new SurveyVue.Model(this.formData.survey);
    // call methods on library-provided events here
    model.onComplete.add(this.onComplete);
    model.onCurrentPageChanged.add(this.onCurrentPageChanged);

    return {
      isFirstPage: true,
      isLastPage: false,
      survey: model,
    };
  },

  mounted() {
    setAxiosHeaders(axios);
  },

  methods: {
    complete () {
      this.survey.completeLastPage();
    },

    exit () {
      if (this.dataModel === "Commitment") {
        this.survey.completeLastPage();
      } else {
        Turbolinks.visit("/dashboard");
      }
    },

    nextPage () {
      this.survey.nextPage();
    },

    onComplete(sender) {
      const data = sender.data;

      Object.keys(this.noneValues).forEach((question) => {
        if (data[question] && data[question][0] === "none") {
          data[question][0] = this.noneValues[question];
        }
      });

      const options = {
        method: this.formData.config.method,
        data: { [this.formData.config.root_key]: data },
      };

      axios(this.formData.config.action, options)
        .then((response) => {
          this.redirect(response.data.redirect_path)
        })
        .catch((error) => {
          console.log("FAILED!", error.data);
        })
    },

    onCurrentPageChanged () {
      this.isFirstPage = survey.isFirstPage;
      this.isLastPage = survey.isLastPage;
    },
  
    prevPage () {
      this.survey.prevPage();
    },

    redirect(link) {
      if (link) {
        Turbolinks.visit(link);
      }
    }
  }
}
</script>
