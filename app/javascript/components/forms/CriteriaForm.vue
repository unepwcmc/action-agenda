<template>
  <div class="container">
    <!-- If you want to hide survey, comment the lines below -->
    <h2>Form 1: criteria</h2>
    <h3>
      Form 1 will help establish whether this platform is the right place for
      your commitment. ‘Commitment’ refers to what you intend to do, for
      example, commitments to enhance/improve an existing area where new actions
      are planned or to establish a new area. ‘Area’ refers to the geographical
      area this is (or will be) under management as a result of this
      commitment.
    </h3>
    <survey :survey="survey"></survey>
  </div>
</template>

<script>
import * as SurveyVue from "survey-vue";
import "bootstrap/dist/css/bootstrap.css";
var Survey = SurveyVue.Survey;
Survey.cssType = "bootstrap";
SurveyVue.Serializer.addProperty("question", "tag:number");

export default {
  // name: "CriteriaForm",
  components: {
    Survey,
  },
  props: {
    formData: {
      type: Object,
      required: true,
    },
  },
  data() {
    var model = new SurveyVue.Model(this.formData);
    return {
      survey: model,
    };
  },
};
</script>
