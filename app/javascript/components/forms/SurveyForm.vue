<template>
  <div class="container">
    <survey :survey="survey"></survey>
  </div>
</template>

<script>
import * as SurveyVue from "survey-vue";
import Turbolinks from "turbolinks";
import axios from "axios";
import { setAxiosHeaders } from "../../helpers/axios-helpers";
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
  },

  data() {
    const model = new SurveyVue.Model(this.formData.survey);
    // call methods on library-provided events here
    model.onComplete.add(this.onComplete);
    return {
      survey: model,
    };
  },

  mounted() {
    setAxiosHeaders(axios);
  },

  methods: {
    onComplete(sender) {
      const options = {
        method: this.formData.config.method,
        data: { [this.formData.config.root_key]:  sender.data },
      }
      axios(this.formData.config.action, options)
        .then((response) => {
          this.redirect(response.data.redirect_path)
        })
        .catch((error) => {
          console.log("FAILED!", error.data);
        })
    },
    redirect(link) {
      if (link) {
        Turbolinks.visit(`${link}`);
      }
    }
  },
};
</script>
