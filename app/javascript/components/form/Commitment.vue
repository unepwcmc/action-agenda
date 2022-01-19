<template>
  <div class="survey-commitment">
    Commitment survey
    <navigation
      v-bind="{
// onePage,
// modalBody,
// exitText,
// exitPath,
// continueText,
// isFirstPage,
// isLastPage,
// survey.prevPage,
// survey.nextPage,
// survey.completeLastPage,
      }"
    />
  </div>
</template>

<script>
import Navigation from './Navigation'

export default {
  name: 'form-commitment',

  components: { 
    Navigation
  },

  data () {
    return {
      survey: {}
    }
  }

// survey.showNavigationButtons = false
}
</script>