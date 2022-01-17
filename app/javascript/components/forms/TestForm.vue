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

import * as widgets from "surveyjs-widgets";

// widgets.icheck(SurveyVue);
// widgets.select2(SurveyVue);
// widgets.inputmask(SurveyVue);
// widgets.jquerybarrating(SurveyVue);
// widgets.jqueryuidatepicker(SurveyVue);
// widgets.nouislider(SurveyVue);
// widgets.select2tagbox(SurveyVue);
// widgets.sortablejs(SurveyVue);
// widgets.ckeditor(SurveyVue);
// widgets.autocomplete(SurveyVue);
// widgets.bootstrapslider(SurveyVue);
// Survey.StylesManager.applyTheme("default");
SurveyVue.Serializer.addProperty("question", "tag:number");

export default {
  components: {
    Survey,
  },
  props: {},
  data() {
    var json = {
      title: "Form 1: criteria",
      description:
        "Form 1 will help establish whether this platform is the right place for your commitment. ‘Commitment’ refers to what you intend to do, for example, commitments to enhance/improve an existing area where new actions are planned or to establish a new area. ‘Area’ refers to the geographical area this is (or will be) under management as a result of this commitment.",
      pages: [
        {
          name: "page1",
          elements: [
            {
              type: "radiogroup",
              name: "boundary",
              title: "Does/will the area have a clearly-defined boundary?",
              isRequired: true,
              choices: [
                {
                  value: "true",
                  text:
                    "The area has, or will have, a clearly defined boundary",
                },
                {
                  value: "false",
                  text:
                    "The area does not and will not have a clearly defined boundary",
                },
              ],
            },
            {
              type: "checkbox",
              name: "cbd_objectives",
              title:
                "Please select the objectives of the Convention on Biological Diversity that your commitment contributes to",
              isRequired: true,
              choices: [
                "Conservation of biological diversity",
                "Sustainable use",
                "Fair and equitable sharing of benefits from the utilization of genetic resources",
              ],
              hasNone: true,
              noneText: "None of the above",
            },
            {
              type: "checkbox",
              name: "stakeholders",
              title: "Who is making the commitment?",
              isRequired: true,
              choices: [
                "Local communities",
                "Indigenous peoples",
                "Non-governmental organization (NGO)",
                "Private sector (business and industry)",
                "Sub-national or local government",
              ],
              hasNone: true,
              noneText: "None of the above",
            },
            {
              type: "radiogroup",
              name: "five_year_commitment",
              title: "Is the duration of the commitment at least 5 years?",
              isRequired: true,
              choices: [
                {
                  value: "true",
                  text: "Yes",
                },
                {
                  value: "false",
                  text: "No",
                },
              ],
            },
            {
              type: "radiogroup",
              name: "progress_report",
              title:
                "Are you able to submit annual progress reports to this platform?",
              isRequired: true,
              choices: [
                {
                  value: "true",
                  text: "Yes",
                },
                {
                  value: "false",
                  text: "No",
                },
              ],
            },
          ],
        },
      ],
      showPageTitles: false,
      completeText: "Submit",
      requiredText: "",
    };
    var model = new SurveyVue.Model(json);
    return {
      survey: model,
    };
  },
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}
</style>

Survey.StylesManager.applyTheme("default"); var json = { title: "Form 1:
criteria", description: "Form 1 will help establish whether this platform is the
right place for your commitment. ‘Commitment’ refers to what you intend to do,
for example, commitments to enhance/improve an existing area where new actions
are planned or to establish a new area. ‘Area’ refers to the geographical area
this is (or will be) under management as a result of this commitment.", pages: [
{ name: "page1", elements: [ { type: "radiogroup", name: "boundary", title:
"Does/will the area have a clearly-defined boundary?", isRequired: true,
choices: [ { value: "true", text: "The area has, or will have, a clearly defined
boundary" }, { value: "false", text: "The area does not and will not have a
clearly defined boundary" } ] }, { type: "checkbox", name: "cbd_objectives",
title: "Please select the objectives of the Convention on Biological Diversity
that your commitment contributes to", isRequired: true, choices: [ "Conservation
of biological diversity", "Sustainable use", "Fair and equitable sharing of
benefits from the utilization of genetic resources" ], hasNone: true, noneText:
"None of the above" }, { type: "checkbox", name: "stakeholders", title: "Who is
making the commitment?", isRequired: true, choices: [ "Local communities",
"Indigenous peoples", "Non-governmental organization (NGO)", "Private sector
(business and industry)", "Sub-national or local government" ], hasNone: true,
noneText: "None of the above" }, { type: "radiogroup", name:
"five_year_commitment", title: "Is the duration of the commitment at least 5
years?", isRequired: true, choices: [ { value: "true", text: "Yes" }, { value:
"false", text: "No" } ] }, { type: "radiogroup", name: "progress_report", title:
"Are you able to submit annual progress reports to this platform?", isRequired:
true, choices: [ { value: "true", text: "Yes" }, { value: "false", text: "No" }
] } ] } ], showPageTitles: false, completeText: "Submit", requiredText: "" };
window.survey = new Survey.Model(json); survey.onComplete.add(function (sender)
{ document.querySelector("#surveyResult").textContent = "Result JSON:\n" +
JSON.stringify(sender.data, null, 3); }); var app = new Vue({ el:
"#surveyElement", data: { survey: survey } });
