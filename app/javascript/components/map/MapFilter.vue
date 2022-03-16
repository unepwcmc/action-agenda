 <template>
  <div>
    <form>
      <div>
        <input
          v-model="search"
          @input="onChange()"
          placeholder="placeholder"
          @keydown.down.prevent="onArrowDown"
          @keydown.up.prevent="onArrowUp"
          @keydown.enter.prevent="setResult(keyResult)"
          type="text"
        />
        <span @click="toggleDropdown" />
      </div>
      <ul
        class="relative z-10 border max-h-64 p-3 bg-white overflow-auto"
        v-show="isOpen"
      >
        <li v-if="resultsLengthZero">No results</li>
        <li
          v-else
          v-for="(result, key) in results"
          :key="key"
          :result="result[searchKey]"
          @click="setResult(result)"
          :class="{ 'is-active': key === arrowCounter }"
          v-html="result[searchKey]"
        />
      </ul>
    </form>
  </div>
</template>
 
 <script>
export default {
  name: "MapFilter",

  props: {
    items: {
      type: Array,
    },
    searchKey: {
      type: String,
    },
  },

  data() {
    return {
      search: "",
      results: [],
      isOpen: false,
      arrowCounter: -1,
      hasSelectedResult: false,
    };
  },

  computed: {
    resultsLengthZero() {
      return this.results.length === 0
    },
  },

  updated() {
    console.log(this.search);
  },

  methods: {
    
    filterResults() {
      this.results = this.items.filter((item) => {
        return (
          item[this.searchKey]
            .toLowerCase()
            .indexOf(this.search.toLowerCase()) > -1
        );
      });
    },

    onChange() {
      this.filterResults();
      this.isOpen = true
      this.hasSelectedResult = false
    },

    setResult(result) {
      if (result) {
        this.hasSelectedResult = true
        this.search = result[this.searchKey]
        this.isOpen = false
        // this.submitItem(result)
        this.$root.$emit('selected', result)
      }
    },

    toggleDropdown() {
      this.isOpen ? (this.isOpen = false) : (this.isOpen = true);
    },
  },
};
</script>