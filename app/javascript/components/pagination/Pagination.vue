<template>
  <div class="pagination right">
    <div 
      class="pagination__content"
      v-if="haveResults"
    >
      <button
        class="pagination__button pagination__button--previous"
        :class="{ 'disabled': onFirstPage }"
        @click="changePage(currentPage - 1)"
        :disabled="onFirstPage"
      />

      <button
        v-for="(page, pageIndex) in pagesToShow"
        :key="pageIndex"
        class="pagination__button"
        :class="pageButtonClass(page)"
        @click="changePage(page)"
        :disabled="disabledPage(page)"
        v-text="page"
      />

      <button
        class="pagination__button pagination__button--next"
        :class="{ 'disabled': onLastPage }"
        @click="changePage(currentPage + 1)"
        :disabled="onLastPage"
      />
    </div>

    <div v-else class="left">
      <p>There are no evaluations matching the selected filters options.</p>
    </div>
  </div>
</template>

<script>
  export default {
    name: "pagination",

    props: {
      currentPage: {
        required: true,
        type: Number
      },
      itemsPerPage: {
        required: true,
        type: Number
      },
      totalItems: {
        required: true,
        type: Number
      },
      totalPages: {
        required: true,
        type: Number
      }
    },

    computed: {
      firstItem () {
        if (this.totalItems === 0) {
          return 0
        } else {
          return this.itemsPerPage * (this.currentPage - 1) + 1
        }
      },

      haveResults () {
        return this.totalItems > 0
      },

      lastItem () {
        if (this.currentPage === this.totalPages) {
          return this.totalItems
        } else {
          return this.currentPage * this.itemsPerPage
        }
      },

      nextIsActive () {
        return this.currentPage < this.totalPages
      },

      onFirstPage () {
        return this.currentPage === 1
      },

      onLastPage () {
        return this.currentPage === this.totalPages
      },

      previousIsActive () {
        return this.currentPage > 1
      },

      previousPage () {

      },

      pagesToShow () {
        // add first page, current page and last page
        const pages = [1, this.currentPage, this.totalPages]

        // add previous page if current page > 2
        if (this.currentPage > 2) {
          pages.push(this.currentPage - 1)
        }

        // add next page if current page is at least two pages before last
        if (this.currentPage < this.totalPages - 1) {
          pages.push(this.currentPage + 1)
        }

        // remove duplicates
        const uniquePages = Array.from(new Set (pages))

        // if on first or last page, add a third neighbouring page if there is one
        if (this.totalPages > 3 && uniquePages.length < 4) {
          const pageToAdd = this.currentPage === 1 ? 3 : this.totalPages - 2
          uniquePages.push(pageToAdd)
        }

        // sort pages
        const sortedUniquePages = uniquePages.sort((a, b) => {
          return a - b
        })

        // add ellipses between gaps in pages
        const gapIndices = []

        sortedUniquePages.forEach((page, pageIndex) => {
          const previousPage = sortedUniquePages[pageIndex - 1]

          if (previousPage && page !== previousPage + 1) {
            gapIndices.push(pageIndex)
          }
        })

        gapIndices.forEach((gapIndex, gapIndexIndex) => {
          // account for the index shift resulting from the first splice
          // on the second splice by adding the gapIndexIndex
          sortedUniquePages.splice(gapIndex + gapIndexIndex, 0, '...')
        })

        return sortedUniquePages
      }
    },

    methods: {
      changePage (page) {
        this.$store.dispatch('table/updateRequestedPage', page)
        this.$emit('updated:page')
      },

      disabledPage (page) {
        return ['...', this.currentPage].includes(page)
      },

      pageButtonClass (page) {
        const base = 'pagination__button--'

        if (page === '...') {
          return base + 'ellipsis'
        } else if (page === this.currentPage) {
          return base + 'current-page'
        } else {
         return base + 'non-current-page'
        }
      }
    }
  }
</script>
