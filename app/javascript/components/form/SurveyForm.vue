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
        model,
        navigationText,
        prevPage,
        nextPage,
      }"
    />
  </div>
</template>

<script>
import Navigation from './Navigation'

export default {
  name: 'SurveyForm',

  components: { 
    Navigation
  },

  props: {
    modalText: {
      type: Object,
      required: true
    },

    model: {
      type: String,
      required: true
    }

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
      modalQuestionBody: `<p>${this.modalText.p1}</p><p><b>${this.modalText.p2.prefix}*</b> ${this.modalText.p2.content}</p>`
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