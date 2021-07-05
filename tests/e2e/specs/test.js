// https://docs.cypress.io/api/introduction/api.html

describe('My First Test', {
  baseUrl: 'http://localhost:8082'
}, () => {
  it('Visits the app root url', () => {
    cy.visit('/')
    cy.contains('h1', 'Welcome to Vuetify')
  })
})
