<template>
  <div class="container">
    <!-- If you want to hide survey, comment the lines below -->
    <h2>Product Feedback Survey Example</h2>
    <survey :survey="survey"></survey>
  </div>
</template>

<script>
import * as SurveyVue from "survey-vue";
// import "bootstrap/dist/css/bootstrap.css";
var Survey = SurveyVue.Survey;
Survey.cssType = "default";

SurveyVue.Serializer.addProperty("question", "tag:number");

export default {
  // name: "CriteriaForm",
  components: {
    Survey,
  },
  props: {
    formData: {
      type: Object,
      required: true
    }
  },
  data() {
    var model = new SurveyVue.Model(this.formData);
    return {
      survey: model,
    };
  },

};
</script>
