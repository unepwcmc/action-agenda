 <template>
  <div class="map__filter">
    <form>
      <div>
        <span class="map__filter-icon"/> 
        <input
          v-model="search"
          @input="onChange"
          :placeholder="placeholder"
          @keydown.down.prevent="onArrowDown"
          @keydown.up.prevent="onArrowUp"
          @keydown.enter.prevent="setResult(keyResult)"
          type="text"
        />
      </div>
      <ul
        class="map__filter-dropdown"
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
    placeholder: {
      type: String,
      default: "Search"
    }
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

    keyResult() {
      return this.results[this.arrowCounter]
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

    onArrowUp() {
      this.arrowCounter > 0
        ? (this.arrowCounter = this.arrowCounter - 1)
        : (this.arrowCounter = this.results.length - 1)
    },
    
    onArrowDown() {
      this.arrowCounter < this.results.length
        ? (this.arrowCounter = this.arrowCounter + 1)
        : (this.arrowCounter = 0)
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
        this.$root.$emit('selected', result)
      }
    },
  },
};
</script>