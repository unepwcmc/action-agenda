export const setAxiosHeaders = axios => {
  const token = document.head.querySelector('meta[name="csrf-token"]')

  if (token) {
    axios.defaults.headers.common['X-CSRF-Token'] = token.content
    axios.defaults.headers.common['Content-Type'] = 'multipart/form-data'
  } else {
    console.error('CSRF token not found')
  }
}