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
SurveyVue.Serializer.addProperty('question', 'popupdescription:text');
SurveyVue.Serializer.addProperty('page', 'popupdescription:text');
widgets.select2tagbox(SurveyVue);

const Survey = SurveyVue.Survey;

export default {
  name: 'SurveyForm',

  components: {
    ErrorBanner,
    FormNavigation,
    Survey
  },

  props: {
    formData: {
      type: Object,
      required: true,
    },

    modalQuestionBody: {
      type: String,
      required: true,
    },

    modalText: {
      type: Object,
      required: true,
    },

    dataModel: {
      type: String,
      required: true,
    },

    navigationText: {
      type: Object,
      required: true,
    },

    noneValues: {
      type: Object,
      default: () => ({}),
    },
  },

  data() {
    const model = new SurveyVue.Model(this.formData.survey);
    // call methods on library-provided events here
    model.onAfterRenderQuestion.add(this.onAfterRenderQuestion);
    model.onComplete.add(this.onComplete);
    model.onCurrentPageChanged.add(this.onCurrentPageChanged);

    return {
      errors: {},
      axiosDone: false,
      isFirstPage: true,
      isLastPage: false,
      options: {},
      survey: model,
    };
  },

  mounted() {
    setAxiosHeaders(axios);
  },

  methods: {
    assignNoneValues(data) {
      Object.keys(this.noneValues).forEach((question) => {
        if (data[question] && data[question][0] === 'none') {
          data[question][0] = this.noneValues[question];
        }
      });
    },

    axiosCall() {
      axios(this.formData.config.action, this.options)
        .then((response) => {
          if (response.data.redirect_path) {
            // preferred to turbolink so JQery reloads on the commitment form
            window.location.replace(response.data.redirect_path);
          }
        })
        .catch((error) => {
          if (error.response) {
            this.errors = error.response.data.errors;
          }
        });
    },

    complete() {
      this.onComplete(this.survey);
    },

    exit() {
      if (this.dataModel === 'Commitment') {
        this.send(this.survey.data);
      }
      Turbolinks.visit('/dashboard');
    },

    nextPage() {
      this.survey.nextPage();
    },

    onComplete(sender) {
      const data = sender.data;
      if (this.dataModel === 'Commitment') {
        data['state'] = 'live';
      }
      this.send(data);
    },

    onAfterRenderQuestion(survey, options) {
      //Return if there is no description to show in popup
      if (!options.question.popupdescription) return;

      //Add a button and description div;
      let btn = document.createElement('button');
      let description = document.createElement('div')
      let header = options.htmlElement.querySelector('h5');

      btn.type = 'button';
      btn.className = 'tooltip trigger';
      description.className = 'tooltip popup'
      description.innerHTML = options.question.popupdescription;

      header.appendChild(btn);
      btn.onclick = () => header.lastChild == description ? header.removeChild(description) : header.appendChild(description);
    },

    onCurrentPageChanged() {
      this.isFirstPage = this.survey.isFirstPage;
      this.isLastPage = this.survey.isLastPage;
    },

    prevPage() {
      this.survey.prevPage();
    },

    send(data) {
      if (this.dataModel === 'Criterium') {
        this.assignNoneValues(data);
      }
      this.options = {
        method: this.formData.config.method,
        data: { [this.formData.config.root_key]: data },
      };
      this.axiosCall();
    },
  },
};
</script>
