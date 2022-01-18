<template>
  <div class="container">
    <survey :survey="survey"></survey>
  </div>
</template>

<script>
import * as SurveyVue from "survey-vue";
import "survey-vue/modern.css";
SurveyVue.StylesManager.applyTheme("modern");

var Survey = SurveyVue.Survey;

export default {
  name: "SurveyForm",
  components: {
    Survey,
  },
  props: {
    formData: {
      type: Object,
      required: true,
    },
    // axios callback
    // redirect after success
    // redirect after failure
    // modal - conditional rendering ( might be in a parent component?)
  },
  data() {
    var model = new SurveyVue.Model(this.formData);
    // call methods on library events here
      model.onComplete.add(this.onComplete);
    return {
      survey: model,
    };
  },
  methods: {
    onComplete(sender) {
      console.log('complete', this.survey, sender.data)
    },
  },
};
</script>
