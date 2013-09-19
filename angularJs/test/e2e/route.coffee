describe "E2E: Testing Routes", ->

  beforeEach -> browser().navigateTo('/')

  it 'should have a working /mqexample route', ->
    browser().navigateTo('#/mqexample')
    expect(browser().location().path()).toBe("/mqexample")
    expect(element('[ng-view]').html()).toContain('Message Queue Connector Libary Example')

  it 'should have a working /authexample route', ->
    browser().navigateTo('#/authexample')
    expect(browser().location().path()).toBe("/authexample")
    expect(element('[ng-view]').html()).toContain('authexample')
