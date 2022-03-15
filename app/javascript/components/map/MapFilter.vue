 <template>
  <div>
    <input v-model="search" />
  </div>
</template>
 
 <script>
export default {
  name: "MapFilter",

  props: {},

  data() {
    return {
      search: "",
    };
  },

  updated () {
    console.log(this.search)
  }
};
</script>