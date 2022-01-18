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
// SurveyVue.Serializer.addProperty("question", "tag:number");

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
