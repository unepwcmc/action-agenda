<template>
  <div class="survey-commitment">
    Survey
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
import FormNavigation from './Navigation'

export default {
  name: 'SurveyForm',

  components: { 
    FormNavigation
  },

  props: {
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
    // model.onCurrentPageChanged(this.onCurrentPageChanged);

    return {
      isFirstPage: true,
      isLastPage: false,
    }
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

    // onCurrentPageChanged () {
      // this.isFirstPage = survey.isFirstPage;
      // this.isLastPage = survey.isLastPage;
    // },
  
    prevPage () {
      // survey.prevPage();
      console.log("going to previous page");
    }
  }
}
</script>