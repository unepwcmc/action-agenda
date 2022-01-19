<template>
  <div class="survey-commitment">
    Commitment survey
    <navigation
      v-bind="{
        complete,
        exit,
        isFirstPage, 
        isLastPage,
        modalQuestionBody,
        modalText,
        model: 'Commitment',
        navigationText,
        prevPage,
        nextPage,
      }"
    />
  </div>
</template>

<script>
// import * as SurveyVue from "survey-vue";
// import Turbolinks from "turbolinks";
// import axios from "axios";
// import { setAxiosHeaders } from "../../helpers/axios-helpers";
// import "survey-vue/modern.css";
import Navigation from './Navigation'

// SurveyVue.StylesManager.applyTheme("modern");

// const Survey = SurveyVue.Survey;

export default {
  name: 'form-commitment',

  components: { 
    Navigation
    // Survey
  },

  props: {
    // formData: {
    //   type: Object,
    //   required: true,
    // },

    modalText: {
      type: Object,
      required: true
    },

    navigationText: {
      type: Object,
      required: true
    }
  },

  data () {
    // const model = new SurveyVue.Model(this.formData.survey);
    // call methods on library-provided events here
    // model.onComplete.add(this.onComplete);
    // model.onCurrentPageChanged(this.onCurrentPageChanged);

    return {
      isFirstPage: true,
      isLastPage: false,
      modalQuestionBody: `<p>${this.modalText.p1}</p><p><b>${this.modalText.p2.prefix}*</b> ${this.modalText.p2.content}</p>`
      // survey: model
    }
  },

  // mounted() {
  //   setAxiosHeaders(axios);
  // },

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

    // onComplete () {
    // },

    // onCurrentPageChanged () {
      // this.isFirstPage = survey.isFirstPage;
      // this.isLastPage = survey.isLastPage;
    // },
  
    prevPage () {
      // survey.prevPage();
      console.log("going to previous page");
    }

    // redirect () {
    // }
  }
}
</script>