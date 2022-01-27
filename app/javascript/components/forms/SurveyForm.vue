<template>
  <div>
    <survey class="survey-container" :survey="survey" />
    <form-navigation
      v-bind="{
        complete,
        dataModel,
        exit,
        isFirstPage,
        isLastPage,
        modalQuestionBody,
        modalText,
        navigationText,
        prevPage,
        nextPage,
      }"
    />
    <error-banner :errors="errors" />
  </div>
</template>

<script>
import * as SurveyVue from 'survey-vue';
import * as widgets from 'surveyjs-widgets';
import Turbolinks from 'turbolinks';
import axios from 'axios';
import { setAxiosHeaders } from '../../helpers/axios-helpers';
import 'survey-vue/modern.css';
import FormNavigation from './Navigation';
import ErrorBanner from '../banners/ErrorBanner';

SurveyVue.StylesManager.applyTheme('modern');

widgets.select2tagbox(SurveyVue);

const Survey = SurveyVue.Survey;

export default {
  name: 'SurveyForm',

  components: {
    ErrorBanner,
    FormNavigation,
    Survey,
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

    dataModel: {
      type: String,
      required: true
    },

    navigationText: {
      type: Object,
      required: true
    },

    noneValues: {
      type: Object,
      default: () => ({}),
    },
  },

  data() {
    const model = new SurveyVue.Model(this.formData.survey);
    // call methods on library-provided events here
    model.onComplete.add(this.onComplete);
    model.onCurrentPageChanged.add(this.onCurrentPageChanged);
    model.onCompleting.add(this.onCompleting);

    return {
      errors: {},
      hasNoErrors: Boolean,
      axiosDone: false,
      isFirstPage: true,
      isLastPage: false,
      options: {},
      survey: model,
    };
  },

  mounted() {
    setAxiosHeaders(axios);
    console.log(this.formData);
  },

  methods: {
    assignNoneValues(data) {
      Object.keys(this.noneValues).forEach((question) => {
        console.log(data[question]);
        if (data[question] && data[question][0] === 'none') {
          console.log(data[question][0]);
          console.log(this.noneValues[question]);
          data[question][0] = this.noneValues[question];
        }
      });
    },

    axiosCall() {
      axios(this.formData.config.action, this.options)
        .then((response) => {
          this.isLastPage && this.axiosDone ? this.hasNoErrors = true : this.hasNoErrors = false
          Turbolinks.visit(response.data.redirect_path);
        })
        .catch((error) => {
          console.log('FAILED!', error.response.data.errors);
          this.hasNoErrors = false
          this.errors = error.response.data.errors;
        });
    },

    complete() {
      this.survey.completeLastPage();
    },

    exit() {
      if (this.dataModel === 'Commitment') {
        this.survey.completeLastPage();
      } else {
        Turbolinks.visit('/dashboard');
      }
    },

    nextPage() {
      this.survey.nextPage();
    },

    onComplete(sender) {
      console.log("complete")
      this.send(sender.data)
    },

    onCompleting(sender, options) {
      this.send(sender.data, true)
      this.axiosDone = true
      if (this.dataModel !== 'Commitment' || this.hasNoErrors) {
        console.log('no errors')
        options.allowComplete = true;
      } else {
        options.allowComplete = false
        console.log('errors')  
      }
    },

    send(data, validate=false) {
      if (validate) {
        if (this.dataModel === 'Commitment') {
          data['state'] = 'live';
        } else {
          this.assignNoneValues(data);
        }
      }
      this.options = {
        method: this.formData.config.method,
        data: { [this.formData.config.root_key]: data },
      };
      this.axiosCall();
    },

    onCurrentPageChanged() {
      this.isFirstPage = this.survey.isFirstPage;
      this.isLastPage = this.survey.isLastPage;

      this.send(this.survey.data)
    },

    prevPage() {
      this.survey.prevPage();
    },
  },
};
</script>
