<template>
  <div class="container">
    <survey :survey="survey"></survey>
    <form-navigation
      v-bind="{
        complete,
        exit,
        isFirstPage, 
        isLastPage,
        modalQuestionBody,
        modalText,
        model,
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
import FormNavigation from './Navigation'

SurveyVue.StylesManager.applyTheme("modern");

const Survey = SurveyVue.Survey;

export default {
  name: 'SurveyForm',

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

    model: {
      type: String,
      required: true
    },

    navigationText: {
      type: Object,
      required: true
    }
  },

  data () {
    const model = new SurveyVue.Model(this.formData.survey);
    // call methods on library-provided events here
    model.onComplete.add(this.onComplete);
    // model.onCurrentPageChanged(this.onCurrentPageChanged);

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
      // survey.completeLastPage();
      console.log("completed!");
    },

    exit () {
      // survey.completeLastPage(); something like this? May need some validation, e.g. that the title is provided, though this could possibly be added to onComplete method
      console.log("exited!");
    },

    nextPage () {
      // survey.nextPage();
      console.log("going to next page");
    },

    onComplete(sender) {
      const options = {
        method: this.formData.config.method,
        data: { [this.formData.config.root_key]: sender.data },
      }

      axios(this.formData.config.action, options)
        .then((response) => {
          this.redirect(response.data.redirect_path)
        })
        .catch((error) => {
          console.log("FAILED!", error.data);
        })
    },

    // onCurrentPageChanged () {
      // this.isFirstPage = survey.isFirstPage;
      // this.isLastPage = survey.isLastPage;
    // },
  
    prevPage () {
      // survey.prevPage();
      console.log("going to previous page");
    }

    redirect(link) {
      if (link) {
        Turbolinks.visit(link);
      }
    }
  }
}
</script>
